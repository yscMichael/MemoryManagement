//
//  VariablesDifferenceController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/18.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "VariablesDifferenceController.h"

@interface VariablesDifferenceController ()
{
    NSString *name;//实例变量
    int count;//基本数据类型
}//里面的全是成员变量

@property (nonatomic , strong) NSString *price;//属性


@end

@implementation VariablesDifferenceController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

//总结:
// 1、成员变量
//  成员变量用于类内部，无需与外界接触的变量
//  因为成员变量不会生成set、get方法,所以外界无法与成员变量接触
//
// 2、属性
//   根据成员变量的私有性,为了方便访问,所以就有了属性变量
//   属性变量是用于与其他对象交互的变量
//
// 备注:现在成员变量不怎么使用,因为基于类扩展,也可以定义私有属性
//

@end

