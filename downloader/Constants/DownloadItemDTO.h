//
//  DownloadItemDTO.h
//  downloader
//
//  Created by LAP14812 on 29/06/2022.
//

#import <Foundation/Foundation.h>
#import "DownloadItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface DownloadItemDTO: NSObject <NSCoding>
@property(strong, atomic) NSString* name;
@property(strong, atomic) NSString* state;
@property(strong, atomic,nullable) NSData* resumeData;
@property(strong, atomic) NSString* url;
- (instancetype) initWithDownloadItem: (DownloadItem*) downloadItem;
- (DownloadItem*) convertToDownloadItem;
@end

NS_ASSUME_NONNULL_END
