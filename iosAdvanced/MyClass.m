//
//  MyClass.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/9.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "MyClass.h"

@implementation MyClass

NSObject *__globalObj = nil;

- (id)init
{
    if (self = [super init])
    {
        _instanceObj = [[NSObject alloc] init];
    }
    return self;
}

- (void)test
{
    static NSObject* __staticObj = nil;
    __globalObj = [[NSObject alloc] init];
    __staticObj = [[NSObject alloc] init];

    NSObject* localObj = [[NSObject alloc] init];
    __block NSObject* blockObj = [[NSObject alloc] init];

    typedef void (^MyBlock)(void) ;
    MyBlock aBlock = ^{
        NSLog(@"%@", __globalObj);
        NSLog(@"%@", __staticObj);
        NSLog(@"%@", _instanceObj);
        NSLog(@"%@", localObj);
        NSLog(@"%@", blockObj);
    };
    aBlock = [[aBlock copy] autorelease];
    aBlock();

    NSLog(@"%lu", (unsigned long)[__globalObj retainCount]);//1
    NSLog(@"%lu", (unsigned long)[__staticObj retainCount]);//1
    NSLog(@"%lu", (unsigned long)[_instanceObj retainCount]);//1
    NSLog(@"%lu", (unsigned long)[localObj retainCount]);//2
    NSLog(@"%lu", (unsigned long)[blockObj retainCount]);//1
}

//解释:
//__globalObj和__staticObj在内存中的位置是确定的,所以Block copy时不会retain对象
//blockObj在Block copy时也不会retain
//_instanceObj在Block copy时也没有直接retain _instanceObj对象本身,但会retain self.所以在Block中可以直接读写_instanceObj变量
//localObj在Block copy时,系统自动retain对象，增加其引用计数


//● 在栈上调用copy那么复制到堆上
//● 在全局block调用copy什么也不做
//● 在堆上调用block 引用计数增加
//● 在ARC环境下，如果不确定是否要copy block尽管copy即可。ARC会打扫战场




@end
