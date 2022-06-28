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
        self.saveLocation = @"";
        self.totalSizeFitWithUnit = @"";
        self.downloadTask = nil;
        self.dataForResumeDownload = nil;
    }
    return self;
}
@end
