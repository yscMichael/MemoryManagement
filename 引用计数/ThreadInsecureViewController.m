//
//  ThreadInsecureViewController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "ThreadInsecureViewController.h"

@interface ThreadInsecureViewController ()

//火车票数目
@property (nonatomic ,assign) NSInteger ticketSurplusCount;
//加锁
@property (nonatomic ,strong) NSLock *lock;

@end

@implementation ThreadInsecureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //[self testThreadInsecure];
    [self testThreadSecurity];
}

//卖火车票场景
//场景:总共有50张火车票,有两个售卖火车票的窗口,一个是北京火车票售卖窗口,另一个是上海火车票售卖窗口.
//两个窗口同时售卖火车票,卖完为止.
//结果:二者同时访问一段代码,同时对一个变量进行操作,则可能会引发安全
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

//售卖火车票(非线程安全)
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

//售卖火车票(线程安全)
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



//总结:
//一、线程安全:
//   如果你的代码所在的进程中有多个线程在同时运行,而这些线程可能会同时运行这段代码.
//   如果每次运行结果和单线程运行的结果是一样的,而且其他的变量的值也和预期的是一样的,就是线程安全的.
//   若每个线程中对全局变量、静态变量只有读操作,而无写操作,一般来说,这个全局变量是线程安全的;
//   若有多个线程同时执行写操作(更改变量),一般都需要考虑线程同步,否则的话就可能影响线程安全

//二、线程安全解决方案:
//   可以给线程加锁，在一个线程执行该操作的时候，不允许其他线程进行操作。iOS 实现线程加锁有很多种方式.
//   @synchronized、 NSLock、NSRecursiveLock、NSCondition、NSConditionLock、
//   pthread_mutex、dispatch_semaphore、OSSpinLock、atomic(property) set/ge等等各种方式.
//   这里我们使用 NSLock 对象来解决线程同步问题.
//   NSLock对象可以通过进入锁时调用lock方法,解锁时调用 unlock 方法来保证线程安全.


@end


