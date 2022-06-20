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
@property(assign, atomic) NSInteger downloadingCount;
@property(assign, atomic) NSInteger downloadedCount;
@property(assign, atomic) BOOL shouldShowCopiesItem;
@property(strong, nonatomic) NSString* downloadLink;

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
