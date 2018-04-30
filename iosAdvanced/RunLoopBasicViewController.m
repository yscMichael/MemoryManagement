//
//  RunLoopBasicViewController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "RunLoopBasicViewController.h"
#import "HLThread.h"

@interface RunLoopBasicViewController ()

@end

@implementation RunLoopBasicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self threadTest];
}

- (void)threadTest
{
    HLThread *subThread = [[HLThread alloc] initWithTarget:self selector:@selector(subThreadOpetion) object:nil];
    [subThread start];
}

- (void)subThreadOpetion
{
    NSLog(@"%@----子线程任务开始",[NSThread currentThread]);
    [NSThread sleepForTimeInterval:3.0];
    NSLog(@"%@----子线程任务结束",[NSThread currentThread]);
}

//总结:
//一、使用场景
//1、当子线程中的任务执行完毕后,线程就被立刻销毁了.
//   如果程序中,需要经常在子线程中执行任务,频繁的创建和销毁线程,会造成资源的浪费.
//   这时候我们就可以使用RunLoop来让该线程长时间存活而不被销毁.
//
//
//
//

@end




