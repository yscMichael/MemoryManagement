//
//  BlockOperationViewController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "BlockOperationViewController.h"

@interface BlockOperationViewController ()

@end

@implementation BlockOperationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //[self testBlockOperationOne];
    [self testBlockOperationMore];
}

//NSBlockOperation
//结果:阻塞主线程(不给任务指定线程的话,默认在主线程执行)
- (void)testBlockOperationOne
{
    //1.创建NSBlockOperation对象
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1---%@", [NSThread currentThread]);
    }];
    //2.调用start方法开始执行操作
    [op start];
}

//添加多个操作
//结果:这些操作有的在主线程执行,有的在子线程中执行
- (void)testBlockOperationMore
{
    // 1.创建NSBlockOperation对象
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1---%@", [NSThread currentThread]);
    }];
    //2.添加额外的操作
    [op addExecutionBlock:^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"2---%@", [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"3---%@", [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"4---%@", [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"5---%@", [NSThread currentThread]);
    }];
    //3.调用 start 方法开始执行操作
    [op start];
}

//总结:
//1、在没有使用NSOperationQueue,NSBlockOperation只封装一个操作,默认在当前线程执行
//2、在没有使用NSOperationQueue,NSBlockOperation封装多个操作,会开启子线程(也在当前线程执行)


@end


