//
//  CustomOperationController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "CustomOperationController.h"
#import "YYOperation.h"

@interface CustomOperationController ()

@end

@implementation CustomOperationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self testCustomizeOperation];
}

//测试自定义Operation
//结果:在主线程(当前线程)执行
- (void)testCustomizeOperation
{
    //1.创建YYOperation对象
    YYOperation *op = [[YYOperation alloc] init];
    //2.调用start方法开始执行操作
    [op start];
}

//结论:
//1、自定义Operation需要重写main或者start方法
//2、在没有使用NSOperationQueue,默认在当前线程执行



@end


