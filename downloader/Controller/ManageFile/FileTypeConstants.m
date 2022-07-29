//
//  FileTypeConstants.m
//  downloader
//
//  Created by LAP14812 on 06/07/2022.
//

#import "FileTypeConstants.h"

@implementation FileTypeConstants
+ (FileTypeEnum *)audio{
    return [[FileTypeEnum alloc] initWithName:@"audio" andExtension: @[@"mp3", @"m4a",@"flac",@"wav",@"wma",@"aac",@"mpeg", @"mpeg3"] andIconName:@"music"];
}
+ (FileTypeEnum *)video{
    return [[FileTypeEnum alloc] initWithName:@"video" andExtension:@[@"mp4",@"mov",@"wmv",@"flv",@"avi",@"avchd",@"webm",@"mkv",@"x-m4v",@"mpg"] andIconName:@"video"];
}
+ (FileTypeEnum *)pdf{
    return [[FileTypeEnum alloc] initWithName:@"pdf" andExtension:@[@"pdf"] andIconName:@"pdf"];
}
+ (FileTypeEnum *)text{
    return [[FileTypeEnum alloc] initWithName:@"text" andExtension:@[@"html", @"txt", @"doc", @"docx", @"odt", @"rtf", @"wpd", @"tex"] andIconName:@"text"];
}
+ (FileTypeEnum *)image{
    return [[FileTypeEnum alloc] initWithName:@"image" andExtension:@[@"jpeg",@"jpg",@"png",@"gif",@"tiff",@"psd",@"eps",@"ai",@"indd",@"raw",@"webp"] andIconName:@"image"];
}
+ (FileTypeEnum *)zip{
    return [[FileTypeEnum alloc] initWithName:@"zip" andExtension:@[@"zip", @"7z", @"rar", @"zipx"] andIconName:@"zip"];
}
+ (FileTypeEnum*)unknown{
    return [[FileTypeEnum alloc] initWithName:@"unknown" andExtension:nil andIconName:@"unknown"];
}
+ (FileTypeEnum*) mp3{
    return [[FileTypeEnum alloc] initWithName:@"mp3" andExtension:@[@"mp3"] andIconName:@"music"];
}

+ (FileTypeEnum *)html{
    return [[FileTypeEnum alloc] initWithName:@"html" andExtension:@[@"html"] andIconName:@"text"];
}

+ (FileTypeEnum *)doc{
    return [[FileTypeEnum alloc] initWithName:@"doc" andExtension:@[@"doc", @"docx"] andIconName:@"text"];
}

+ (NSArray<FileTypeEnum *> *)supportedFileTypes{
    return @[FileTypeConstants.pdf,
             FileTypeConstants.audio,
             FileTypeConstants.video,
             FileTypeConstants.text,
             FileTypeConstants.image,
             FileTypeConstants.zip,
             FileTypeConstants.unknown,
             FileTypeConstants.mp3,
             FileTypeConstants.html,
             FileTypeConstants.doc];
}
@end
