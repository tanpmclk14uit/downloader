//
//  FileTypeConstants.h
//  downloader
//
//  Created by LAP14812 on 06/07/2022.
//

#import <Foundation/Foundation.h>
#import "FileTypeEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface FileTypeConstants : NSObject
+ (FileTypeEnum*) pdf;
+ (FileTypeEnum*) audio;
+ (FileTypeEnum*) video;
+ (FileTypeEnum*) zip;
+ (FileTypeEnum*) image;
+ (FileTypeEnum*) text;
+ (FileTypeEnum*) unknown;

@end

NS_ASSUME_NONNULL_END
