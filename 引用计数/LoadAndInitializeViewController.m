//
//  LoadAndInitializeViewController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "LoadAndInitializeViewController.h"

@interface LoadAndInitializeViewController ()

@property (nonatomic , strong) NSString *name;

@end

@implementation LoadAndInitializeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.name = @"string";
}

//总结:
//
//
//
//
//
//
//



//参考文章:
//1、不得不知的load与initialize
//   http://www.cocoachina.com/ios/20161012/17732.html

@end

