//
//  DownloadItem.m
//  downloader
//
//  Created by LAP14812 on 24/06/2022.
//

#import "DownloadItem.h"

@implementation DownloadItem
- (instancetype)initWithStringURL:(NSString *)url{
    self = [super init];
    if(self){
        self.name = [[url lastPathComponent] stringByDeletingPathExtension];
        self.url = [NSURL URLWithString: url];
        self.state = @"Downloading";
        self.totalSizeFitWithUnit = @"";
        self.downloadTask = nil;
        self.dataForResumeDownload = nil;
        self.durationString = nil;
        self.progress = 0.0;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name andState:(NSString *)state andURL:(NSString *)url andResumeData:(NSData *)resumeData{
    self = [super init];
    if(self){
        self.name = name;
        self.url = [NSURL URLWithString: url];
        self.state = state;
        self.totalSizeFitWithUnit = @"";
        self.downloadTask = nil;
        self.dataForResumeDownload = resumeData;
        self.durationString = nil;
        self.progress = 0.0;
    }
    return self;
}

- (void)didFinishDownloadWithState:(NSString *)state{
    self.state = state;
    self.totalSizeFitWithUnit = @"";
    self.downloadTask = nil;
    self.durationString = nil;
    self.progress = 0.0;
}
@end
