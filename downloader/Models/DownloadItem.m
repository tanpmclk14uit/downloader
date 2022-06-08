//
//  DowloadItem.m
//  downloader
//
//  Created by LAP14812 on 07/06/2022.
//

#import "DownloadItem.h"

@implementation DownloadItem
- (instancetype)initWithName:(NSString *)name AndDownloadLink:(NSString *)downloadLink{
    self = [super init];
    if(self){
        self.name = name;
        self.downloadLink = downloadLink;
        self.downloadedCount = 0;
        self.downloadedCount = 0;
    }
    return self;
}
@end
