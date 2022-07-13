//
//  FileManager.h
//  downloader
//
//  Created by LAP14812 on 01/07/2022.
//

#import <Foundation/Foundation.h>
#import "FileItem.h"
#import "FileTypeConstants.h"
#import "FolderItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface DownloadFileManager : NSObject
+ (DownloadFileManager*) sharedInstance;
- (void) fetchAllFileOfFolder: (FolderItem*) folderItem withAfterCompleteHandler: (void (^)(void)) completionHandler;
- (void) decompressZipFile: (FileItem*) fileItem;
- (BOOL) isExitsFileName: (NSString*) fileName inURL: (NSURL*) url;
- (BOOL) renameFileOf: (FileItem*) fileItem toNewName: (NSString*) newName;
- (BOOL) removeFile: (FileItem*) fileItem fromFolder: (FolderItem*) folder;
- (void) removeTempFolderFromFolder: (FolderItem*) folder;
- (BOOL) createNewFolder: (NSString*) folderName inFolder: (FolderItem*) folder;

@end

NS_ASSUME_NONNULL_END
