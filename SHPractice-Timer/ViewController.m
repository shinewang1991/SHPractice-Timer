//
//  ViewController.m
//  SHPractice-Timer
//
//  Created by Eric on 2019/8/28.
//  Copyright © 2019 123. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    BOOL stop;
}
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation ViewController

- (void)dealloc{
    NSLog(@"%@----dealloc",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startTimer];   //NStimer
    //[self startTimer1];  //CADisplayLink
//    [self startTimer2];  //GCDTimer
}


#pragma mark ---------------------------NSTimer------------------------------
- (void)startTimer{
    /* timerWithTimeInterval
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timer fired");
    }];    //timerWithTimerIntervavl方式需要加入到runloop中循环才会生效，否则执行一次就结束了。
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
     */
    
    
    /* scheduledTimerWithTimeInterval
    NSLog(@"startTimer");
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timer fired");
    }];    //scheduledTimerWithTimeInterval底层实现会自动帮加入到runloop中.
    [timer fire];   //加fire是为了让它马上执行一次，否则会等间隔后执行第一次
     */
    
    /*
     1.NSTimer被添加到特定mode的runloop中；
     2.该mode型的runloop正在运行；
     3.到达激发时间。因为一个run loop需要管理大量的输入源，为了提NSTimer的效率，时间间隔限制为50-100毫秒比较合理。如果一个NSTimer的激发时间
     出现在一个耗时的方法中，或者当前run loop的mode没有监测该NSTimer，那么定时器就不会被激发，直到下一次run loop检测到该NSTimer时才会激发。
     因此,NSTimer的实际激发时间很有可能会比规划时间延后一段时间。
     
     */
    
    //子线程中创建NSTimer,回到主线程去刷新UI
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(newThread) object:nil];
    [thread start];
}

- (void)newThread{
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timer fired -----%@",[NSThread currentThread]);
        //回到主线程去刷新UI
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    while (!stop) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    stop = YES;
}

#pragma mark ----------------------------CADisplayLink------------------------------

- (void)startTimer1{
    CADisplayLink *timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerFired)];
    [timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    //默认间隔为60fps, 一秒60次，一次 1/60 s.
    
    timer.preferredFramesPerSecond = 1;   //fps设为1，即一秒执行一次
    
}

- (void)timerFired{
    NSLog(@"timer fired");
}


#pragma mark ----------------------------GCDTimer------------------------------
- (void)startTimer2{
    
    //一次性定时
    /*
    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(timer, dispatch_get_main_queue(), ^{
        NSLog(@"timer fired");
    });
    */
    
    //dispatch_source_t 纳秒级的精准，是最精准的timer.
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);   //最后一个参数是允许的误差，0表示绝对精准.
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"timer fired");
    });
    dispatch_resume(timer);
    self.timer = timer;
    
}

@end
