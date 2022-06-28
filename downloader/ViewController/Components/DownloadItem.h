//
//  DownloadItem.h
//  downloader
//
//  Created by LAP14812 on 24/06/2022.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownloadItem : NSObject
@property(strong, nonatomic) NSString *name;
@property(strong, atomic) NSURL *url;
@property(strong, atomic, nullable) NSURLSessionDownloadTask *downloadTask;
@property(strong, atomic) NSString *state;
@property(strong, atomic) NSString *saveLocation;
@property(strong, atomic) NSString *totalSizeFitWithUnit;
@property(strong, atomic, nullable) NSData *dataForResumeDownload;
- (instancetype)initWithStringURL: (NSString*)url;
@end

NS_ASSUME_NONNULL_END
