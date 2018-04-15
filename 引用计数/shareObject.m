//
//  shareObject.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/15.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "shareObject.h"

static shareObject *instance = nil;

@implementation shareObject
//command + control + ↕️:文件之间切换

//单例
+ (instancetype)shareObject
{
    //这个参数用来保证执行一次
    //所以里面不能判断是否为nil
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[shareObject alloc] init];
    });
    return instance;
}

//另一种实现方式
//不建议<有多线程问题>
+ (instancetype)shareObjectOther
{
    if(!instance)
    {
        instance = [[shareObject alloc] init];
    }
    return instance;
}

//还有一种实现方式
//不建议<性能不比dispatch_once高>
//原因猜测:可能每次都要执行判断操作,dispatch_once连判断操作都不要
+ (instancetype)shareOther
{
    @synchronized(self)
    {
        if (!instance)
        {
            instance = [[shareObject alloc] init];
        }
    }
    return instance;
}

//参考文章:
//   1、细说@synchronized和dispatch_once
//   https://www.jianshu.com/p/ef3f77c8b320



@end
