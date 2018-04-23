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
//   a、Runtime:根据模型中属性,去字典中取出对应的value给模型属性赋值
//      //获取类中的所有成员变量
//      Ivar *ivarList = class_copyIvarList(self, &count);
//      //获取成员变量名字
//      NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
//      //处理成员变量名->字典中的key(去掉 _ ,从第一个角标开始截取)
//      NSString *key = [ivarName substringFromIndex:1];
//      //根据成员属性名去字典中查找对应的value
//      id value = dict[key];
//      //接下来进行各种判空操作


@end

