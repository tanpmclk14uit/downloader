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
        self.isTraking = false;
        
        self.timer = [CADisplayLink displayLinkWithTarget:self
                                             selector:@selector(tracking:)];
        
        [self.timer addToRunLoop:[NSRunLoop currentRunLoop]
                     forMode:NSRunLoopCommonModes];
        [self.timer setPaused:true];
    }
    return self;
}

- (void)startTracking {
    if(!self.isTraking){
        self.isTraking = true;
        self.startTime = CACurrentMediaTime();
        [self.timer setPaused:false];
    }
}

- (void)tracking:(CADisplayLink *)sender {
    if(self.timer.timestamp - self.startTime > self.trackingInterval){
        if(![self hasInternetConnection]){
            [self.delegate noInternetConnectionHandler];
        }
        [self.timer setPaused:true];
        self.isTraking = false;
    }
    NSLog(@"%@", @"tracking");
}

- (void)resetTracking{
    self.startTime = CACurrentMediaTime();
    if(!self.isTraking){
        [self.timer setPaused:false];
    }
}

- (void) stopTracking{
    if(self.isTraking){
        self.isTraking = false;
        [self.timer setPaused:true];
    }
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
