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
@property(assign, atomic) BOOL needReloadRootFolder;
@property(strong, nonatomic, nullable) FileItem* fileToCopy;

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
        self.needReloadRootFolder = false;
    }
    return self;
}

- (FileItem*) createFileItemByURL: (NSURL*) file{
    NSError* attributeError = nil;
    NSDictionary* fileAttributes = [_fileManager attributesOfItemAtPath:file.path error: &attributeError];
    if(attributeError){
        NSLog(@"%@", @"Get attribute fail");
        return nil;
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
        return fileItem;
    }
}

- (void)fetchAllFileOfFolder:(FolderItem *)folder withAfterCompleteHandler:(void (^)(void))completionHandler{
    [folder.allFileItems removeAllObjects];
    NSError* error = nil;
    NSArray<NSURL*> *fileURLs = [_fileManager contentsOfDirectoryAtURL: folder.url includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
    if(!error){
        for(NSURL* url in fileURLs){
            if(![self isTempFile:url]){
                FileItem* fileItem = [self createFileItemByURL:url];
                if(fileItem){
                    if(fileItem.isDir){
                        NSMutableArray <NSURL*>* parentFolders = [NSMutableArray arrayWithArray:folder.parentFolders];
                        [parentFolders addObject: folder.url];
                        FileItem* folderItem = [[FolderItem alloc] initWithFileItem:fileItem andParentFolders: parentFolders];
                        [folder.allFileItems addObject:folderItem];
                    }else{
                        [folder.allFileItems addObject:fileItem];
                    }
                }else{
                    NSLog(@"%@", @"Create file fail");
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

- (BOOL)isExitsFileName:(NSString *)fileName inFolder:(NSURL *)url{
    NSString* destinationFileName = [fileName stringByAppendingPathExtension: url.pathExtension];
    NSURL* destinationURL = [[url URLByDeletingLastPathComponent] URLByAppendingPathComponent: destinationFileName];
    return [_fileManager fileExistsAtPath:destinationURL.path isDirectory: false];
}

- (BOOL) isExitsFolderName:(NSString *)folderName inFolder:(NSURL *)url{
    NSURL* destinationURL = [url URLByAppendingPathComponent: folderName];
    return [_fileManager fileExistsAtPath:destinationURL.path isDirectory: false];
}

- (BOOL) renameFile:(FileItem *)fileItem toNewName:(NSString *)newName{
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
        _fileToCopy = nil;
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
        return true;
    }else{
        return false;
    }
}

- (BOOL) shouldClearSearchSortAndFilterDataOfFolder{
    return _needReloadRootFolder;
}

- (void) refreshSuccess{
    _needReloadRootFolder = false;
}

- (void) rootFolderShouldReload{
    _needReloadRootFolder = true;
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
            NSURL* destinationURL;
            if(_fileToCopy.isDir){
                destinationURL = [self getValidDestinationURLForMoveAndCopyForFolder:source.url toURL:destination.url];
            }else{
                destinationURL = [self getValidDestinationURLForMoveAndCopyForFile: source.url toURL:destination.url];
            }
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

- (BOOL)shouldShowPaste{
    return self.fileToCopy != nil;
}

- (void)copyFile:(FileItem *)fileItem{
    _fileToCopy = fileItem;
}

- (BOOL)pasteCopiedFileTo:(FolderItem *)destinationFolder{
    if(_fileToCopy != nil){
        NSError *error = nil;
        NSURL* destinationURL;
        if(_fileToCopy.isDir){
            destinationURL = [self getValidDestinationURLForMoveAndCopyForFolder:_fileToCopy.url toURL:destinationFolder.url];
        }else{
            destinationURL = [self getValidDestinationURLForMoveAndCopyForFile: _fileToCopy.url toURL:destinationFolder.url];
        }
        [_fileManager copyItemAtURL:_fileToCopy.url toURL:destinationURL error:&error];
        if(error){
            _fileToCopy = nil;
            return false;
        }else{
            return true;
        }
    }else{
        _fileToCopy = nil;
        return false;
    }
}

- (NSURL*) getValidDestinationURLForMoveAndCopyForFolder: (NSURL*) source toURL: (NSURL*) url {
    NSString* fileName = source.lastPathComponent;
    NSURL* destinationURL;
    NSInteger i = 0;
    do {
        NSString* subFix = (i > 0) ? [NSString stringWithFormat: @"(%li)", i] : @"";
        NSString* destinationName = [fileName stringByAppendingString: subFix];
        destinationURL = [url URLByAppendingPathComponent:destinationName];
        i += 1;
    } while ([_fileManager fileExistsAtPath:destinationURL.path isDirectory:false]);
    return destinationURL;
}

- (NSURL*) getValidDestinationURLForMoveAndCopyForFile: (NSURL*) source toURL: (NSURL*) url {
    NSString* fileName = source.lastPathComponent;
    NSURL* destinationURL;
    NSInteger i = 0;
    do{
        NSString* subFix = (i > 0) ? [NSString stringWithFormat: @"(%li).", i] : @".";
        NSString* absoluteName = [fileName stringByDeletingPathExtension];
        NSString* destinationName = [[absoluteName stringByAppendingString:subFix] stringByAppendingString:[source pathExtension]];
        destinationURL = [url URLByAppendingPathComponent:destinationName];
        i += 1;
    }while([_fileManager fileExistsAtPath:destinationURL.path isDirectory:false]);
    return destinationURL;
}

- (BOOL)copyFileAtURL:(NSURL *)source toFolder:(FolderItem *)destinationFolder{
    NSError *error = nil;
    NSURL* destinationURL = [self getValidDestinationURLForMoveAndCopyForFile:source toURL:destinationFolder.url];
    [_fileManager copyItemAtURL: source toURL:destinationURL error:&error];
    if(error){
        return false;
    }else{
        return true;
    }
}
@end
