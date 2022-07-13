//
//  FolderItem.m
//  downloader
//
//  Created by LAP14812 on 13/07/2022.
//

#import "FolderItem.h"

@implementation FolderItem
- (instancetype)initWithFileItem:(FileItem *)fileItem andParentFolders:(NSArray<NSURL *> *)parentDirectories{
    self = [super init];
    if(self){
        self.name = fileItem.name;
        self.size = fileItem.size;
        self.url = fileItem.url;
        self.type = fileItem.type;
        self.createdDate = fileItem.createdDate;
        self.isDir = true;
        self.parentFolders = [NSMutableArray arrayWithArray:parentDirectories];
        self.directParentName = [[parentDirectories lastObject] lastPathComponent];
        self.allFileItems = [[NSMutableArray alloc] init];
        self.isRootFolder = false;
    }
    return self;
}

- (instancetype) initRootFolder{
    self = [super init];
    if(self){
        self.name = @"Downloads";
        self.url = [[NSFileManager defaultManager] URLForDirectory:NSDownloadsDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:true error: nil];
        self.type = [FileTypeConstants unknown];
        self.isDir = true;
        self.parentFolders = [[NSMutableArray alloc] init];
        self.directParentName = @"";
        self.allFileItems = [[NSMutableArray alloc] init];
        self.isRootFolder = true;
    }
    return self;
}

- (NSArray<FileItem*>*) getFileItems{
    return [NSArray arrayWithArray: self.allFileItems];
}

@end
