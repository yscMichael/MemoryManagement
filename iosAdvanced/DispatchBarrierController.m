//
//  DispatchBarrierController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/11.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "DispatchBarrierController.h"

@interface DispatchBarrierController ()

@end

@implementation DispatchBarrierController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //测试栅栏函数
    //[self testBarrier];
    //测试发现全局并发队列失效
    [self testGlobalConcurrentQueue];
}

//测试栅栏函数
//异步结果:helloWorld、(blk0和blk1执行、顺序不定)、testBarrier、(blk2和blk3执行、顺序不定)
//同步结果:(blk0和blk1执行、顺序不定)、testBarrier、helloWorld、(blk2和blk3执行、顺序不定)
- (void)testBarrier
{
    //同dispatch_queue_create函数生成的concurrent Dispatch Queue队列一起使用
    dispatch_queue_t queue = dispatch_queue_create("12312312", DISPATCH_QUEUE_CONCURRENT);

    dispatch_async(queue, ^{
        NSLog(@"blk0 = %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"blk1 = %@", [NSThread currentThread]);
    });

    //异步
//    dispatch_barrier_async(queue, ^{
//        [NSThread sleepForTimeInterval:3.0];
//        NSLog(@"testBarrier = %@", [NSThread currentThread]);
//    });

    //同步
    dispatch_barrier_sync(queue, ^{
        [NSThread sleepForTimeInterval:3.0];
        NSLog(@"testBarrier = %@", [NSThread currentThread]);
    });

    NSLog(@"helloWorld");

    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:3.0];
        NSLog(@"blk2 = %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"blk3 = %@", [NSThread currentThread]);
    });
}

//测试全局并发队列
- (void)testGlobalConcurrentQueue
{

}

//总结:
//一、dispatch_barrier_async作用
//1、实现高效率的数据库访问和文件访问
//2、避免数据竞争
//3、称为栅栏函数
//
//二、dispatch_barrier_async和dispatch_barrier_sync区别
//1、相同点:都会等待在它前面插入队列的任务先执行完,再执行完自己的,再执行后面的
//2、不同点:
//        异步不会阻断整个线程,可以把任务先插入队列,但不执行
//        同步会阻断整个线程,没有把任务先插入队列,肯定也不执行

@end

