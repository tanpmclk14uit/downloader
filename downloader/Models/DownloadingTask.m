//
//  DownloadingTask.m
//  downloader
//
//  Created by LAP14812 on 16/06/2022.
//

#import "DownloadingTask.h"

@implementation DownloadingTask
- (instancetype) initWithId:(NSString *)taskId andTask:(NSURLSessionDownloadTask *)task{
    self = [super init];
    if(self){
        self.taskId = taskId;
        self.task = task;
    }
    return self;
}
@end
