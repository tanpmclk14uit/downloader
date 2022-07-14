//
//  FileManager.m
//  downloader
//
//  Created by LAP14812 on 01/07/2022.
//

#import "DownloadFileManager.h"
#import "FileItem.h"


@interface DownloadFileManager ()
@property(strong, nonatomic) NSFileManager* fileManager;
@property(strong, nonatomic) NSMutableSet<NSURL*>* needReloadFoldes;
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
        self.fileManager = [NSFileManager defaultManager];
        self.needReloadFoldes = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)fetchAllFileOfFolder:(FolderItem *)folder withAfterCompleteHandler:(void (^)(void))completionHandler{
    [folder.allFileItems removeAllObjects];
    NSArray<NSURL*> *listFile = [_fileManager contentsOfDirectoryAtURL: folder.url includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
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
                    if(isDir){
                        NSMutableArray <NSURL*>* parentFolders = [NSMutableArray arrayWithArray:folder.parentFolders];
                        [parentFolders addObject: folder.url];
                        FileItem* folderItem = [[FolderItem alloc] initWithFileItem:fileItem andParentFolders: parentFolders];
                        [folder.allFileItems addObject:folderItem];
                    }else{
                        [folder.allFileItems addObject:fileItem];
                    }
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
    NSURL* destinationURL = [[url URLByDeletingLastPathComponent] URLByAppendingPathComponent: destinationFileName];
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

- (BOOL) removeFile:(FileItem *)fileItem fromFolder:(FolderItem *)folder{
    NSError *error = nil;
    [_fileManager removeItemAtURL:fileItem.url error:&error];
    if(error){
        return false;
    }else{
        [folder.allFileItems removeObject:fileItem];
        [_needReloadFoldes addObjectsFromArray:folder.parentFolders];
        return true;
    }
}

- (void) removeTempFolderFromFolder:(FolderItem *)folder{
    NSArray<NSURL*> *listFile = [_fileManager contentsOfDirectoryAtURL: folder.url includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    for(NSURL* file in listFile){
        if([self isTempFile:file]){
            [_fileManager removeItemAtURL:file error:nil];
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

- (BOOL)createNewFolder:(NSString *)folderName inFolder:(FolderItem *)folder{
    NSURL* directoryPath = [folder.url URLByAppendingPathComponent:folderName];
    if( [_fileManager createDirectoryAtURL:directoryPath withIntermediateDirectories:NO attributes:nil error:nil]){
        [_needReloadFoldes addObject:folder.url];
        [_needReloadFoldes addObjectsFromArray:folder.parentFolders];
        return true;
    }else{
        return false;
    }
}

- (BOOL)showRefetchDataOfFolder:(FolderItem *)folderItem{
    if([_needReloadFoldes containsObject:folderItem.url]){
        [_needReloadFoldes removeObject:folderItem.url];
        return true;
    }else{
        return false;
    }
}

- (BOOL)canMove:(FileItem *)source to:(FolderItem *)destination{
    if(source.isDir){
        return ![destination.parentFolders containsObject: source.url] &&
        ![[[source.url URLByDeletingLastPathComponent] absoluteString] isEqualToString:[destination.url absoluteString]] &&
        ![[source.url absoluteString] isEqualToString:[destination.url absoluteString]];
    }else{
        return ![[[source.url URLByDeletingLastPathComponent] absoluteString] isEqualToString:[destination.url absoluteString]];
    }
}

-(BOOL)moveFile:(FileItem *)source toFolder:(FolderItem *)destination{
    if([self canMove:source to:destination]){
        if([_fileManager isReadableFileAtPath:source.url.path]){
            NSError* error = nil;
            NSString* destinationName = source.url.lastPathComponent;
            NSURL* destinationURL = [destination.url URLByAppendingPathComponent:destinationName];
            [_fileManager moveItemAtURL:source.url toURL:destinationURL error:&error];
            if(error){
                NSLog(@"%@", error.userInfo);
                return false;
            }else{
                return true;
            }
        }else{
            return false;
        }
    }else{
        return false;
    }
}

@end
