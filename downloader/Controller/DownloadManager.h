//
//  DownloadManager.h
//  downloader
//
//  Created by LAP14812 on 24/06/2022.
//

#import <Foundation/Foundation.h>
#import "DownloadItem.h"
#import "DownloadDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface DownloadManager : NSObject
+ (DownloadManager*) sharedInstance;
- (BOOL) checkValidDownloadURL: (NSString*)url;
- (instancetype)init NS_UNAVAILABLE;
- (void) setDownloadViewDelegate:(id<DownloadDelegate> _Nullable)downloadDelegate;
- (DownloadItem*) getItemByDownloadTask: (NSURLSessionDownloadTask*) downloadTask;
- (void) downloadWithURL: (NSString*) downloadURL;
- (void) pauseDownload: (DownloadItem*) downloadItem withCompleteHandler:(void (^)(void)) completeHandler;
- (void) resumeDownload: (DownloadItem*) downloadItem;
- (void) cancelDownload: (DownloadItem*) downloadItem;
- (void) pauseAllCurrentlyDownloadingItem;
- (void) removeDownloadItemAtIndext: (NSInteger) index;
- (void) removeDownloadItem: (DownloadItem*) downloadItem;
- (BOOL) pauseAllDownloadingProcessComplete;
- (NSArray<DownloadItem*>*) getAllDownloadItems;
- (void) setDownloadItems: (NSArray<DownloadItem*>*) allDownloadItems;
@end

NS_ASSUME_NONNULL_END
