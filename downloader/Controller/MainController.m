//
//  MainController.m
//  downloader
//
//  Created by LAP14812 on 07/06/2022.
//

#import "MainController.h"
#import "DownloadItem.h"

@implementation MainController

- (instancetype) init{
    self = [super init];
    if(self){
        self.downloadItems = [self fetchDownloadItems];
        
    }
    return self;
}

- (void) downloadItem:(DownloadItem *)item inPosition:(int)position afterComplete:(void (^)(void))afterCompleteHandler{
    NSURL *url = [NSURL URLWithString:item.downloadLink];
    if(url){
        item.downloadingCount +=1;
        afterCompleteHandler();
        NSURLSession* session = [NSURLSession sessionWithConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration delegate:self.updateViewDelegate delegateQueue:nil];
        NSString *taskId = [[NSUUID UUID] UUIDString];
        NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler: ^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(location){
                NSError* error = nil;
                NSURL* documentsURL = [[NSFileManager defaultManager] URLForDirectory: NSDocumentDirectory inDomain: NSUserDomainMask appropriateForURL: nil create: NO error: &error];
                int i = 0;
                do{
                    error = nil;
                    NSString* fileExtension = i > 0? [NSString stringWithFormat: @"(%i).pdf",i]: @".pdf";
                    NSString* fileName = [item.name stringByAppendingString: fileExtension];
                    NSURL* saveURL = [documentsURL URLByAppendingPathComponent: fileName];
                    [[NSFileManager defaultManager] moveItemAtURL:location toURL: saveURL error: &error];
                    if(error){
                        i++;
                    }else{
                        item.downloadedCount+=1;
                        item.downloadingCount-=1;
                        // must imple thread safe
                        [item addNewDownloadedCopy: fileName];
                        [item completeDownloadingTask:taskId];
                        afterCompleteHandler();
                        NSLog(@"%@", saveURL);
                        break;
                    }
                }while(true);
            }
        }];
        DownloadingTask *currentDownloadingTask = [[DownloadingTask alloc] initWithId:taskId andTask:downloadTask];
        [item addNewDownloadingTask:currentDownloadingTask];
        [downloadTask resume];
    }
}


// MARK: Fake data -
- (NSArray<DownloadItem *> *)fetchDownloadItems{
    DownloadItem* learniOSDev = [[DownloadItem alloc] initWithName:@"Learn iOS Dev" AndDownloadLink: @"https://jsoncompare.org/LearningContainer/SampleFiles/PDF/sample-pdf-download-10-mb.pdf"];
    DownloadItem* beginningiOS = [[DownloadItem alloc] initWithName:@"Beginning iOS" AndDownloadLink: @"https://decapoda.nhm.org/pdfs/25900/25900.pdf"];
    DownloadItem* theBigNerdRanch = [[DownloadItem alloc] initWithName:@"The Big Nerd Ranch" AndDownloadLink: @"https://jsoncompare.org/LearningContainer/SampleFiles/PDF/sample-pdf-with-images.pdf"];
    return @[learniOSDev, beginningiOS, theBigNerdRanch];
}
@end
