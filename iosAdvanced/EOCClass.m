//
//  EOCClass.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/4.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "EOCClass.h"
#import "NSTimer+EOCBlocksSupport.h"

//static

@interface EOCClass ()

@property (nonatomic ,strong) NSTimer *poliTimer;

@end

@implementation EOCClass

- (id) init
{
    return [super init];
}

- (void)startPolling
{
//   _poliTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(p_doPoll) userInfo:nil repeats:YES];
//    [_poliTimer fire];

    //这段代码先定义了一个弱引用指向self,然后用块捕获这个引用,这样self就不会被计时器所保留,当块开始执行时,立刻生成strong引用,保证实例在执行器继续存活
    //这样我持有定时器,但是你并没有持有我,我传过去的是弱引用
    __weak EOCClass *weakSelf = self;
    _poliTimer = [NSTimer eoc_scheduledTimerWithTimeInterval:5.0 block:^{
        EOCClass *strongSelf = weakSelf;
        [strongSelf p_doPoll];
    } repeats:YES];
    [_poliTimer fire];
}

- (void)p_doPoll
{
    NSLog(@"eoc");
}

- (void)stopPolling
{
    [_poliTimer invalidate];
    _poliTimer = nil;
}

- (void)dealloc
{
    NSLog(@"对象销毁了");
    [_poliTimer invalidate];
}

@end

