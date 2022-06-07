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
@property(assign, nonatomic) int downloadingCount;
@property(assign, nonatomic) int downloadedCount;
@property(strong, nonatomic) NSString* downloadLink;
- (instancetype) initWithNameAnd: (NSString*) name DownloadLink: (NSString*) downloadLink;
@end

NS_ASSUME_NONNULL_END
