//
//  DispatchSuspendController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/14.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "DispatchSuspendController.h"

@interface DispatchSuspendController ()

@end

@implementation DispatchSuspendController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self testOne];
}

- (void)testOne
{
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd", DISPATCH_QUEUE_SERIAL);

    //提交第一个block，延时5秒打印。
    dispatch_async(queue, ^{
        sleep(5);
        NSLog(@"任务1执行完毕");
    });
    //提交第二个block，也是延时5秒打印
    dispatch_async(queue, ^{
        sleep(5);
        NSLog(@"任务2执行完毕");
    });

    //延时3s、不影响当前线程
    dispatch_time_t timeThree = dispatch_time(DISPATCH_TIME_NOW, 3ull * NSEC_PER_SEC);
    dispatch_after(timeThree, dispatch_get_main_queue(), ^{
        //挂起队列
        NSLog(@"suspend...");
        dispatch_suspend(queue);
    });

    //延时10s、不影响当前线程
    dispatch_time_t timeTen = dispatch_time(DISPATCH_TIME_NOW, 10ull * NSEC_PER_SEC);
    dispatch_after(timeTen, dispatch_get_main_queue(), ^{
        //恢复队列
        NSLog(@"resume...");
        dispatch_resume(queue);
    });
}

//总结:
//1、dispatch_suspend并不会立即暂停正在运行的block，而是在当前block执行完成后，暂停后续的block执行
//



@end
