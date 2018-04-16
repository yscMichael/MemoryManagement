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

//火车票数目
@property (nonatomic ,assign) NSInteger ticketSurplusCount;
//加锁
@property (nonatomic ,strong) NSLock *lock;

@end

@implementation NSOperationBasicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //1、NSInvocationOperation
    //[self testInvocationOperation];

    //2、NSBlockOperation单个任务
    //[self testBlockOperationOne];
    //NSBlockOperation多个任务
    //[self testBlockOperationMore];

    //3、自定义Operation
    //[self testCustomizeOperation];

    //4、创建主队列
    //[self testOperationMainQueueOne];
    //[self testOperationMainQueueTwo];

    //5、创建自定义队列
    //这里是并发队列,开启子线程
    //[self testOperationCustomizeQueueOne];
    //这里是并发队列,开启子线程
    //[self testOperationCustomizeQueueTwo];
    //这里尝试串行队列(也会开启子线程)和并发队列
    //[self testMaxConcurrentOperationCount];

    //6、依赖关系
    //[self testOperationDependency];

    //7、线程之间依赖关系
    //[self testOperationQueueCommunication];

    //8、线程非安全
    //[self testThreadInsecure];

    //9、线程安全
    [self testThreadSecurity];
}

//总结:
//一、为什么使用NSOperation、NSOperationQueue,国外使用较多.
//   1、先搞清两者的关系,NSOpertaionQueue用GCD构建封装的,是GCD的高级抽象!
//   2、FIFO队列,而NSOperationQueue中的队列可以被重新设置优先级,
//      从而实现不同操作的执行顺序调整.
//   3、GCD不支持异步操作之间的依赖关系设置.
//      如果某个操作的依赖另一个操作的数据(生产者-消费者模型是其中之一),
//      使用NSOperationQueue能够按照正确的顺序执行操作.GCD则没有内建的依赖关系支持.
//   4、NSOperationQueue支持KVO,意味着我们可以观察任务的执行状态.
//
//   性能上分析:
//   1、GCD更接近底层,而NSOperationQueue则更高级抽象.
//      所以GCD在追求性能的底层操作来说,是速度最快的.
//      这取决于使用Instruments进行代码性能分析,如有必要的话.
//   2、从异步操作之间的事务性,顺序性,依赖关系.
//      GCD需要自己写更多的代码来实现,而NSOperationQueue已经内建了这些支持
//   3、如果异步操作的过程需要更多的被交互和UI呈现出来,NSOperationQueue会是一个更好的选择.
//      底层代码中,任务之间不太互相依赖,而需要更高的并发能力,GCD则更有优势
//
//   总结:高级封装、FIFO和优先级、是否容易设置异步操作依赖、是否支持KVO
//
//  二、操作和队列
//    1、操作(Operation):执行操作的意思,换句话说就是你在线程中执行的那段代码.
//       GCD:放在 block 中的
//       NSOperation:NSInvocationOperation、NSBlockOperation、自定义Operation
//
//    2、队列(Operation Queues):
//      GCD:FIFO（先进先出）的原则
//      NSOperation:对于添加到队列中的操作;谁先准备好(还有优先级),谁就执行
//
//    3、并发和串行
//      GCD:声明并行队列,串行队列
//      NSOperation:通过设置最大并发操作数(maxConcurrentOperationCount)来控制并发、串行
//                 :提供两种不同的队列(主队列和自定义队列)
//    4、异步和同步
//       GCD:dispatch_async和dispatch_sync
//       NSOperation:主队列默认在主线程执行,自定义队列默认在后台执行(会开辟子线程)
//                  :是否异步或者同步由任务之间的依赖关系决定
//
//    5、资源限制
//      GCD:信号量
//      NSOperation:maxConcurrentOperationCount(也控制并发和串行)



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
//以上是NSOperationQueue并发执行

//NSOperationQueue的串行操作
//通过maxConcurrentOperationCount来实现
//结果:开辟新的子线程(因为队列数不一样,打印速度也不一样)
//注意:这里maxConcurrentOperationCount控制的不是并发线程的数量,而是一个队列中同时能并发执行的最大
//操作数.而且一个操作也并非只能在一个线程中运行
- (void)testMaxConcurrentOperationCount
{
    //1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    //2.设置最大并发操作数
    //queue.maxConcurrentOperationCount = 1; //串行队列(也开辟子线程了)
    //queue.maxConcurrentOperationCount = 2; //并发队列
    queue.maxConcurrentOperationCount = 8; //并发队列

    //3.添加操作
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i ++)
        {
            [NSThread sleepForTimeInterval:3];
            NSLog(@"1--%d--%@", i,[NSThread currentThread]);
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i ++)
        {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2--%d--%@", i,[NSThread currentThread]);
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i ++)
        {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"3--%d--%@", i,[NSThread currentThread]);
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i ++)
        {
            [NSThread sleepForTimeInterval:4];
            NSLog(@"4--%d--%@", i,[NSThread currentThread]);
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i ++)
        {
            [NSThread sleepForTimeInterval:3];
            NSLog(@"5--%d--%@", i,[NSThread currentThread]);
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i ++)
        {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"6--%d--%@", i,[NSThread currentThread]);
        }
    }];
}

//NSOperation 操作依赖
//场景:有A、B两个操作,其中A执行完操作,B才能执行操作
//结果:开辟新的子线程,不过op2先执行,后执行op1
- (void)testOperationDependency
{
    //1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //2.创建操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++)
        {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1--%d--%@", i,[NSThread currentThread]);
        }
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++)
        {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2--%d--%@", i,[NSThread currentThread]);
        }
    }];

    //3.添加依赖
    [op1 addDependency:op2]; //让op2依赖于op1,则先执行op1,在执行op2

    //4.添加操作到队列中
    [queue addOperation:op1];
    [queue addOperation:op2];
}

//NSOperation 优先级
//NSOperation 提供了queuePriority（优先级）属性
//queuePriority属性适用于同一操作队列中的操作，不适用于不同操作队列中的操作
//* queuePriority 属性决定了进入准备就绪状态下的操作之间的开始执行顺序。并且，优先级不能取代依赖关系


//线程之间进行通信
- (void)testOperationQueueCommunication
{
    //1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];

    //2.添加操作
    [queue addOperationWithBlock:^{
        //异步进行耗时操作
        for (int i = 0; i < 2; i++)
        {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1--%d--%@", i,[NSThread currentThread]);
        }

        //回到主线程
        //这里稍后执行
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // 进行一些UI、刷新等操作
            for (int i = 0; i < 2; i++)
            {
                [NSThread sleepForTimeInterval:2];
                NSLog(@"2--%d--%@", i,[NSThread currentThread]);
            }
        }];

        NSLog(@"hello world");
    }];
}

//线程同步和线程安全
//线程安全：如果你的代码所在的进程中有多个线程在同时运行，而这些线程可能会同时运行这段代码。如果每次运行结果和单线程运行的结果是一样的，而且其他的变量的值也和预期的是一样的，就是线程安全的。 若每个线程中对全局变量、静态变量只有读操作，而无写操作，一般来说，这个全局变量是线程安全的；若有多个线程同时执行写操作（更改变量），一般都需要考虑线程同步，否则的话就可能影响线程安全。
//
//线程同步：可理解为线程 A 和 线程 B 一块配合，A 执行到一定程度时要依靠线程 B 的某个结果，于是停下来，示意 B 运行；B 依言执行，再将结果给 A；A 再继续操作。
//
//
// 场景:下面，我们模拟火车票售卖的方式，实现 NSOperation 线程安全和解决线程同步问题。 场景：总共有50张火车票，有两个售卖火车票的窗口，一个是北京火车票售卖窗口，另一个是上海火车票售卖窗口。两个窗口同时售卖火车票，卖完为止。
//
//
//

//测试线程非安全
- (void)testThreadInsecure
{
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    self.ticketSurplusCount = 50;

    //1.创建 queue1
    //queue1 代表北京火车票售卖窗口
    NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
    queue1.maxConcurrentOperationCount = 1;

    //2.创建 queue2
    //queue2 代表上海火车票售卖窗口
    NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];
    queue2.maxConcurrentOperationCount = 1;

    //3.创建卖票操作 op1
    __weak typeof(self) weakSelf = self;
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf saleTicketNotSafe];
    }];

    //4.创建卖票操作 op2
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf saleTicketNotSafe];
    }];

    //5.添加操作，开始卖票
    [queue1 addOperation:op1];
    [queue2 addOperation:op2];
}

/**
 * 售卖火车票(非线程安全)
 */
- (void)saleTicketNotSafe
{
    while (1)
    {
        if (self.ticketSurplusCount > 0)
        {
            //如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数:%ld 窗口:%@", (long)self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        }
        else
        {
            NSLog(@"所有火车票均已售完");
            break;
        }
    }
}

//线程安全解决方案：可以给线程加锁，在一个线程执行该操作的时候，不允许其他线程进行操作。iOS 实现线程加锁有很多种方式。@synchronized、 NSLock、NSRecursiveLock、NSCondition、NSConditionLock、pthread_mutex、dispatch_semaphore、OSSpinLock、atomic(property) set/ge等等各种方式。这里我们使用 NSLock 对象来解决线程同步问题。NSLock 对象可以通过进入锁时调用 lock 方法，解锁时调用 unlock 方法来保证线程安全。

//测试线程安全
- (void)testThreadSecurity
{
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    self.ticketSurplusCount = 50;

    self.lock = [[NSLock alloc] init];//初始化 NSLock 对象

    //1.创建queue1
    //queue1 代表北京火车票售卖窗口
    NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
    queue1.maxConcurrentOperationCount = 1;

    //2.创建queue2
    //queue2 代表上海火车票售卖窗口
    NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];
    queue2.maxConcurrentOperationCount = 1;

    //3.创建卖票操作 op1
    __weak typeof(self) weakSelf = self;
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf saleTicketSafe];
    }];

    //4.创建卖票操作 op2
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf saleTicketSafe];
    }];

    //5.添加操作，开始卖票
    [queue1 addOperation:op1];
    [queue2 addOperation:op2];
}

/**
 * 售卖火车票(线程安全)
 */
- (void)saleTicketSafe
{
    while (1)
    {
        //加锁
        [self.lock lock];

        if (self.ticketSurplusCount > 0)
        {
            //如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数:%ld 窗口:%@", (long)self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        }

        //解锁
        [self.lock unlock];

        if (self.ticketSurplusCount <= 0)
        {
            NSLog(@"所有火车票均已售完");
            break;
        }
    }
}

//常用属性
//1、NSOperation常用属性
//取消操作方法
//
//- (void)cancel; 可取消操作，实质是标记 isCancelled 状态。
//
//判断操作状态方法
//
//- (BOOL)isFinished; 判断操作是否已经结束。
//
//- (BOOL)isCancelled; 判断操作是否已经标记为取消。
//
//- (BOOL)isExecuting; 判断操作是否正在在运行。
//
//- (BOOL)isReady; 判断操作是否处于准备就绪状态，这个值和操作的依赖关系相关。
//
//操作同步
//
//- (void)waitUntilFinished; 阻塞当前线程，直到该操作结束。可用于线程执行顺序的同步。
//
//- (void)setCompletionBlock:(void (^)(void))block; completionBlock 会在当前操作执行完毕时执行 completionBlock。
//
//- (void)addDependency:(NSOperation *)op; 添加依赖，使当前操作依赖于操作 op 的完成。
//
//- (void)removeDependency:(NSOperation *)op; 移除依赖，取消当前操作对操作 op 的依赖。
//
//@property (readonly, copy) NSArray *dependencies; 在当前操作开始执行之前完成执行的所有操作对象数组。
//
//2、NSOperationQueue 常用属性和方法
//
//取消/暂停/恢复操作
//
//- (void)cancelAllOperations; 可以取消队列的所有操作。
//
//- (BOOL)isSuspended; 判断队列是否处于暂停状态。 YES 为暂停状态，NO 为恢复状态。
//
//- (void)setSuspended:(BOOL)b; 可设置操作的暂停和恢复，YES 代表暂停队列，NO 代表恢复队列。
//
//操作同步
//
//- (void)waitUntilAllOperationsAreFinished; 阻塞当前线程，直到队列中的操作全部执行完毕。
//
//添加/获取操作`
//
//- (void)addOperationWithBlock:(void (^)(void))block; 向队列中添加一个 NSBlockOperation 类型操作对象。
//
//- (void)addOperations:(NSArray *)ops waitUntilFinished:(BOOL)wait; 向队列中添加操作数组，wait 标志是否阻塞当前线程直到所有操作结束
//
//- (NSArray *)operations; 当前在队列中的操作数组（某个操作执行结束后会自动从这个数组清除）。
//
//- (NSUInteger)operationCount; 当前队列中的操作数。
//
//获取队列
//
//+ (id)currentQueue; 获取当前队列，如果当前线程不是在 NSOperationQueue 上运行则返回 nil。
//
//+ (id)mainQueue; 获取主队列。
//

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
