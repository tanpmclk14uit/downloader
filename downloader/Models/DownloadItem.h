//
//  DowloadItem.h
//  downloader
//
//  Created by LAP14812 on 07/06/2022.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface DownloadItem : NSObject
@property(strong, nonatomic) NSString* name;
@property(assign, atomic) int downloadingCount;
@property(assign, atomic) int downloadedCount;
@property(assign, atomic) bool shouldShowCopiesItem;
@property(strong, atomic) NSMutableArray<NSURLSessionDownloadTask *>* downloadingTasks;
@property(strong, nonatomic) NSString* downloadLink;
@property(strong, nonatomic) dispatch_queue_t dispatchQueueForThreadSafe;
@property(strong, atomic) NSMutableArray<NSString*>* downloadedCopies;

- (instancetype) initWithName: (NSString*) name AndDownloadLink: (NSString*) downloadLink;
- (Boolean) removeDownloadedCopySuccess;
- (void) addNewDownloadedCopy: (NSString*) copyName;
- (void) deleteDownloadedCopy: (NSString*) copyName;
- (void) addNewDownloadingTask: (NSURLSessionDownloadTask*) downloadingTask;
- (void) removeDowloadingTask: (NSURLSessionDownloadTask*) downloadingTask;
- (NSArray<NSURLSessionDownloadTask*>*) getAllDownloadingTask;
- (void) cancelRandomDownloadingTask;
- (NSString*) getAllDownloadedCopiesToString;
@end

NS_ASSUME_NONNULL_END
