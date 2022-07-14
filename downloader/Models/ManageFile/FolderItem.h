//
//  FolderItem.h
//  downloader
//
//  Created by LAP14812 on 13/07/2022.
//

#import "FileItem.h"
#import "FileTypeConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface FolderItem : FileItem
@property(assign, atomic) BOOL isRootFolder;
@property(strong, atomic) NSMutableArray<NSURL*>* parentFolders;
@property(strong, atomic) NSString* directParentName;
@property(strong, atomic) NSMutableArray<FileItem*> *allFileItems;

- (instancetype)initWithFileItem: (FileItem*) fileItem andParentFolders: (NSArray<NSURL*>*) parentDirectories;
- (NSArray<FileItem*>*) getFileItems;
- (NSArray<NSString*>*) getNamesOfParentFolder;
+ (FolderItem*) rootFolder;

@end

NS_ASSUME_NONNULL_END
