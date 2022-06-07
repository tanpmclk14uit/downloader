//
//  MainController.h
//  downloader
//
//  Created by LAP14812 on 07/06/2022.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainController : NSObject
@property(strong, nonatomic) NSString* message;
@property(assign, nonatomic) int clickCount;
- (void) print;
- (instancetype) initWithMessage: (NSString*) message;
@end

NS_ASSUME_NONNULL_END
