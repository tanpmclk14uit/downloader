//
//  DownloadManager.m
//  downloader
//
//  Created by LAP14812 on 24/06/2022.
//

#import "DownloadManager.h"
#import "DownloadDelegate.h"

@interface DownloadManager ()
@property(weak, nonatomic) id<DownloadDelegate> downloadDelegate;
@property(strong, atomic) NSURLSession* session;
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

- (void) downloadWithURL:(NSString *)downloadURL{
    NSURL *url = [NSURL URLWithString:downloadURL];
    if(url){
        
        DownloadItem* newDownloadItem = [[DownloadItem alloc] initWithStringURL:downloadURL];
        NSURLSessionDownloadTask *downloadTask = [_session downloadTaskWithURL:url];
        newDownloadItem.downloadTask = downloadTask;
        [self.allDownloadItems addObject:newDownloadItem];
        [downloadTask resume];
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
        }
        completeHandler();
    }];
}

- (void) resumeDownload:(DownloadItem *)downloadItem{
    if(downloadItem.dataForResumeDownload != nil){
        downloadItem.state = @"Downloading";
        downloadItem.downloadTask = [_session downloadTaskWithResumeData: downloadItem.dataForResumeDownload];
        [downloadItem.downloadTask resume];
    }else{
        downloadItem.state = @"Error";
    }
}

- (void) cancelDownload:(DownloadItem *)downloadItem{
    [downloadItem.downloadTask suspend];
    downloadItem.state = @"Cancel";
}
@end
