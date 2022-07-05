//
//  DownloadItemDTO.m
//  downloader
//
//  Created by LAP14812 on 29/06/2022.
//

#import "DownloadItemDTO.h"

@implementation DownloadItemDTO

#define kNameKey               @"Title"
#define kStateKey              @"State"
#define kResumeDataKey         @"ResumeData"
#define kURLKey                @"URL"

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_name forKey:kNameKey];
    [coder encodeObject:_state forKey:kStateKey];
    [coder encodeObject:_resumeData forKey:kResumeDataKey];
    [coder encodeObject:_url forKey:kURLKey];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    NSString* name = [coder decodeObjectForKey:kNameKey];
    NSString* state = [coder decodeObjectForKey:kStateKey];
    NSString* url = [coder decodeObjectForKey:kURLKey];
    NSData* resumeData = [coder decodeObjectForKey:kResumeDataKey];
    return [self initWithName:name andState:state andURL:url andResumeData:resumeData];
}

- (instancetype) initWithName: (NSString*) name andState: (NSString*) state andURL: (NSString*) url andResumeData: (nullable NSData*) resumeData{
    self = [super init];
    if(self){
        self.name = name;
        self.state = state;
        self.url = url;
        self.resumeData = resumeData;
    }
    return self;
}

- (instancetype) initWithDownloadItem:(DownloadItem *)downloadItem{
    return [self initWithName:downloadItem.name andState:downloadItem.state  andURL: downloadItem.url.absoluteString andResumeData:downloadItem.dataForResumeDownload];
}

- (DownloadItem *)convertToDownloadItem{
    return [[DownloadItem alloc] initWithName:self.name andState:self.state andURL:self.url andResumeData:self.resumeData];
}
@end
