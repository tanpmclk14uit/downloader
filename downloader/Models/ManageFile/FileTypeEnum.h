//
//  FileTypeEnum.h
//  downloader
//
//  Created by LAP14812 on 06/07/2022.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileTypeEnum : NSObject
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic, nullable) NSArray<NSString*>* extensionList;
@property(strong, nonatomic) NSString *iconName;
- (instancetype)initWithName: (NSString*) name andExtension:  (NSArray<NSString*>* _Nullable ) extensionList andIconName: (NSString*) iconName;
@end

NS_ASSUME_NONNULL_END
