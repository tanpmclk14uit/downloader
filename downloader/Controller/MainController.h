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

@interface MainController : NSObject
@property NSArray<DownloadItem *>* downloadItems;
@property(weak, nonatomic) id<DownloadDelegate> updateViewDelegate;
@property(strong, atomic) NSOperationQueue* sessionDelegateQueue;
@property(strong, atomic) NSURLSession* session;
- (NSArray<DownloadItem*>*) fetchDownloadItems;
- (instancetype)init;
- (void) downloadItem:(DownloadItem *)item inPosition:(int)position afterComplete: (void (^)(void)) afterCompleteHandler;
@end
NS_ASSUME_NONNULL_END
