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

//    dispatch_semaphore_t
}

- (void)testOne
{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);

    //1、
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);

    NSMutableArray *array = [NSMutableArray array];

    for (int index = 0; index < 100000; index++) {

        dispatch_async(queue, ^(){

            //2、
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//

            NSLog(@"addd :%d", index);

            [array addObject:[NSNumber numberWithInt:index]];

            //3、
            dispatch_semaphore_signal(semaphore);

        });

    }
}

- (void)testTwo
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 100; i++)
    {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, queue, ^{
            NSLog(@"%i",i);
            sleep(2);
            dispatch_semaphore_signal(semaphore);
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

//简单的介绍一下这一段代码，创建了一个初使值为10的semaphore，每一次for循环都会创建一个新的线程，线程结束的时候会发送一个信号，线程创建之前会信号等待，所以当同时创建了10个线程之后，for循环就会阻塞，等待有线程结束之后会增加一个信号才继续执行，如此就形成了对并发的控制，如上就是一个并发数为10的一个线程队列。



//当我们在处理一系列线程的时候，当数量达到一定量，在以前我们可能会选择使用NSOperationQueue来处理并发控制

//dispatch_semaphore_create　　　创建一个semaphore
//　　dispatch_semaphore_signal　　　发送一个信号
//　　dispatch_semaphore_wait　　　　等待信号

//简单的介绍一下这三个函数，第一个函数有一个整形的参数，我们可以理解为信号的总量，dispatch_semaphore_signal是发送一个信号，自然会让信号总量加1，dispatch_semaphore_wait等待信号，当信号总量少于0的时候就会一直等待，否则就可以正常的执行，并让信号总量-1，根据这样的原理，我们便可以快速的创建一个并发控制来同步任务和有限资源访问控制。




//dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); 如果semaphore计数大于等于1.计数－1，返回，程序继续运行。如果计数为0，则等待。这里设置的等待时间是一直等待。dispatch_semaphore_signal(semaphore);计数＋1.在这两句代码中间的执行代码，每次只会允许一个线程进入，这样就有效的保证了在多线程环境下，只能有一个线程进入。


//应用场景:
//1、假设现在系统有两个空闲资源可以被利用，但同一时间却有三个线程要进行访问，这种情况下，该如何处理呢？
//2、我们要下载很多图片，并发异步进行，每个下载都会开辟一个新线程，可是我们又担心太多线程肯定cpu吃不消，那么我们这里也可以用信号量控制一下最大开辟线程数。

//参考网址:
//1、http://www.ruanyifeng.com/blog/2013/04/processes_and_threads.html


@end

