//
//  MainController.m
//  downloader
//
//  Created by LAP14812 on 07/06/2022.
//

#import "MainController.h"

@implementation MainController
- (void) print {
    self.clickCount = self.clickCount + 1;
    NSLog(@"%@ %i", self.message,self.clickCount);
}
- (instancetype) initWithMessage:(NSString *)message{
    self = [super init];
    if(self){
        self.message = message;
        self.clickCount = 0;
    }
    return self;
}
@end
