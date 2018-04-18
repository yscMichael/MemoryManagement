//
//  NSObject+Property.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/18.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/message.h>

@implementation NSObject (Property)

- (NSString *)name
{
    return objc_getAssociatedObject(self, @"name");
}

- (NSString *)height
{
    return objc_getAssociatedObject(self, @"height");
}

@end
