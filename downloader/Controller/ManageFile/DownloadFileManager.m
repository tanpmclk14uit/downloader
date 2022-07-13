//
//  FileManager.m
//  downloader
//
//  Created by LAP14812 on 01/07/2022.
//

#import "DownloadFileManager.h"
#import "FileItem.h"


@interface DownloadFileManager ()
@property(strong, atomic) NSMutableArray<FileItem*> *allFileItems;
@property(strong, nonatomic) NSFileManager* fileManager;
@property(assign, nonatomic) BOOL isRootDirectory;
@end

@implementation DownloadFileManager
+ (DownloadFileManager*) sharedInstance{
    static DownloadFileManager* sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DownloadFileManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init{
    self = [super init];
    if(self){
        self.allFileItems = [[NSMutableArray alloc] init];
        self.fileManager = [NSFileManager defaultManager];
        self.currentDirectory = [_fileManager URLForDirectory:NSDownloadsDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:true error: nil];
        self.isRootDirectory = true;
        self.parentDirectories = [[NSMutableArray alloc]init];
        self.directoryName = [_currentDirectory lastPathComponent];
        self.directParentName= @"";
    }
    return self;
}

- (void)backToSelectedParentDirectory:(NSURL *)selectedDirectory{
    for(NSInteger i = _parentDirectories.count-1; i>=0; i--){
        if(_parentDirectories[i] == selectedDirectory){
            self.currentDirectory = _parentDirectories[i];
            self.directoryName = [_currentDirectory lastPathComponent];
            self.directParentName = [[self.parentDirectories lastObject] lastPathComponent];
            [_parentDirectories removeObject:_parentDirectories[i]];
            return;
        }else{
            [_parentDirectories removeObject:_parentDirectories[i]];
        }
    }
}

- (void)navigateToDirectory:(NSURL *)url{
    if(url == [_fileManager URLForDirectory:NSDownloadsDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:true error: nil]){
        self.isRootDirectory = true;
    }else{
        self.isRootDirectory = false;
    }
    [self removeTempFolder];
    [self.parentDirectories addObject:self.currentDirectory];
    self.directoryName = [url lastPathComponent];
    self.directParentName = [self.currentDirectory lastPathComponent];
    self.currentDirectory = url;
}

- (void)backToParentDirectory{
    self.currentDirectory = [self.parentDirectories lastObject];
    self.directoryName = _currentDirectory.lastPathComponent;
    self.directParentName = [[self.parentDirectories lastObject] lastPathComponent];
    [self.parentDirectories removeLastObject];
    [self removeTempFolder];
    _isRootDirectory = self.parentDirectories.count == 0;
    
}

- (NSArray<FileItem*>*) getFileItems{
    return [NSArray arrayWithArray: self.allFileItems];
}

- (void) fetchAllFileOfDownloadFolderWithCompleteHandler:(void (^)(void))completionHandler{
    
    [self.allFileItems removeAllObjects];
    NSArray<NSURL*> *listFile = [_fileManager contentsOfDirectoryAtURL:_currentDirectory includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    if(listFile){
        for(NSURL* file in listFile){
            if(![self isTempFile:file]){
                NSError* attributeError = nil;
                NSDictionary* fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:file.path error: &attributeError];
                if(attributeError){
                    NSLog(@"%@", @"Get attribute error");
                }else{
                    BOOL isDir = [[fileAttributes objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory];
                    NSDate *creationDate = (NSDate *)[fileAttributes objectForKey:NSFileCreationDate];
                    FileTypeEnum* fileType = [self getFileTypeFromFileExtension:[file pathExtension]];
                    NSString* fileName = [file lastPathComponent];
                    NSNumber *fileSizeNumber;
                    if(isDir){
                        fileSizeNumber =  [NSNumber numberWithInteger:[self getTotalItemOfURL:file]];
                    }else{
                        fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
                    }
                    FileItem* fileItem = [[FileItem alloc]initWithName:fileName andSize: fileSizeNumber andCreateDate:creationDate andType: fileType andURL:file];
                    fileItem.isDir = isDir;
                    [self.allFileItems addObject:fileItem];
                }
            }
        }
    }
    completionHandler();
}

- (NSInteger) getTotalItemOfURL: (NSURL*) url{
    NSError* error;
    NSArray<NSURL*> *listFile = [_fileManager contentsOfDirectoryAtURL:url includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
    if(error){
        return 0;
    }else{
        return listFile.count;
    }
}


- (BOOL)isExitsFileName:(NSString *)fileName inURL:(NSURL *)url{
    NSString* destinationFileName = [fileName stringByAppendingPathExtension: url.pathExtension];
    NSURL* destinationURL = [_currentDirectory URLByAppendingPathComponent: destinationFileName];
    return [_fileManager fileExistsAtPath:destinationURL.path isDirectory: false];
}

- (BOOL) renameFileOf:(FileItem *)fileItem toNewName:(NSString *)newName{
    NSURL* currentWorkingPath = [fileItem.url URLByDeletingLastPathComponent];
    NSString* destinationFileName = [newName stringByAppendingPathExtension: fileItem.url.pathExtension];
    NSURL* destinationURL = [currentWorkingPath URLByAppendingPathComponent: destinationFileName];
    NSError *error = nil;
    if([_fileManager moveItemAtURL:fileItem.url toURL:destinationURL error: &error]){
        fileItem.name = [destinationURL lastPathComponent];
        fileItem.url = destinationURL;
        return true;
    }else{
        return false;
    }
}

- (BOOL)removeFile:(FileItem *)fileItem{
    NSError *error = nil;
    [_fileManager removeItemAtURL:fileItem.url error:&error];
    if(error){
        return false;
    }else{
        [_allFileItems removeObject:fileItem];
        return true;
    }
}

- (void)removeTempFolder{
    if(_allFileItems.count != 0){
        NSURL* currentWorkingPath = [_allFileItems[0].url URLByDeletingLastPathComponent];
        NSArray<NSURL*> *listFile = [_fileManager contentsOfDirectoryAtURL:currentWorkingPath includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
        for(NSURL* file in listFile){
            if([self isTempFile:file]){
                [_fileManager removeItemAtURL:file error:nil];
            }
        }
    }
}

- (BOOL) isTempFile: (NSURL*)file{
    NSString* downloaderTempFilePath = @"(A Document Being Saved By downloader";
    NSString* archieveTempFilePath = @"(A Document Being Saved By ArchiveService";
    NSString* quickLookTempFilePath = @"com.apple.quicklook.extension.previewUI";
    return [file.lastPathComponent containsString: downloaderTempFilePath] ||
    [file.lastPathComponent containsString:archieveTempFilePath] ||
    [file.lastPathComponent containsString:quickLookTempFilePath];
}


- (void)decompressZipFile:(FileItem *)fileItem{
    NSURL* currentWorkingPath = [fileItem.url URLByDeletingLastPathComponent];
    NSString* folderName = [fileItem.name stringByDeletingPathExtension];
    NSURL* destinationURL = [currentWorkingPath URLByAppendingPathComponent: folderName];
    NSError * error = nil;
    
    [_fileManager createDirectoryAtURL:destinationURL withIntermediateDirectories:YES attributes:nil error: &error];
}

- (FileTypeEnum*) getFileTypeFromFileExtension: (NSString*) extension{
    if([FileTypeConstants.pdf.extensionList containsObject:extension]){
        return FileTypeConstants.pdf;
    }
    if([FileTypeConstants.image.extensionList containsObject:extension]){
        return FileTypeConstants.image;
    }
    if([FileTypeConstants.text.extensionList containsObject:extension]){
        return FileTypeConstants.text;
    }
    if([FileTypeConstants.video.extensionList containsObject:extension]){
        return FileTypeConstants.video;
    }
    if([FileTypeConstants.audio.extensionList containsObject:extension]){
        return FileTypeConstants.audio;
    }
    if([FileTypeConstants.zip.extensionList containsObject:extension]){
        return FileTypeConstants.zip;
    }
    return FileTypeConstants.unknown;
}

- (BOOL)createNewFolder:(NSString *)folderName{
    NSURL* directoryPath = [_currentDirectory URLByAppendingPathComponent:folderName];
    return [_fileManager createDirectoryAtURL:directoryPath withIntermediateDirectories:NO attributes:nil error:nil];
}

@end
