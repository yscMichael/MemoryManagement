//
//  InterceptedVariableController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/7.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "InterceptedVariableController.h"

int globalCount = 10;
static int staticCount = 10;

@interface InterceptedVariableController ()

@end

@implementation InterceptedVariableController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self InterceptedVariable];
    [self ChangeInterceptedVariable];
    [self StaticVariable];
    [self StaticGlobalVariable];
    [self GlobalVariable];
}

//截获自动变量
- (void)InterceptedVariable
{
    int val = 10;

    void (^blk)(void) = ^{
        NSLog(@"截获自动变量val = %d",val);//10
    };

    val = 2;
    blk();
}

//__block变量
- (void)ChangeInterceptedVariable
{
    __block int val = 10;

    void (^blk)(void) = ^{
        NSLog(@"__block变量val = %d",val);//2
        val = 1;
    };

    //val是__block类型,这里会影响block输出的
    val = 2;
    blk();
    //val是__block类型,这里会影响block输出的
    NSLog(@"__block变量val = %d",val);//1
}

//静态变量
- (void)StaticVariable
{
    static int val = 10;

    void (^blk)(void) = ^{
        NSLog(@"staticval = %d",val);//2
        val = 1;
    };

    //val是静态变量,会影响block输出
    val = 2;
    blk();
    //val是静态变量,会影响block输出
    NSLog(@"staticval = %d",val);//1
}

//静态全局变量
- (void)StaticGlobalVariable
{
    void (^blk)(void) = ^{
        NSLog(@"StaticGlobal = %d",staticCount);//2
        staticCount = 1;
    };

    //staticCount是静态全局变量,会影响block输出
    staticCount = 2;
    blk();
    //staticCount是静态全局变量,会影响block输出
    NSLog(@"StaticGlobal = %d",staticCount);//1
}

//全局变量
- (void)GlobalVariable
{
    void (^blk)(void) = ^{
        NSLog(@"Global = %d",globalCount);//2
        globalCount = 1;
    };

    //count是静态全局变量,会影响block输出
    globalCount = 2;
    blk();
    //val是静态全局变量,会影响block输出
    NSLog(@"Global = %d",globalCount);//1
}


//总结:
//1、针对自动变量也就是局部变量,在不加__block的情况下,只能截获数值,不能改变数值
//2、如果变量是静态变量、静态全局变量、全局变量,则可以进行截取并修改值


@end


