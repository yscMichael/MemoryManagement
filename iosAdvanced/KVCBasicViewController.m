//
//  KVCBasicViewController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/6.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "KVCBasicViewController.h"

@interface KVCBasicViewController ()

@end

@implementation KVCBasicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

}

//总结:
//一、四个常用方法
//   直接通过Key来取值
//   - (nullable id)valueForKey:(NSString *)key;
//   通过Key来设值
//   - (void)setValue:(nullable id)value forKey:(NSString *)key;
//   通过KeyPath来取值
//   - (nullable id)valueForKeyPath:(NSString *)keyPath;
//   通过KeyPath来设值
//   - (void)setValue:(nullable id)value forKeyPath:(NSString *)keyPath;



@end
