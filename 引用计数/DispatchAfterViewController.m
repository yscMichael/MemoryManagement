//
//  DispatchAfterViewController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/14.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "DispatchAfterViewController.h"

@interface DispatchAfterViewController ()

@end

@implementation DispatchAfterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self testDispatchAfter];
    //[self testSleep];
}

//测试dispatch_after
//
- (void)testDispatchAfter
{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 3ull * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{

        NSLog(@"waited at least three seconds");
    });

    //上面不影响下面执行
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"hello world");
    });
}

- (void)testSleep
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:3.0];
        NSLog(@"%@",[NSThread currentThread]);
        NSLog(@"延时3s");
    });

    //上面先执行
    dispatch_async(queue, ^{
        NSLog(@"hello world");
    });
}

//总结:
//1、dispatch_after并不是在指定time后,执行处理(任务)
//   而是在指定time追加处理(任务)到Queue中
//2、延时方法
//   a、[NSThread sleepForTimeInterval:1.0];会阻塞主线程
//   b、dispatch_after//不会阻塞主线程


@end

