//
//  NSTimer+WeakTimer.h
//  SHPractice-Timer
//
//  Created by Shine on 2019/9/7.
//  Copyright © 2019 123. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (WeakTimer)
+ (NSTimer *)scheduledWeakTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;
@end

NS_ASSUME_NONNULL_END
