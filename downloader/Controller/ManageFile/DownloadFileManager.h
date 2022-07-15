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
- (BOOL) isExitsFileName: (NSString*) fileName inFolder: (NSURL*) url;
- (BOOL) isExitsFolderName: (NSString*) folderName inFolder: (NSURL*) url;
- (BOOL) renameFileOf: (FileItem*) fileItem toNewName: (NSString*) newName;
- (BOOL) removeFile: (FileItem*) fileItem fromFolder: (FolderItem*) folder;
- (void) removeTempFolderFromFolder: (FolderItem*) folder;
- (BOOL) createNewFolder: (NSString*) folderName inFolder: (FolderItem*) folder;
- (BOOL) showRefetchDataOfFolder: (FolderItem*) folderItem;
- (BOOL) canMove: (FileItem*) source to: (FolderItem*) destination;
- (BOOL) moveFile: (FileItem*) source toFolder: (FolderItem*) destination;
- (void) copyFile: (FileItem*) fileItem;
- (BOOL) pasteFileTo: (FolderItem*) destinationFolder;
- (BOOL) shouldShowPaste;
- (BOOL) copyFileAtURL: (NSURL*) source toFolder: (FolderItem*) destinationFolder;
@end

NS_ASSUME_NONNULL_END
