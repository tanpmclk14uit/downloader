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
@property(strong, atomic) NSFileManager* fileManager;
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
        self.currentFolderDirectory = [_fileManager URLForDirectory:NSDownloadsDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:true error: nil];
    }
    return self;
}

- (NSArray<FileItem*>*) getFileItems{
    return [NSArray arrayWithArray: self.allFileItems];
}

- (void) fetchAllFileOfDownloadFolderWithCompleteHandler:(void (^)(void))completionHandler{
    
    [self.allFileItems removeAllObjects];
    NSArray<NSURL*> *listFile = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:_currentFolderDirectory includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    for(NSURL* file in listFile){
        if(![self isTempFile:file]){
            NSError* attributeError = nil;
            NSDictionary* fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:file.path error: &attributeError];
            if(attributeError){
                NSLog(@"%@", @"Get attribute error");
            }else{
                NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
                NSDate *creationDate = (NSDate *)[fileAttributes objectForKey:NSFileCreationDate];
                FileTypeEnum* fileType = [self getFileTypeFromFileExtension:[file pathExtension]];
                NSString* fileName = [file lastPathComponent];
                FileItem* fileItem = [[FileItem alloc]initWithName:fileName andSize: fileSizeNumber andCreateDate:creationDate andType: fileType andURL:file];
                [self.allFileItems addObject:fileItem];
            }
        }
    }
    completionHandler();
}

- (BOOL)isExitsFileName:(NSString *)fileName inURL:(NSURL *)url{
    NSURL* currentWorkingPath = [url URLByDeletingLastPathComponent];
    NSString* destinationFileName = [fileName stringByAppendingPathExtension: url.pathExtension];
    NSURL* destinationURL = [currentWorkingPath URLByAppendingPathComponent: destinationFileName];
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
    NSURL* directoryPath = [_currentFolderDirectory URLByAppendingPathComponent:folderName];
    return [_fileManager createDirectoryAtURL:directoryPath withIntermediateDirectories:NO attributes:nil error:nil];
}

@end
