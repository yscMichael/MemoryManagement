//
//  Bulldog.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/24.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "Bulldog.h"

@implementation Bulldog

//+ (void)load
//{
//    NSLog(@"我是斗牛犬");
//}

+ (void)initialize
{
    NSLog(@"我是斗牛犬-initialize");
}

@end
