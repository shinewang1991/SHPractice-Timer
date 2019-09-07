//
//  NSTimer+WeakTimer.m
//  SHPractice-Timer
//
//  Created by Shine on 2019/9/7.
//  Copyright © 2019 123. All rights reserved.
//

#import "NSTimer+WeakTimer.h"

@interface TimerWeakObject : NSObject
@property (nonatomic, weak) id timerTarget;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) SEL selector;

- (void)fire:(NSTimer *)timer;
@end

@implementation TimerWeakObject

- (void)dealloc{
    NSLog(@"%@----dealloc",NSStringFromClass([self class]));
}

- (void)fire:(NSTimer *)timer{
    if(self.timerTarget){
        if([self.timerTarget respondsToSelector:self.selector]){
            [self.timerTarget performSelector:self.selector withObject:timer.userInfo];
        }
    }
    else{
        [self.timer invalidate];
    }
}

@end

@implementation NSTimer (WeakTimer)
+ (NSTimer *)scheduledWeakTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo{
    TimerWeakObject *object = [[TimerWeakObject alloc] init];
    object.timerTarget = aTarget;
    object.selector = aSelector;
    object.timer = [NSTimer scheduledTimerWithTimeInterval:ti target:object selector:@selector(fire:) userInfo:userInfo repeats:YES];
    return object.timer;
}
@end
