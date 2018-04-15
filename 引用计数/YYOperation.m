//
//  YYOperation.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/15.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "YYOperation.h"
//重写main或者start方法

@implementation YYOperation

- (void)main
{
    if (!self.isCancelled)
    {
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1---%@", [NSThread currentThread]);
    }
}

@end


