//
//  DownloadItem.h
//  downloader
//
//  Created by LAP14812 on 24/06/2022.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownloadItem : NSObject
@property(strong, nonatomic) NSString *name;
@property(strong, atomic) NSURL *url;
@property(strong, atomic, nullable) NSURLSessionDownloadTask *downloadTask;
@property(strong, atomic) NSString *state;
@property(strong, atomic) NSString *totalSizeFitWithUnit;
@property(strong, atomic, nullable) NSData *dataForResumeDownload;
@property(strong, atomic, nullable) NSString *durationString;
@property(assign, atomic) double progress;
- (instancetype)initWithStringURL: (NSString*)url;
- (instancetype) initWithName: (NSString*) name andState: (NSString*) state andURL: (NSString*) url andResumeData: (nullable NSData*) resumeData;
- (void) didFinishDownloadWithState: (NSString*) state;
@end

NS_ASSUME_NONNULL_END
