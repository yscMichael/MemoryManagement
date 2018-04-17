//
//  OperationQueueMainController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "OperationQueueMainController.h"

@interface OperationQueueMainController ()

@end

@implementation OperationQueueMainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //[self testOperationMainQueueOne];
    //[self testOperationMainQueueTwo];
    [self testOperationMainQueueThree];
}

//创建主队列、创建Operation
//结果:在主线程执行
- (void)testOperationMainQueueOne
{
    //主队列
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    //使用NSInvocationOperation创建操作1
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperationTask) object:nil];
    //使用NSBlockOperation创建操作2
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2---%@", [NSThread currentThread]);
    }];

    //3.使用addOperation:添加所有操作到队列中
    [queue addOperation:op1];//[op1 start]
    [queue addOperation:op2];//[op2 start]
}

//创建主队列、创建Operation + addExecutionBlock
//结果:有的在主线程,有的在子线程
- (void)testOperationMainQueueTwo
{
    //主队列
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
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

    //3.使用addOperation:添加所有操作到队列中
    [queue addOperation:op1];//[op1 start]
    [queue addOperation:op2];//[op2 start]
}

//创建主队列、addOperation
//结果:在主线程中执行
- (void)testOperationMainQueueThree
{
    //主队列
    NSOperationQueue *queue = [NSOperationQueue mainQueue];

    //使用addOperationWithBlock:添加操作到队列中
    [queue addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2];
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
//1、凡是添加到主队列中的操作,都会放到主线程中执行;
//   但是这里有个addExecutionBlock,根据上面介绍:会开启子线程(也在当前线程执行)
//   如果只有addOperationWithBlock也在主线程执行
//



@end

