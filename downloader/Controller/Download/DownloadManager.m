//
//  DownloadManager.m
//  downloader
//
//  Created by LAP14812 on 24/06/2022.
//

#import "DownloadManager.h"
#import "DownloadDelegate.h"
#import "DownloadItemPersistenceManager.h"
#import "DownloadFileManager.h"
#import "InternetTracking.h"

@interface DownloadManager ()
@property(weak, nonatomic) id<DownloadDelegate> downloadDelegate;
@property(strong, atomic) NSURLSession* session;
@property(strong, nonatomic) NSMutableArray<DownloadItem*>* allDownloadItems;
@property(strong, nonatomic) DownloadItemPersistenceManager* persistence;
@property(strong, nonatomic) dispatch_queue_t persistenceQueue;
@property(strong, nonatomic) InternetTracking* tracking;
@end

@implementation DownloadManager
- (BOOL) checkValidDownloadURL:(NSString *)url{
    NSURL *candidateURL = [NSURL URLWithString:url];
    if (candidateURL && candidateURL.scheme) {
        return true;
    }else{
        return false;
    }
}

+ (DownloadManager* )sharedInstance{
    static DownloadManager *sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DownloadManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype) init{
    self = [super init];
    if(self){
        self.allDownloadItems = [[NSMutableArray alloc] init];
        self.persistence = [DownloadItemPersistenceManager sharedInstance];
        self.persistenceQueue = dispatch_queue_create("persistenceQueue", DISPATCH_QUEUE_SERIAL);
        self.tracking = [[InternetTracking alloc] initWithTrackingInterval:5];
    }
    return self;
}

- (void) setDownloadViewDelegate:(id<DownloadDelegate>)downloadDelegate{
    self.downloadDelegate = downloadDelegate;
    NSString *identifier = [[[NSBundle mainBundle] bundleIdentifier]stringByAppendingString: @".background"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier: identifier];
    NSOperationQueue* downloadTaskQueue = [[NSOperationQueue alloc] init];
    self.session = [NSURLSession sessionWithConfiguration: config delegate:self.downloadDelegate delegateQueue:downloadTaskQueue];
}

- (void) setInternetTrackingDelegate: (id<InternetTrackingDelegate>) internetTrackingDelegate{
    _tracking.delegate = internetTrackingDelegate;
}

- (void) downloadWithURL:(NSString *)downloadURL{
    NSURL *url = [NSURL URLWithString:downloadURL];
    if(url){
        DownloadItem* newDownloadItem = [[DownloadItem alloc] initWithStringURL:downloadURL];
        NSURLSessionDownloadTask *downloadTask = [_session downloadTaskWithURL:url];
        newDownloadItem.downloadTask = downloadTask;
        [self.allDownloadItems addObject:newDownloadItem];
        [downloadTask resume];
        [self startTrackingInternetConnection];
        [self saveAllDownloadItemsToPersistence];
    }
}

-(DownloadItem*) getItemByDownloadTask:(NSURLSessionDownloadTask *)downloadTask{
    for(DownloadItem* item in self.allDownloadItems){
        if(downloadTask == item.downloadTask){
            return item;
        }
    }
    return nil;
}

- (void) pauseDownload:(DownloadItem *)downloadItem withCompleteHandler:(void (^)(void))completeHandler{
    [downloadItem.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        if(resumeData != nil){
            downloadItem.dataForResumeDownload = resumeData;
            downloadItem.state = @"Pause";
            
        }else{
            downloadItem.state = @"Error";
            downloadItem.progress = 0.0;
        }
        [self saveAllDownloadItemsToPersistence];
        [self stopTrackingInternetConnection];
        completeHandler();
    }];
}

- (void) resumeDownload:(DownloadItem *)downloadItem{
    if(downloadItem.dataForResumeDownload != nil){
        downloadItem.state = @"Downloading";
        downloadItem.downloadTask = [_session downloadTaskWithResumeData: downloadItem.dataForResumeDownload];
        [downloadItem.downloadTask resume];
        [self startTrackingInternetConnection];
    }else{
        downloadItem.state = @"Error";
        downloadItem.progress = 0.0;
    }
    [self saveAllDownloadItemsToPersistence];
}

- (void) cancelDownload:(DownloadItem *)downloadItem{
    [downloadItem.downloadTask suspend];
    [downloadItem didFinishDownloadWithState:@"Canceled"];
    [self saveAllDownloadItemsToPersistence];
}

- (void) pauseAllCurrentlyDownloadingItem{
    for(DownloadItem* downloadItem in self.allDownloadItems){
        if([downloadItem.state isEqual: @"Downloading"]){
            [self pauseDownload:downloadItem withCompleteHandler:^{
                NSLog(@"%@", @"Pause complete");
            }];
        }
    }
}

- (BOOL) pauseAllDownloadingProcessComplete{
    for(DownloadItem* downloadItem in self.allDownloadItems){
        if([downloadItem.state isEqual: @"Downloading"]){
            return false;
        }
    }
    [self saveAllDownloadItemsToPersistence];
    return true;
}

- (BOOL) isExistDownloadingProcess{
    for(DownloadItem* downloadItem in self.allDownloadItems){
        if([downloadItem.state isEqual: @"Downloading"]){
            return true;
        }
    }
    return false;
}


- (void) removeDownloadItem:(DownloadItem *)downloadItem{
    if(downloadItem.downloadTask != nil){
        [downloadItem.downloadTask suspend];
        downloadItem.downloadTask = nil;
    }
    [self.allDownloadItems removeObject:downloadItem];
    [self saveAllDownloadItemsToPersistence];
}

- (NSArray<DownloadItem *> *)getAllDownloadItems{
    return self.allDownloadItems;
}

- (void) saveAllDownloadItemsToPersistence{
    __weak DownloadManager *weakSelf = self;
    dispatch_async(self.persistenceQueue, ^{
        [weakSelf.persistence saveAllDownloadItems:weakSelf.allDownloadItems];
    });
}

- (void) fetchAllDownloadItemsWithAfterCompleteHandler:(void (^)(void))completionHandler{
    __weak DownloadManager *weakSelf = self;
    dispatch_sync(self.persistenceQueue, ^{
        weakSelf.allDownloadItems = [NSMutableArray arrayWithArray:[weakSelf.persistence getAllDownloadItems]];
        completionHandler();
    });
}

- (void) renameDownloadItem:(DownloadItem *)downloadItem toNewName:(NSString *)newName{
    downloadItem.name = newName;
}

- (void)restartDownloadItem:(DownloadItem *)downloadItem{
    downloadItem.state = @"Downloading";
    downloadItem.progress = 0.0;
    NSURLSessionDownloadTask *downloadTask = [_session downloadTaskWithURL:downloadItem.url];
    downloadItem.downloadTask = downloadTask;
    [downloadTask resume];
    [self startTrackingInternetConnection];
}

- (BOOL)isValidFileName:(NSString *)fileName{
    return ![fileName containsString:@"/"] &&
    ![[fileName substringFromIndex: fileName.length - 1] isEqualToString:@"."];
}

- (void)didFinishDownloadingTask:(NSURLSessionDownloadTask *)task toLocation:(NSURL *)location withSuccessHandler:(void (^)(void))onSuccess andFailureHandler:(void (^)(NSString * _Nonnull))onFail{
    DownloadItem* currentDownloadItem = [self getItemByDownloadTask:task];
    
    if(currentDownloadItem){
        NSURL* destinationURL = [self getSavableURLForDownloadItem:currentDownloadItem From:task];
        NSError* error;
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:destinationURL error:&error];
        if(error){
            onFail([NSString stringWithFormat: @"Can't save current download item due to:  %@", error.userInfo]);
            [currentDownloadItem didFinishDownloadWithState:@"Error"];
        }else{
            onSuccess();
            [currentDownloadItem didFinishDownloadWithState:@"Completed"];
        }
    }else{
        onFail(@"Can't save current download item");
        [currentDownloadItem didFinishDownloadWithState:@"Error"];
    }
    [self stopTrackingInternetConnection];
    [self saveAllDownloadItemsToPersistence];
}

- (NSURL*) getSavableURLForDownloadItem: (DownloadItem*) downloadItem From:(NSURLSessionDownloadTask*) task{
    NSInteger i = 0;
    NSURL* destinationURL;
    do{
        NSString* suggestFileName = [task.response suggestedFilename];
        NSString* pathExtension;
        if(suggestFileName != nil){
            pathExtension = [suggestFileName pathExtension];
        }else{
            pathExtension = @".octet-stream";
        }
        NSString* subFix = (i > 0) ? [NSString stringWithFormat: @"(%li).", i] : @".";
        NSString* destinationName = [[downloadItem.name stringByAppendingString:subFix] stringByAppendingString:pathExtension];
        destinationURL = [[FolderItem rootFolder].url URLByAppendingPathComponent:destinationName];
        i++;
    }while([[NSFileManager defaultManager] fileExistsAtPath:destinationURL.path isDirectory:false]);

    return destinationURL;
}

- (void)callForHaveInternetConnection{
    [_tracking resetTracking];
}

- (void) startTrackingInternetConnection{
    if([self isExistDownloadingProcess]){
        [_tracking startTracking];
    }
}

- (void) stopTrackingInternetConnection{
    if(![self isExistDownloadingProcess]){
        [_tracking stopTracking];
    }
}


@end
