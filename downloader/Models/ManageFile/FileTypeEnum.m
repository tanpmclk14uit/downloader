//
//  FileTypeEnum.m
//  downloader
//
//  Created by LAP14812 on 06/07/2022.
//

#import "FileTypeEnum.h"

@implementation FileTypeEnum
- (instancetype) initWithName:(NSString *)name andExtension:(NSArray<NSString *>*)extensionList{
    self = [super init];
    if(self){
        self.name = name;
        self.extensionList = extensionList;
    }
    return  self;
}
@end
