//
//  MainController.h
//  downloader
//
//  Created by LAP14812 on 07/06/2022.
//

#import <Foundation/Foundation.h>
#import "DownloadItem.h"
#import "DownloadDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface Downloader : NSObject
@property NSArray<DownloadItem *>* downloadItems;

- (void) downloadItem:(DownloadItem *)item;
- (DownloadItem*) getItemByDownloadingTask: (NSURLSessionDownloadTask*) downloadingTask;
- (void) setDownloadViewDelegate:(id<DownloadDelegate> _Nullable)updateViewDelegate;
+ (Downloader *) sharedInstance;
@end
NS_ASSUME_NONNULL_END
