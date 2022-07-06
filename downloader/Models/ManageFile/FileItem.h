//
//  FileItem.h
//  downloader
//
//  Created by LAP14812 on 01/07/2022.
//

#import <Foundation/Foundation.h>
#import "FileTypeEnum.h"
NS_ASSUME_NONNULL_BEGIN


@interface FileItem : NSObject
@property(strong, atomic) NSString* name;
@property(strong, atomic) NSNumber* size;
@property(strong, atomic) NSDate* createdDate;
@property(strong, atomic) FileTypeEnum* type;
@property(strong, atomic) NSURL* url;
- (instancetype)initWithName: (NSString*) name andSize: (NSNumber*) size andCreateDate: (NSDate*) createdDate andType: (FileTypeEnum*) type andURL:(NSURL*) url;
- (NSInteger) countDaysFromCreatedToNow;
@end

NS_ASSUME_NONNULL_END
