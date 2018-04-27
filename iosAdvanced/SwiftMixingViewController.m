//
//  SwiftMixingViewController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/24.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "SwiftMixingViewController.h"
#import "iosAdvanced-Swift.h"

@interface SwiftMixingViewController ()

@end

@implementation SwiftMixingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    TestSwiftDemo *testDemo = [[TestSwiftDemo alloc] init];
    [testDemo show];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    SwiftTestViewController *swiftCtrl = [[SwiftTestViewController alloc] init];
    [self.navigationController pushViewController:swiftCtrl animated:YES];
}

//总结:
//一、混编设置
//   1、创建swift文件
//      要记住创建的文件必须是继承与NSobject或者间接继承与NSobject
//      这样才能保证调用成功.viewcontroller间接的继承NSobject是可取的
//   注意:此时会自动创建桥接文件,如果创建不了,参照下面
//   2、header文件名称和路径
//      名称:(文件名-Bridging-Header.h)
//      路径:找到targets->build settings ->Ojective-C Bridging Header,配置路径
//   3、想要调用swift,导入头文件,头文件名称要求如下
//      项目名称-Swift.h
//
//二、swift相关面试题
//
//
//参考文章:
//  1、iOS OC项目调用Swift类
//     https://blog.csdn.net/u010407865/article/details/62886943
//  2、Xcode not automatically creating bridging header?
//     https://stackoverflow.com/questions/31716413/xcode-not-automatically-creating-bridging-header
//  3、OC和Swift相互调用文章详解
//     https://www.cnblogs.com/yajunLi/p/5920676.html

@end


