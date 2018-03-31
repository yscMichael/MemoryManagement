//
//  NSObject+Category.m
//  引用计数
//
//  Created by 杨世川 on 18/3/27.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "NSObject+Category.h"

@implementation NSObject (Category)

+ (id)Object
{
    return [NSMutableArray array];
    //    NSMutableArray *marr = [NSMutableArray array];
    //    return marr;

    //return [[NSMutableArray alloc]init];
}

+ (id)allocObject
{
    return [NSMutableArray array];
    //return [[NSMutableArray alloc]init];
}

@end
