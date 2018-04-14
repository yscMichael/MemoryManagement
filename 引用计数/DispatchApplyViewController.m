//
//  DispatchApplyViewController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/14.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "DispatchApplyViewController.h"

@interface DispatchApplyViewController ()

@end

@implementation DispatchApplyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //测试并发队列
    //[self testDispatchApplyConcurrent];
    //测试串行队列
    //[self testDispatchApplySerial];
    //经典用法
    [self classicWay];
}

//测试DispatchApply
//结果:这里面的block执行顺序不一定;因为是并发队列,会开辟新的子线程
- (void)testDispatchApplyConcurrent
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(10, queue, ^(size_t index) {

        //这里会对所有的block进行执行,而且是开辟新线程执行
        //异步执行所有的block,但是会阻断下面程序的执行
        NSLog(@"%zu + %@",index,[NSThread currentThread]);
    });
    NSLog(@"done");
}

//测试串行队列
//结果是一个个执行,无意义,本来串行队列就是一个个执行
- (void)testDispatchApplySerial
{
    dispatch_queue_t queue = dispatch_queue_create("com.test", DISPATCH_QUEUE_SERIAL);
    //因为dispatch_apply类似于dispatch_sync
    //所以此时使用主队列会崩溃
    dispatch_apply(10, queue, ^(size_t index) {

        //这里会对所有的block进行执行,而且是开辟新线程执行
        //异步执行所有的block,但是会阻断下面程序的执行
        NSLog(@"%zu + %@",index,[NSThread currentThread]);
    });

    NSLog(@"done");
}

//经典使用方式
- (void)classicWay
{
    NSArray *array = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",nil];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    //在global_queue中非同步执行
    dispatch_async(queue, ^{

        //等待dispatch_apply全部处理结束
        dispatch_apply([array count], queue, ^(size_t index) {
            //并列处理包含在NSArray里面的全部对象
            NSLog(@"%@",[NSThread currentThread]);
            NSLog(@"%zu + %@",index,[array objectAtIndex:index]);
        });
        //dispatch_apply已经全部处理结束

        //在主队列非同步执行
        //主队列一定不添加同步任务
        dispatch_async(dispatch_get_main_queue(), ^{

            NSLog(@"done");
        });

    });
}

//总结:
//一、dispatch_apply特性
//   1、类似于dispatch_sync,会等待处理(任务)执行结束
//   2、内部block,不一定是同步或者异步,取决于添加到什么队列里面
//   3、添加到并发队列的任务,默认是会开启多个子线程来执行的
//   4、添加到串行队列,在当前线程执行
//      因为dispatch_apply类似于dispatch_sync,所以此时使用主队列会崩溃
//   5、推荐在dispatch_async中非同步的执行dispatch_apply函数

//二、应用场景
//   1、从服务器获取字典数据,采取这样措施字典转模型,效率更高
//


@end


