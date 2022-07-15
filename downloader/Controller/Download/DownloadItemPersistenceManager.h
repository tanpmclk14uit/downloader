//
//  DownloadItemPersistenceManager.h
//  downloader
//
//  Created by LAP14812 on 29/06/2022.
//

#import <Foundation/Foundation.h>
#import "DownloadItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface DownloadItemPersistenceManager : NSObject
+ (DownloadItemPersistenceManager*) sharedInstance;
- (void) saveAllDownloadItems: (NSArray<DownloadItem*>*) allDownloadItems;
- (NSArray<DownloadItem*>*) getAllDownloadItems;
- (instancetype) init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
