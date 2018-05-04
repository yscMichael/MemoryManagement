//
//  NSTimer+EOCBlocksSupport.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/4.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "NSTimer+EOCBlocksSupport.h"

@implementation NSTimer (EOCBlocksSupport)

//block作为参数，存放在栈里面
+ (NSTimer*)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)())block repeats:(BOOL)repeats
{
    //这里把self弱化
    //任务封装成块
    //需要使用者进行配合修改
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(eoc_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)eoc_blockInvoke:(NSTimer*)timer
{
    void (^block)() = timer.userInfo;
    if (block)
    {
        block();
    }
}

@end


