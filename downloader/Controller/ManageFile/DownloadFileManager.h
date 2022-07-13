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
@property(strong, nonatomic) FolderItem* currentFolder;
+ (DownloadFileManager*) sharedInstance;
- (void) fetchAllFileOfDownloadFolderWithCompleteHandler: (void (^)(void)) completionHandler;
- (void) decompressZipFile: (FileItem*) fileItem;
- (BOOL) isExitsFileName: (NSString*) fileName inURL: (NSURL*) url;
- (BOOL) renameFileOf: (FileItem*) fileItem toNewName: (NSString*) newName;
- (BOOL) removeFile: (FileItem*) fileItem;
- (void) removeTempFolder;
- (BOOL) createNewFolder: (NSString*) folderName;

@end

NS_ASSUME_NONNULL_END
