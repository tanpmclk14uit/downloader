//
//  DownloadItemPersistenceManager.m
//  downloader
//
//  Created by LAP14812 on 29/06/2022.
//

#import "DownloadItemPersistenceManager.h"
#import "DownloadItemDTO.h"

@implementation DownloadItemPersistenceManager

#define kAllDownloadItemKey               @"AllDownloadItems"

-(void)saveAllDownloadItems:(NSArray<DownloadItem *> *)allDownloadItems{
    NSMutableArray<DownloadItemDTO*>* allDownloadItemDTOs = [[NSMutableArray alloc] init];
    for(DownloadItem* downloadItem in allDownloadItems){
        DownloadItemDTO* newDownloadItemDTO = [[DownloadItemDTO alloc] initWithDownloadItem:downloadItem];
        [allDownloadItemDTOs addObject:newDownloadItemDTO];
    }
    [self saveDownloadItemDTOsToUserDefault:allDownloadItemDTOs];
}

- (void) saveDownloadItemDTOsToUserDefault: (NSArray<DownloadItemDTO *> *)allDownloadItemDTOs{
    NSData* allDownloadItemDatas = [NSKeyedArchiver archivedDataWithRootObject: allDownloadItemDTOs];
    if(allDownloadItemDatas != nil){
        [[NSUserDefaults standardUserDefaults] setObject:allDownloadItemDatas forKey: kAllDownloadItemKey];
    }
}

+ (DownloadItemPersistenceManager*) sharedInstance{
    static DownloadItemPersistenceManager *sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DownloadItemPersistenceManager alloc] init];
    });
    return sharedInstance;
}

- (NSArray<DownloadItem *> *)getAllDownloadItems{
    NSMutableArray<DownloadItem*>* allDownloadItems = [[NSMutableArray alloc]init];
    NSData* saveData = [[NSUserDefaults standardUserDefaults] objectForKey:kAllDownloadItemKey];
    NSArray* allDownloadItemDTOs = [NSKeyedUnarchiver unarchiveTopLevelObjectWithData:saveData error:nil];
    for(DownloadItemDTO* downloadItemDTO in allDownloadItemDTOs) {
        [allDownloadItems addObject: [downloadItemDTO convertToDownloadItem]];
    }
    return [NSArray arrayWithArray:allDownloadItems];
}
@end
