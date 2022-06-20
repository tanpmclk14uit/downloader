//
//  MainController.m
//  downloader
//
//  Created by LAP14812 on 07/06/2022.
//

#import "Downloader.h"
#import "DownloadItem.h"

@interface Downloader ()
@property(weak, nonatomic) id<DownloadDelegate> updateViewDelegate;
@property(strong, atomic) NSURLSession* session;
@end

@implementation Downloader

+ (Downloader *) sharedInstance{
    static Downloader *sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
            sharedInstance = [[Downloader alloc] init];
        });
    return sharedInstance;
}

- (instancetype) init{
    self = [super init];
    if(self){
        self.downloadItems = [self fetchDownloadItems];
    }
    return self;
}

- (void) setDownloadViewDelegate:(id<DownloadDelegate>)updateViewDelegate{
    self.updateViewDelegate = updateViewDelegate;
    NSString *identifier = [[[NSBundle mainBundle] bundleIdentifier]stringByAppendingString: @".background"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier: identifier];
    self.session = [NSURLSession sessionWithConfiguration: config delegate:self.updateViewDelegate delegateQueue:nil];
}
- (void) downloadItem:(DownloadItem *)item{
    NSURL *url = [NSURL URLWithString:item.downloadLink];
    if(url){
        item.downloadingCount +=1;
        NSURLSessionDownloadTask *downloadTask = [_session downloadTaskWithURL:url];
        [item addNewDownloadingTask:downloadTask];
        [downloadTask resume];
    }
}

- (DownloadItem*) getItemByDownloadingTask:(NSURLSessionDownloadTask *)downloadingTask{
    for (DownloadItem* item in self.downloadItems){
        for(NSURLSessionDownloadTask* task in [item getAllDownloadingTask]){
            if(task == downloadingTask){
                return item;
            }
        }
    }
    return nil;
}


// MARK: Fake data -
- (NSArray<DownloadItem *> *)fetchDownloadItems{
    DownloadItem* learniOSDev = [[DownloadItem alloc] initWithName:@"Learn iOS Dev" AndDownloadLink: @"https://jsoncompare.org/LearningContainer/SampleFiles/PDF/sample-pdf-download-10-mb.pdf"];
    DownloadItem* beginningiOS = [[DownloadItem alloc] initWithName:@"Beginning iOS" AndDownloadLink: @"https://decapoda.nhm.org/pdfs/25900/25900.pdf"];
    DownloadItem* theBigNerdRanch = [[DownloadItem alloc] initWithName:@"The Big Nerd Ranch" AndDownloadLink: @"https://jsoncompare.org/LearningContainer/SampleFiles/PDF/sample-pdf-with-images.pdf"];
    return @[learniOSDev, beginningiOS, theBigNerdRanch];
}
@end
