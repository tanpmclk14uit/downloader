//
//  DownloadingTask.h
//  downloader
//
//  Created by LAP14812 on 16/06/2022.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownloadingTask : NSObject
@property(strong, atomic) NSString* taskId;
@property(strong, atomic) NSURLSessionDownloadTask* task;
- (instancetype) initWithId: (NSString*) taskId andTask: (NSURLSessionDownloadTask*) task;
@end

NS_ASSUME_NONNULL_END
