//
//  Dog.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/24.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "Dog.h"

@implementation Dog

//+ (void)load
//{
//    NSLog(@"我是Dog");
//}

+ (void)initialize
{
    NSLog(@"我是Dog-initialize");
}

@end
