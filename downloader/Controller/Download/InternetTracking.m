//
//  InternetTracking.m
//  downloader
//
//  Created by LAP14812 on 17/07/2022.
//

#import "InternetTracking.h"
#import <QuartzCore/QuartzCore.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface InternetTracking ()
@property(assign, atomic) NSTimeInterval trackingInterval;
@property(strong, atomic) CADisplayLink* timer;
@property(assign, atomic) NSTimeInterval startTime;
@property(assign, atomic) BOOL isTraking;
@end

@implementation InternetTracking
- (instancetype)initWithTrackingInterval:(NSTimeInterval)interval{
    self = [super init];
    if(self){
        self.trackingInterval = interval;
        _isTraking = false;
        
    }
    return self;
}

- (void)startTracking {
    _isTraking = true;
    _startTime = CACurrentMediaTime();
    _timer = [CADisplayLink displayLinkWithTarget:self
                                         selector:@selector(tracking:)];
    
    [_timer addToRunLoop:[NSRunLoop currentRunLoop]
                 forMode:NSRunLoopCommonModes];
}

- (void)tracking:(CADisplayLink *)sender {
    if(_timer.timestamp - _startTime > _trackingInterval){
        if(![self hasInternetConnection]){
            [_delegate noInternetConnectionHandler];
        }
        [_timer setPaused:true];
        _isTraking = false;
    }
}

- (void)resetTracking{
    _startTime = CACurrentMediaTime();
    if(!_isTraking){
        [_timer setPaused:false];
    }
}

- (void) stopTracking{
    _isTraking = false;
    [_timer invalidate];
}

- (BOOL) hasInternetConnection{
    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.google.com/m"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data){
        return true;
    }
    else{
        return false;
    }
}
@end
