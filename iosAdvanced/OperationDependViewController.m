//
//  OperationDependViewController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "OperationDependViewController.h"

@interface OperationDependViewController ()

@end

@implementation OperationDependViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //NSOperation操作依赖
    [self testOperationDependency];
}

//场景:有A、B两个操作,其中A执行完操作,B才能执行操作
//结果:开辟新的子线程,不过op2先执行,后执行op1
- (void)testOperationDependency
{
    //1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //2.创建操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++)
        {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1--%d--%@", i,[NSThread currentThread]);
        }
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++)
        {
            [NSThread sleepForTimeInterval:5];
            NSLog(@"2--%d--%@", i,[NSThread currentThread]);
        }
    }];

    //3.添加依赖
    [op1 addDependency:op2]; //让op2依赖于op1,则先执行op1,在执行op2

    //4.添加操作到队列中
    [queue addOperation:op1];
    [queue addOperation:op2];
}

//总结:
//   1、任务A依赖任务B,无论A任务有多耗时,B任务都会耐心等待
//   2、是否开启子线程取决于当前队列类型



@end
