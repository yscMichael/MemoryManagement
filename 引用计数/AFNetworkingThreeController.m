//
//  AFNetworkingThreeController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/24.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "AFNetworkingThreeController.h"

@interface AFNetworkingThreeController ()

@end

@implementation AFNetworkingThreeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

}

//总结:
//1、文件目录的区别:3.0之后没有NSURLConnection文件夹
//   由于苹果在iOS 7.0开始推出NSURLSession网络框架(在iOS 9.0开始NSURLConnection过期)
//   所以AFNetworking从3.0版本开始取消了NSURLConnection,使用NSURLSession代替.
//
//2、新增回调处理:3.0之后新增了下载进度的回调
//
//3、支持Https协议的实现方式区别:
//   在3.0之前设置allowInvalidCertificates的值是YES就可以实现对https的支持
//   在3.0之后设置validatesDomainName的值是NO才能达到效果,
//    设allowInvalidCertificates没有效果
//
//4、网络请求区别
//   2.6.3版本及之前:发送网络请求主要使用AFHTTPRequestOperationManager中的get和post等请求
//   3.0版本及以后:发送网络请求则使用的是AFHTTPSessionManager中的get和post等请求



@end


