//
//  OperationQueueCustomController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "OperationQueueCustomController.h"

@interface OperationQueueCustomController ()

@end

@implementation OperationQueueCustomController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //[self testOperationCustomizeQueueOne];
    //[self testOperationCustomizeQueueTwo];
    //[self testOperationCustomizeQueueThree];
    [self testOperationCustomizeQueueFour];
}

//创建自定义队列、创建Operation
//结果:这里开启了子线程、并发执行
- (void)testOperationCustomizeQueueOne
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    //使用NSInvocationOperation创建操作1
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperationTask) object:nil];
    // 使用NSBlockOperation创建操作2
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2---%@", [NSThread currentThread]);
    }];

    //3.使用addOperation:添加所有操作到队列中
    [queue addOperation:op1];//[op1 start]
    [queue addOperation:op2];//[op2 start]
}

//创建自定义队列、创建Operation + addExecutionBlock
//结果:这里开启了子线程、并发执行
- (void)testOperationCustomizeQueueTwo
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    //使用NSInvocationOperation创建操作1
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperationTask) object:nil];
    //使用NSBlockOperation创建操作2
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2---%@", [NSThread currentThread]);
    }];
    [op2 addExecutionBlock:^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"3---%@", [NSThread currentThread]);
    }];

    //3.使用 addOperation: 添加所有操作到队列中
    [queue addOperation:op1];//[op1 start]
    [queue addOperation:op2];//[op2 start]
}

//创建自定义队列、不创建Operation、使用blocks
//结果:这里开启了子线程、并发执行
- (void)testOperationCustomizeQueueThree
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    //使用addOperationWithBlock:添加操作到队列中
    [queue addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:5];
        NSLog(@"1---%@", [NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"2---%@", [NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"3---%@", [NSThread currentThread]);
    }];
}

//创建自定义队列、不创建Operation、使用blocks
//结果:这里开启了子线程、串行执行
- (void)testOperationCustomizeQueueFour
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    //设置最大并发数
    queue.maxConcurrentOperationCount = 1; //串行队列(也开辟子线程了)
    //queue.maxConcurrentOperationCount = 2; //并发队列
    //queue.maxConcurrentOperationCount = 8; //并发队列

    //使用addOperationWithBlock:添加操作到队列中
    [queue addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:5];
        NSLog(@"1---%@", [NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"2---%@", [NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"3---%@", [NSThread currentThread]);
    }];
}

//执行任务
- (void)invocationOperationTask
{
    [NSThread sleepForTimeInterval:2];
    NSLog(@"1---%@", [NSThread currentThread]);
}

//总结:
//1、添加到这种队列中的操作,默认就会自动放到子线程中执行,而且是并发执行
//2、主队列默认在主线程执行,而且是执行串行操作(前提是不改变优先级)
//3、自定义队列默认并发执行,除非设置最大并发数maxConcurrentOperationCount=1(串行操作)
//
//  注意:这里maxConcurrentOperationCount控制的不是并发线程的数量,而是一个队列中同时能并发执行的最大
//  操作数(任务).而且一个操作也并非只能在一个线程中运行


@end



