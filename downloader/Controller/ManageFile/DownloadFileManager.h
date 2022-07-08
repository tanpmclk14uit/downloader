//
//  FileManager.h
//  downloader
//
//  Created by LAP14812 on 01/07/2022.
//

#import <Foundation/Foundation.h>
#import "FileItem.h"
#import "FileTypeConstants.h"
NS_ASSUME_NONNULL_BEGIN

@interface DownloadFileManager : NSObject
+ (DownloadFileManager*) sharedInstance;
- (NSArray<FileItem*>*) getFileItems;
- (void) fetchAllFileOfDownloadFolderWithCompleteHandler: (void (^)(void)) completionHandler;
- (void) decompressZipFile: (FileItem*) fileItem;
- (BOOL) isExitsFileName: (NSString*) fileName inURL: (NSURL*) url;
- (BOOL) renameFileOf: (FileItem*) fileItem toNewName: (NSString*) newName;
@end

NS_ASSUME_NONNULL_END