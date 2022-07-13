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
@property(strong, nonatomic) NSURL* currentDirectory;
@property(assign, nonatomic, readonly) BOOL isRootDirectory;
@property(strong, nonatomic) NSMutableArray<NSURL*>* parentDirectories;
@property(strong, nonatomic) NSString* directoryName;
@property(strong, nonatomic) NSString* directParentName;
+ (DownloadFileManager*) sharedInstance;
- (NSArray<FileItem*>*) getFileItems;
- (void) fetchAllFileOfDownloadFolderWithCompleteHandler: (void (^)(void)) completionHandler;
- (void) decompressZipFile: (FileItem*) fileItem;
- (BOOL) isExitsFileName: (NSString*) fileName inURL: (NSURL*) url;
- (BOOL) renameFileOf: (FileItem*) fileItem toNewName: (NSString*) newName;
- (BOOL) removeFile: (FileItem*) fileItem;
- (void) removeTempFolder;
- (BOOL) createNewFolder: (NSString*) folderName;
- (void) navigateToDirectory: (NSURL*) url;
- (void) backToParentDirectory;
- (void) backToSelectedParentDirectory: (NSURL*) selectedDirectory;

@end

NS_ASSUME_NONNULL_END
