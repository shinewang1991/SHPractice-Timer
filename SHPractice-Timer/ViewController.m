//
//  ViewController.m
//  SHPractice-Timer
//
//  Created by Eric on 2019/8/28.
//  Copyright © 2019 123. All rights reserved.
//

#import "ViewController.h"
#import "NSTimer+WeakTimer.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)dealloc{
    NSLog(@"%@----dealloc",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startTimer];
}

- (void)startTimer{
    NSTimer *timer = [NSTimer scheduledWeakTimerWithTimeInterval:1 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)runTimer{
    NSLog(@"timer fired");
}

@end
