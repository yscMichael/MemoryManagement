//
//  InvocationOperationController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "InvocationOperationController.h"

@interface InvocationOperationController ()

@end

@implementation InvocationOperationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self testInvocationOperation];
}

//NSInvocationOperation
//结果:阻塞主线程(不给任务指定线程的话,默认在当前线程执行,这里当前线程是主线程)
- (void)testInvocationOperation
{
    //1.创建NSInvocationOperation对象
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperationTask) object:nil];
    //2.调用start方法开始执行操作
    [op start];
}

//执行任务
- (void)invocationOperationTask
{
    [NSThread sleepForTimeInterval:2];
    NSLog(@"1---%@", [NSThread currentThread]);
}

//总结:
//1、在没有使用NSOperationQueue时,默认在当前线程执行
//2、此时需要主动调用start方法




@end
