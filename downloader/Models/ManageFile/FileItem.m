//
//  FileItem.m
//  downloader
//
//  Created by LAP14812 on 01/07/2022.
//

#import "FileItem.h"

@implementation FileItem
- (instancetype)initWithName:(NSString *)name andSize:(NSNumber *)size andCreateDate:(NSDate *)createdDate andType:(FileTypeEnum*)type andURL:(NSURL*) url{
    self = [super init];
    if(self){
        self.name = name;
        self.size = size;
        self.createdDate = createdDate;
        self.type = type;
        self.url = url;
        self.isDir = false;
    }
    return self;
}

- (NSInteger) countDaysFromCreatedToNow{
    return -[self.createdDate timeIntervalSinceNow];
}

@end
