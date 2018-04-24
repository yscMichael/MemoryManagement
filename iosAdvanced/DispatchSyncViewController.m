//
//  DispatchSyncViewController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/14.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "DispatchSyncViewController.h"

@interface DispatchSyncViewController ()

@end

@implementation DispatchSyncViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //[self testOne];
    //[self testTwo];
    [self testThree];
}

//以下是三种经常崩溃的例题
//这里理由不再分析,详情见GCD基础知识
//tips:看任务之间关系
- (void)testOne
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_sync(queue, ^{
        NSLog(@"hello");
    });
}

- (void)testTwo
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        dispatch_sync(queue, ^{
            NSLog(@"hello");
        });
    });
}

- (void)testThree
{
    dispatch_queue_t queue = dispatch_queue_create("com.test", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        dispatch_sync(queue, ^{
            NSLog(@"hello");
        });
    });
}



@end
