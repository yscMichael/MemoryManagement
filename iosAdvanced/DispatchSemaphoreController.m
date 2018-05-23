//
//  DispatchSemaphoreController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/11.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "DispatchSemaphoreController.h"

@interface DispatchSemaphoreController ()

@end

@implementation DispatchSemaphoreController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //内存错误例子
    //[self normalExample];
    //在主线程上面测试信号量
    //[self testSemaphoreOnMainThread];
    //单个信号量测试
    //[self testSemaphoreOne];
    //多个信号量测试
    [self testSemaphoreTwo];
}

//普通例子
//可能由于内存错误,导致程序异常结束
- (void)normalExample
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSMutableArray *array = [[NSMutableArray alloc] init];

    for (int i = 0; i < 100000; i ++)
    {
        //开辟多个子线程,抢夺一个资源
        //如果不使用默认在主线程,主队列进行,不会抢夺资源
        dispatch_async(queue, ^{
            [array addObject:[NSNumber numberWithInt:i]];
        });
    }
}

//在主线程上面测试信号量
//提醒:在主线程设置信号量会崩溃(就一个主线程,被占用了,无意义;主要是针对并发)
- (void)testSemaphoreOnMainThread
{
    //最大并发数为1
    dispatch_semaphore_t  semaphore = dispatch_semaphore_create(1);
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 3ull * NSEC_PER_SEC);

    long  result = dispatch_semaphore_wait(semaphore, time);
    if (result == 0)
    {//在指定时间内,发现Dispatch Semaphore的计数值大于等于1,返回结果0;接下来执行减1操作
        NSLog(@"Dispatch Semaphore的计数值>=>=>=1");
    }
    else
    {
        NSLog(@"Dispatch Semaphore的计数值=====0");
    }
}

//信号量初步测试
//注意这里虽然设置最大并发数为1,并不代表着每次使用同一个子线程.
//证据:这里里面向数组添加对象,是按照顺序添加的
//dispatch_semaphore_wait注意防止位置
- (void)testSemaphoreOne
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //最大并发数为1
    dispatch_semaphore_t  semaphore = dispatch_semaphore_create(1);
    NSMutableArray *array = [[NSMutableArray alloc] init];

    for (int index = 0; index < 200 ; index ++)
    {
        //异步线程
        //一直等待不为0,然后减一,通过;相当于是房间门上的钥匙
        //既保护了资源,也防止开辟多个线程
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(queue, ^{

            //不宜放在这里,这里会开辟多个线程,虽然保护了资源,但是开辟了多个线程
            //dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"addd :%d", index);
            NSLog(@"%@",[NSThread currentThread]);
            //进入线程操作
            [array addObject:[NSNumber numberWithInt:index]];

            //归还钥匙,让其它人使用
            dispatch_semaphore_signal(semaphore);
        });
    }
}

//验证多个信号量效果
//大数据处理也有点阻塞
- (void)testSemaphoreTwo
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(5);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    for (int i = 0; i < 50; i++)
    {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, queue, ^{
            NSLog(@"%i + %@ = ",i,[NSThread currentThread]);
            sleep(2);
            dispatch_semaphore_signal(semaphore);
        });
    }

    //dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_group_notify(group, queue, ^{
        NSLog(@"请求完成");
    });
}

//简单的介绍一下这一段代码，创建了一个初使值为5的semaphore，每一次for循环都会创建一个新的线程，线程结束的时候会发送一个信号，线程创建之前会信号等待，所以当同时创建了5个线程之后，for循环就会阻塞，等待有线程结束之后会增加一个信号才继续执行，如此就形成了对并发的控制，如上就是一个并发数为5的一个线程队列。
//
//
//一、应用场景:
//   1、假设现在系统有两个空闲资源可以被利用,但同一时间却有三个线程要进行访问,这种情况下,该如何处理呢？
//   2、我们要下载很多图片,并发异步进行,每个下载都会开辟一个新线程,可是我们又担心太多线程肯定cpu吃不消,那么我们这里也可以用信号量控制一下最大开辟线程数
//
//二、总结:
//  dispatch_semaphore_create:创建一个semaphore
//                           :(这里用于设置信号总数,也就是最大并发数)
//　dispatch_semaphore_signal:发送一个信号
//                           :(信号量加1,相当于是归还钥匙,释放资源让别人使用)
//　dispatch_semaphore_wait:等待信号
//                         :(内部自动检测,一旦发现信号总数不为0(大于等于1),自动减1,向下执行程序;否则卡着不动)
// 详细使用过程如下:
// dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
// :如果semaphore计数大于等于1,计数－1,返回,程序继续运行.如果计数为0,则等待.这里设置的等待时间是一直等待.
// dispatch_semaphore_signal(semaphore);
// :计数＋1.
// :在这两句代码中间的执行代码,每次只会允许一个线程进入,这样就有效的保证了在多线程环境下,只能有一个线程进入.
//
//三、参考网址:
//   1、http://www.ruanyifeng.com/blog/2013/04/processes_and_threads.html


@end

