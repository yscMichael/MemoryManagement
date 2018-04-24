//
//  SwiftMixingViewController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/24.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "SwiftMixingViewController.h"

@interface SwiftMixingViewController ()

@end

@implementation SwiftMixingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

}

//总结:
//一、混编设置
//   1、创建桥接文件,即时header文件
//   2、header文件(文件名-Bridging-Header.h)
//   3、创建swift文件
//      要记住创建的文件必须是继承与NSobject或者间接继承与NSobject
//      这样才能保证调用成功.viewcontroller间接的继承NSobject是可取的
//
//
//
//二、swift相关面试题
//

@end


