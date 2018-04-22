//
//  DictionaryToModelController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/18.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "DictionaryToModelController.h"

@interface DictionaryToModelController ()

@end

@implementation DictionaryToModelController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];


}

//总结:
//1、字典转模型KVC实现
//   setValue:forKey
//   缺点:必须保证，模型中的属性和字典中的key 一一对应
//   解决办法:重写对象的setValue:forUndefinedKey:,把系统的方法覆盖,就能继续使用KVC字典转模型了
//
//2、使用runtime
//
//


@end

