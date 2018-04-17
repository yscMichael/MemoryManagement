//
//  QueueCommunicationController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "QueueCommunicationController.h"

@interface QueueCommunicationController ()

@end

@implementation QueueCommunicationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self testOperationQueueCommunication];
}

//线程之间进行通信
- (void)testOperationQueueCommunication
{
    //1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];

    //2.添加操作
    [queue addOperationWithBlock:^{
        //异步进行耗时操作
        for (int i = 0; i < 2; i++)
        {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1--%d--%@", i,[NSThread currentThread]);
        }

        //回到主线程
        //这里稍后执行
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // 进行一些UI、刷新等操作
            for (int i = 0; i < 2; i++)
            {
                [NSThread sleepForTimeInterval:2];
                NSLog(@"2--%d--%@", i,[NSThread currentThread]);
            }
        }];

        NSLog(@"hello world");
    }];
}

//总结:
//1、线程之间通信无非是在某个线程中调用某个线程,执行某些操作.
//
//


@end


