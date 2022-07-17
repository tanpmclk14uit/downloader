//
//  InternetTracking.h
//  downloader
//
//  Created by LAP14812 on 17/07/2022.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol InternetTrackingDelegate
- (void) noInternetConnectionHandler;
@end

@interface InternetTracking : NSObject
@property(weak, nonatomic) id<InternetTrackingDelegate> delegate;
- (instancetype)initWithTrackingInterval: (NSTimeInterval) interval;
- (void)startTracking;
- (void)stopTracking;
- (void)resetTracking;
@end

NS_ASSUME_NONNULL_END
