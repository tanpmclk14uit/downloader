//
//  DowloadItem.m
//  downloader
//
//  Created by LAP14812 on 07/06/2022.
//

#import "DownloadItem.h"

@implementation DownloadItem
- (instancetype)initWithName:(NSString *)name AndDownloadLink:(NSString *)downloadLink{
    self = [super init];
    if(self){
        self.name = name;
        self.downloadLink = downloadLink;
        self.downloadedCount = (int) self.getDownloadedCopiesFromFile.count;
        self.downloadingCount = 0;
        self.shouldShowCopiesItem = false;
        self.dowloadedCopiesString = @"";
        self.dispatchQueueForThreadSafe = dispatch_queue_create("dispath-queue-for-thread-safe", DISPATCH_QUEUE_SERIAL);
        self.downloadedCopies = (NSMutableArray*) [self getDownloadedCopiesFromFile];
        self.downloadingTasks = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addNewDownloadedCopy:(NSString *)copyName{
    dispatch_async(_dispatchQueueForThreadSafe, ^{
        [self.downloadedCopies addObject:copyName];
    });
}
- (void) deleteDownloadedCopy:(NSString *)copyName{
    dispatch_async(_dispatchQueueForThreadSafe, ^{
        [self.downloadedCopies removeObject:copyName];
    });
}
- (void) addNewDownloadingTask:(DownloadingTask *)downloadingTask{
    dispatch_async(_dispatchQueueForThreadSafe, ^{
        [self.downloadingTasks addObject:downloadingTask];
    });
}
- (void) completeDownloadingTask:(NSString *)taskId{
    dispatch_async(_dispatchQueueForThreadSafe, ^{
        for (DownloadingTask *completeTask in self.downloadingTasks){
            if(completeTask.taskId == taskId){
                [self removeDowloadingTask:completeTask];
            }
        }
    });
}
- (void) removeDowloadingTask: (DownloadingTask*) downloadingTask{
    dispatch_async(_dispatchQueueForThreadSafe, ^{
        [self.downloadingTasks removeObject: downloadingTask];
    });
}

- (void) cancelRandomDownloadingTask{
    dispatch_async(_dispatchQueueForThreadSafe, ^{
        uint32_t randomTaskIndex = arc4random_uniform(self.downloadingCount);
        DownloadingTask *randomTask = [self.downloadingTasks objectAtIndex:randomTaskIndex];
        [randomTask.task suspend];
        [self removeDowloadingTask: randomTask];
        self.downloadingCount -=1;
    });
}

- (NSString*) getAllDownloadedCopiesToString{
    self.dowloadedCopiesString = @"";
    dispatch_sync(_dispatchQueueForThreadSafe, ^{
        for(NSString* fileName in self.downloadedCopies){
            self.dowloadedCopiesString = [self.dowloadedCopiesString stringByAppendingFormat:@"%@\n", fileName];
        }
    });
    return self.dowloadedCopiesString;
}

- (BOOL)isEqual:(DownloadItem*)object{
    return object.name == self.name;
}

- (NSArray<NSString *> *)getDownloadedCopiesFromFile{
    NSError* error = nil;
    NSMutableArray <NSString *> *listFileName = [[NSMutableArray alloc] init];
    NSURL* documentsURL = [[NSFileManager defaultManager] URLForDirectory: NSDocumentDirectory inDomain: NSUserDomainMask appropriateForURL: nil create: NO error: &error];
    if(error){
        NSLog(@"%@", @"Error");
        return listFileName;
        
    }else{
        NSArray<NSURL*> *listFile = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:documentsURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
        
        for(NSURL* file in listFile){
            NSString *fileName = [file lastPathComponent];
            if([fileName containsString:self.name]){
                [listFileName addObject: fileName];
            }
        }
        return listFileName;
    }
}

- (Boolean) removeDownloadedCopySuccess{
    if(self.downloadedCount == 0){
        return false;
    }else{
        NSError* error = nil;
        uint32_t randomCopyIndex = arc4random_uniform(self.downloadedCount);
        NSArray <NSString *> *listFileName = [self getDownloadedCopiesFromFile];
        NSString *randomCopyName = [listFileName objectAtIndex:randomCopyIndex];
        NSURL* documentsURL = [[NSFileManager defaultManager] URLForDirectory: NSDocumentDirectory inDomain: NSUserDomainMask appropriateForURL: nil create: NO error: &error];
        NSURL* deleteFileURL = [documentsURL URLByAppendingPathComponent:randomCopyName];
        if([[NSFileManager defaultManager] removeItemAtURL:deleteFileURL error:&error]){
            self.downloadedCount-=1;
            [self deleteDownloadedCopy:randomCopyName];
            return true;
        }else{
            return false;
        }
    }
}

@end
