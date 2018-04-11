//
//  DispatchSemaphoreController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/11.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "DispatchSemaphoreController.h"

@interface DispatchSemaphoreController ()

@end

@implementation DispatchSemaphoreController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

}

//应用场景:
//1、假设现在系统有两个空闲资源可以被利用，但同一时间却有三个线程要进行访问，这种情况下，该如何处理呢？
//2、我们要下载很多图片，并发异步进行，每个下载都会开辟一个新线程，可是我们又担心太多线程肯定cpu吃不消，那么我们这里也可以用信号量控制一下最大开辟线程数。




@end
