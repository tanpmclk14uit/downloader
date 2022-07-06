//
//  FileTypeConstants.m
//  downloader
//
//  Created by LAP14812 on 06/07/2022.
//

#import "FileTypeConstants.h"

@implementation FileTypeConstants
+ (FileTypeEnum *)audio{
    return [[FileTypeEnum alloc] initWithName:@"audio" andExtension: @[@"mp3", @"m4a",@"flac",@"wav",@"wma",@"aac"]];
}
+ (FileTypeEnum *)video{
    return [[FileTypeEnum alloc] initWithName:@"video" andExtension:@[@"mp4",@"mov",@"wmv",@"flv",@"avi",@"avchd",@"webm",@"mkv"]];
}
+ (FileTypeEnum *)pdf{
    return [[FileTypeEnum alloc] initWithName:@"pdf" andExtension:@[@"pdf"]];
}
+ (FileTypeEnum *)text{
    return [[FileTypeEnum alloc] initWithName:@"text" andExtension:@[@"html", @"txt", @"doc", @"docx", @"odt", @"rtf", @"wpd", @"tex"]];
}
+ (FileTypeEnum *)image{
    return [[FileTypeEnum alloc] initWithName:@"image" andExtension:@[@"jpeg",@"jpg",@"png",@"gif",@"tiff",@"psd",@"eps",@"ai",@"indd",@"raw"]];
}
+ (FileTypeEnum *)zip{
    return [[FileTypeEnum alloc] initWithName:@"zip" andExtension:@[@"zip", @"7z"]];
}
+ (FileTypeEnum*)unknown{
    return [[FileTypeEnum alloc] initWithName:@"unknown" andExtension:nil];
}
@end
