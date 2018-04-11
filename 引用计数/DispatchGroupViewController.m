//
//  DispatchGroupViewController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/11.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "DispatchGroupViewController.h"

@interface DispatchGroupViewController ()

@end

@implementation DispatchGroupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self testGroupOne];
}

#pragma mark - test1
- (void)testGroupOne
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();

    //这三个请求不相互干扰,各自拿回各自数据
    //如果相互干扰,怎么办呢????????????
    //有人会说用异步串行队列,但是队列只会一直往下执行,中间的数据处理怎么半
    // 1、刮起队列
    // 2、NSOPeration
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:5.0];
        NSLog(@"任务0");
        NSLog(@"%@",[NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:3.0];
        NSLog(@"任务1");
        NSLog(@"%@",[NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"任务2");
        NSLog(@"%@",[NSThread currentThread]);
    });

    //1、
    dispatch_group_notify(group, queue, ^{
        NSLog(@"请求完成--1");
    });

    //2、
    long result = dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    if (result == 0)
    {
        NSLog(@"全部完成--2");
    }
    else
    {
        NSLog(@"没有全部完成");
    }
}

//应用场景:
//1、当前页面数据需要多个接口请求回来的数据,进行整合
//   前提:各个接口相互之间平等
//   a、接口请求数据任务放在子线程
//   b、采用异步请求方式
//2、监测有两种方法
//   a、dispatch_group_notify 推荐使用
//   b、dispatch_group_wait不推荐


@end

