//
//  SwizzlingMethodViewController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "SwizzlingMethodViewController.h"
#import "Fruit.h"
#import "Apple.h"
#import "Banana.h"
#import "Apple+AppleOne.h"
#import "Banana+BananaOne.h"

@interface SwizzlingMethodViewController ()

@end

@implementation SwizzlingMethodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //苹果执行的是(添加成功)
    Apple *apple = [[Apple alloc] init];
    [apple canEat];//交换后的方法IMP //swizzling---苹果
    [apple swizzlingApplecanEat];  //水果可以吃喔

    //香蕉执行的是(交换方法)
    Banana *banana = [[Banana alloc] init];
    [banana canEat];//交换后的方法IMP  //swizzling---香蕉
    [banana swizzlingBananacanEat];  //香蕉可以吃喔
}



@end

