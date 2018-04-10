//
//  CGDBasicViewController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/9.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "CGDBasicViewController.h"

typedef void(^blockCGD)(void);

@interface CGDBasicViewController ()

@end

@implementation CGDBasicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //串行队列+异步
    //[self serialQueueAsyncStudy];
    //串行队列+同步
    //[self serialQueueSyncStudy];
    //并发队列+异步
    //[self concurrentQueueAsyncStudy];
    //并发队列+同步
    [self concurrentQueueSyncStudy];
}

//串行队列+异步
//分析:串行队列:让任务一个个执行(这里打印0-9)
//    异步执行:会开辟子线程(CPU允许开辟子线程,发现你是串行队列,因此给你1条就行了)
//    这里的子线程是随机给的!!!
//结果:任务在新开的子线程中一个个执行
- (void)serialQueueAsyncStudy
{
    dispatch_queue_t queue = dispatch_queue_create("com.example.gcd.MySerialQueue", DISPATCH_QUEUE_SERIAL);

    for (int i = 0; i < 10; i++)
    {
        //创建多个任务
        void (^task)() = ^{
            //mainThread:1
            NSLog(@"%d %@",i, [NSThread currentThread]);
        };
        //将任务添加到串行队列
        //异步执行
        dispatch_async(queue, task);
    }
}

//串行队列+同步
//分析:串行队列:让任务一个个执行(这里打印0-9)
//    同步执行:不会开辟子线程(CPU不允许开线程)
//    这里就在主线程执行
//结果:任务在主线程中一个个执行
- (void)serialQueueSyncStudy
{
    dispatch_queue_t queue = dispatch_queue_create("com.example.gcd.MySerialQueue", DISPATCH_QUEUE_SERIAL);

    for (int i = 0; i < 10; i++)
    {
        //创建多个任务
        void (^task)() = ^{
            //mainThread:1
            NSLog(@"%d %@",i, [NSThread currentThread]);
        };
        //将任务添加到串行队列
        //同步执行
        dispatch_sync(queue, task);
    }
}

//并发队列+异步
//分析:并发队列:可以让多个任务并发（同时）执行
//    异步执行:会开辟新的子线程(CPU看你是并发队列,会多开一些子线程给你)
//    这里的子线程名称和数目是随机给的!!!
//结果:任务被分配不同线程执行,执行顺序是不可控的
- (void)concurrentQueueAsyncStudy
{
    dispatch_queue_t queue = dispatch_queue_create("com.example.gcd.MySerialQueue", DISPATCH_QUEUE_CONCURRENT);

    for (int i = 0; i < 10; i++)
    {
        //创建多个任务
        void (^task)() = ^{
            //mainThread:1
            NSLog(@"%d %@",i, [NSThread currentThread]);
        };
        //将任务添加到并发队列
        //同步执行
        dispatch_async(queue, task);
    }
}

//并发队列+同步
//分析:并发队列:可以让多个任务并发（同时）执行
//    同步执行:不会开辟子线程
//    这里默认是主线程(任你队列可以让任务同时执行,但是开发者就给你一条路,无路可选,只能乖乖在主线程执行.根据FIFO原则,结果肯定是任务在主线程一个个按顺序执行)
//结果:任务在主线程一个个按顺序执行
- (void)concurrentQueueSyncStudy
{
    dispatch_queue_t queue = dispatch_queue_create("com.example.gcd.MySerialQueue", DISPATCH_QUEUE_CONCURRENT);

    for (int i = 0; i < 10; i++)
    {
        //创建多个任务
        void (^task)() = ^{
            //mainThread:1
            NSLog(@"%d %@",i, [NSThread currentThread]);
        };
        //将任务添加到并发队列
        //同步执行
        dispatch_sync(queue, task);
    }
}

//线程基本知识:
//一、进程和线程:
//   1、计算机的核心是CPU,它承担了所有的计算任务;单个CPU一次只能运行一个任务.
//   2、进程可以指某个应用程序,代表CPU所能处理的单个任务.
//   3、任意时刻,CPU总能运行一个进程,其它处于待命状态
//   4、进程里面可以开多个线程,来完成CPU任务
//   5、同一个进程内的线程共享进程资源
//   参考网站:
//   http://www.ruanyifeng.com/blog/2013/04/processes_and_threads.html

//二、多线程原理
//   1、同一时间,一个CPU只能处理一条线程,只有一条线程在工作
//   2、多线程并发执行,其实是 CPU 快速的在多条线程之间调度(切换)
//   3、如果 CPU 调度线程的时间足够快, 就造成了多线程并发执行的假象

//三、同步和异步的区别
//   1、同步: 在当前线程中执行任务
//   2、异步: 开辟一条子线程来执行任务

//四、串行和并发
//   1、串行:让任务一个接着一个地执行(一个任务执行完毕后,再执行下一个任务)
//   2、并发:可以让多个任务并发(同时)执行(自动开启多个线程同时执行任务).并发功能只有在异步（dispatch_async）函数下才有效

//总结:
//注意:这里的任务不同于上面的进程和线程里面讲的
//通俗来讲每个App都是一个进程
//下面有好多任务需要做,此时是否需要开辟新的线程来完成任务---这就是同步和异步
//具体执行任务的时候,此时是否需要按顺序执行---这就是串行和并发

//GCD介绍如下:
//CGD的核心就是将任务添加到队列

//一、队列和任务
//   1、任务:执行什么操作
//   2、队列:用来存放任务

//二、CGD工作流程
//   1、创建任务,简单来说就是BLOCK里面内容
//   2、将任务添加到队列
//   3、GCD会自动将队列中的任务取出，放到对应的线程中执行
//   4、任务的取出遵循队列的FIFO原则：先进先出，后进后出

//三、串行和并发在GCD体现方式!!!!
//   1、队列含义
//   创建队列:串行队列和并发队列
//   串行队列:让任务按照先进先出的顺序执行,队列掌握着
//   并行队列:让多个任务同时执行,队列掌握着
//   2、创建方式
//     (1)、手动创建
//       dispatch_queue_t queue = dispatch_queue_create("队列名称", 串行还是并行)
//       DISPATCH_QUEUE_SERIAL:串行队列
//       DISPATCH_QUEUE_CONCURRENT:并发队列
//     (2)、系统方法
//
//

//四、同步和异步在GCD的体现!!!!
//   1、对同步异步和串行并发的深度理解
//     上面讲到串行队列和并发队列,讲到了队列可以分派任务的功能
//     但是你要注意了,队列不是一切的主导者,主导者还是在开发者,为什么呢？
//     队列可以管理任务,但我们掌握着CPU,只有我们给CPU发出指令,让CPU调度线程,才能达到多线程效果
//     所以队列是多线程的前提,还要看当前开发者让你异步还是同步执行(给不给你资源!!!!)
//
//     注意:在队列和开发者都允许多线程的前提下,使用的线程数是由系统决定的(自己控制不了啊!!!)
//
//   2、实现方式
//     a、异步
//        dispatch_async(队列,block)
//     b、同步
//        dispatch_sync(队列,block)


//额外知识补充:
//一、NSThread编程

//二、NSObject分类:
//   a、performSelectorOnMainThread
//   b、performSelector
//   c、performSelectorInBackground

@end



