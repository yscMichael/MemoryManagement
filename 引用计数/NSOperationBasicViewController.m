//
//  NSOperationBasicViewController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/15.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "NSOperationBasicViewController.h"
#import "YYOperation.h"

@interface NSOperationBasicViewController ()

@end

@implementation NSOperationBasicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //NSInvocationOperation
    //[self testInvocationOperation];

    //NSBlockOperation单个任务
    //[self testBlockOperationOne];
    //NSBlockOperation多个任务
    //[self testBlockOperationMore];

    //自定义Operation
    //[self testCustomizeOperation];

    //创建主队列
    //[self testOperationMainQueueOne];
    //[self testOperationMainQueueTwo];
    //创建自定义队列
    //[self testOperationCustomizeQueueOne];
    //[self testOperationCustomizeQueueTwo];
}

//NSInvocationOperation
//结果:阻塞主线程(不给任务指定线程的话,默认在当前线程执行,这里当前线程是主线程)
//结论:在没有使用NSOperationQueue,默认在当前线程执行
- (void)testInvocationOperation
{
    //1.创建NSInvocationOperation对象
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperationTask) object:nil];
    //2.调用start方法开始执行操作
    [op start];
}

//执行任务
- (void)invocationOperationTask
{
    [NSThread sleepForTimeInterval:2];
    NSLog(@"1---%@", [NSThread currentThread]);
}

//NSBlockOperation
//结果:阻塞主线程(不给任务指定线程的话,默认在主线程执行)
//结论:在没有使用NSOperationQueue,NSBlockOperation只封装一个操作,默认在当前线程执行
- (void)testBlockOperationOne
{
    //1.创建NSBlockOperation对象
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@", [NSThread currentThread]);
    }];
    //2.调用start方法开始执行操作
    [op start];
}

//添加多个操作
//结果:这些操作有的在主线程执行,有的在子线程中执行
//结论:在没有使用NSOperationQueue,NSBlockOperation封装多个操作,会开启子线程(也在当前线程执行)
- (void)testBlockOperationMore
{
    // 1.创建NSBlockOperation对象
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@", [NSThread currentThread]);
    }];
    //2.添加额外的操作
    [op addExecutionBlock:^{
            [NSThread sleepForTimeInterval:3];
            NSLog(@"2---%@", [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
            [NSThread sleepForTimeInterval:1];
            NSLog(@"3---%@", [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
            [NSThread sleepForTimeInterval:2];
            NSLog(@"4---%@", [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
            [NSThread sleepForTimeInterval:3];
            NSLog(@"5---%@", [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
            [NSThread sleepForTimeInterval:2];
            NSLog(@"6---%@", [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
            [NSThread sleepForTimeInterval:1];
            NSLog(@"7---%@", [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
            [NSThread sleepForTimeInterval:3];
            NSLog(@"8---%@", [NSThread currentThread]);
    }];
    //3.调用 start 方法开始执行操作
    [op start];
}

//测试自定义Operation
//结果:在没有使用NSOperationQueue,默认在当前线程执行
- (void)testCustomizeOperation
{
    //1.创建YYOperation对象
    YYOperation *op = [[YYOperation alloc] init];
    //2.调用start方法开始执行操作
    [op start];
}

//创建主队列、创建Operation + blocks
//结果:有的在主线程,有的在子线程
//凡是添加到主队列中的操作,都会放到主线程中执行;但是这里有个addExecutionBlock,根据上面介绍:
//会开启子线程(也在当前线程执行)
- (void)testOperationMainQueueOne
{
    //主队列
    NSOperationQueue *queue = [NSOperationQueue mainQueue];

    //使用NSInvocationOperation创建操作1
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperationTask) object:nil];
    // 使用 NSBlockOperation创建操作2
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2---%@", [NSThread currentThread]);
    }];
    [op2 addExecutionBlock:^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"3---%@", [NSThread currentThread]);
    }];

    // 3.使用 addOperation: 添加所有操作到队列中
    [queue addOperation:op1]; // [op1 start]
    [queue addOperation:op2]; // [op2 start]
}

//创建主队列、不创建Operation、使用blocks
//结果:全部在主线程执行(在当前线程执行)
//这里的多个任务是对队列添加的,不存在addExecutionBlock那种情况,不开辟新的线程
- (void)testOperationMainQueueTwo
{
    //主队列
    NSOperationQueue *queue = [NSOperationQueue mainQueue];

    //使用addOperationWithBlock:添加操作到队列中
    [queue addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1---%@", [NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"2---%@", [NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"3---%@", [NSThread currentThread]);
    }];
}

//创建自定义队列、创建Operation + blocks
//结果:这里开启了子线程、并发执行
//添加到这种队列中的操作,就会自动放到子线程中执行(包含串行、并发功能)
- (void)testOperationCustomizeQueueOne
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    //使用NSInvocationOperation创建操作1
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperationTask) object:nil];
    // 使用 NSBlockOperation创建操作2
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@", [NSThread currentThread]);
    }];
    [op2 addExecutionBlock:^{
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@", [NSThread currentThread]);
    }];

    // 3.使用 addOperation: 添加所有操作到队列中
    [queue addOperation:op1]; // [op1 start]
    [queue addOperation:op2]; // [op2 start]
}

//创建自定义队列、不创建Operation、使用blocks
//结果:这里开启了子线程、并发执行
//添加到这种队列中的操作,就会自动放到子线程中执行(包含串行、并发功能)
- (void)testOperationCustomizeQueueTwo
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    //使用addOperationWithBlock:添加操作到队列中
    [queue addOperationWithBlock:^{
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@", [NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
            [NSThread sleepForTimeInterval:3];
            NSLog(@"2---%@", [NSThread currentThread]);
    }];
    [queue addOperationWithBlock:^{
            [NSThread sleepForTimeInterval:1];
            NSLog(@"3---%@", [NSThread currentThread]);
    }];
}

//参考网址:
//   1、NSOperation详细总结
//   http://www.cocoachina.com/ios/20180308/22503.html
//

//一、特性
//   1、可添加完成的代码块,在操作完成后执行
//   2、添加操作之间的依赖关系,方便的控制执行顺序
//   3、设定操作执行的优先级
//   4、可以很方便的取消一个操作的执行
//   5、使用KVO观察对操作执行状态的更改:isExecuteing、isFinished、isCancelled

//二、操作和队列的概念
//   1、操作(Operation)
//      执行操作的意思,换句话说就是你在线程中执行的那段代码
//      与GCD的不同点:
//      a、在GCD中是放在 block 中的.
//      b、在NSOperation中,我们使用NSOperation子类NSInvocationOperation、
//         NSBlockOperation,或者自定义子类来封装操作.
//
//   2、操作队列（Operation Queues）
//      这里的队列指操作队列,即用来存放操作的队列
//      与GCD的不同点:
//      a、不同于 GCD 中的调度队列 FIFO（先进先出）的原则.
//      b、NSOperationQueue对于添加到队列中的操作,首先进入准备就绪的状态（就绪状态取决于操作之间的依
//        赖关系）,然后进入就绪状态的操作的开始,执行顺序（非结束执行顺序）由操作之间相对的优先级决定（优先
//        级是操作对象自身的属性）
//
//    3、最大并发数
//       操作队列通过设置 最大并发操作数（maxConcurrentOperationCount） 来控制并发、串行
//       与GCD不同:
//       a、GCD通过信号量来设置
//
//    4、类型
//      NSOperationQueue 为我们提供了两种不同类型的队列:
//      a、主队列:在主线程上执行
//      b、自定义队列:自定义队列在后台执行
//
//    5、使用步骤
//      a、创建操作:先将需要执行的操作封装到一个 NSOperation 对象中
//      b、创建队列:创建 NSOperationQueue 对象
//      c、将操作加入到队列中：将 NSOperation 对象添加到 NSOperationQueue 对象中
//
//    6、创建操作
//       NSOperation 是个抽象类,不能用来封装操作.我们只有使用它的子类来封装操作.
//       我们有三种方式来封装操作:
//       a、使用子类 NSInvocationOperation  (Invocation:调用)
//       b、使用子类 NSBlockOperation
//       c、自定义继承自 NSOperation 的子类,通过实现内部相应的方法来封装操作
//       备注:在不使用 NSOperationQueue,单独使用 NSOperation 的情况下系统同步执行操作,










@end
