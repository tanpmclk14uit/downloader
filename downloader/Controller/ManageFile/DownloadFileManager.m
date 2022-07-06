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
    }
    return self;
}

- (NSArray<FileItem*>*) getFileItems{
    return [NSArray arrayWithArray: self.allFileItems];
}

- (void) fetchAllFileOfDownloadFolderWithCompleteHandler:(void (^)(void))completionHandler{
    NSError* error = nil;
    NSURL* downloadsURL = [[NSFileManager defaultManager] URLForDirectory:NSDownloadsDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:true error: &error];
    if(error){
        NSLog(@"%@", @"Error");
    }else{
        [self.allFileItems removeAllObjects];
        NSArray<NSURL*> *listFile = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:downloadsURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
        for(NSURL* file in listFile){
            NSError* attributeError = nil;
            NSDictionary* fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:file.path error: &attributeError];
            if(error){
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
        completionHandler();
    }
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

@end
