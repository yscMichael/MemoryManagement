//
//  OperationqueuePriorityController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "OperationqueuePriorityController.h"

@interface OperationqueuePriorityController ()

@end

@implementation OperationqueuePriorityController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self testOperationMainQueuePriority];
}

//结果:设置优先级不一定是第一个执行,会稍有提前
- (void)testOperationMainQueuePriority
{
    //主队列
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    //使用NSInvocationOperation创建操作1
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperationTask) object:nil];
    //使用NSBlockOperation创建操作2
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"2---%@", [NSThread currentThread]);
    }];
    //使用NSBlockOperation创建操作3
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"3---%@", [NSThread currentThread]);
    }];

    //设置优先级
    [op3 setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [op1 setQueuePriority:NSOperationQueuePriorityVeryLow];
    [op2 setQueuePriority:NSOperationQueuePriorityLow];

    //3.使用addOperation:添加所有操作到队列中
    [queue addOperation:op1];//[op1 start]
    [queue addOperation:op2];//[op2 start]
    [queue addOperation:op3];//[op2 start]
}

//执行任务
- (void)invocationOperationTask
{
    [NSThread sleepForTimeInterval:5];
    NSLog(@"1---%@", [NSThread currentThread]);
}

//总结:
//1、queuePriority属性适用于同一操作队列中的操作,不适用于不同操作队列中的操作.
//2、默认情况下,所有新创建的操作对象优先级都是NSOperationQueuePriorityNormal.
//   但是我们可以通过setQueuePriority:方法来改变当前操作在同一队列中的执行优先级
//3、queuePriority优先级不能取代依赖关系
//4、设置优先级不一定是第一个执行,会稍有提前
//
//
//   typedef NS_ENUM(NSInteger, NSOperationQueuePriority) {
//      NSOperationQueuePriorityVeryLow = -8L,
//      NSOperationQueuePriorityLow = -4L,
//      NSOperationQueuePriorityNormal = 0,
//      NSOperationQueuePriorityHigh = 4,
//      NSOperationQueuePriorityVeryHigh = 8
//   };


@end


