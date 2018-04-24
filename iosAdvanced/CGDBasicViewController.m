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

    //1、这里是单一的串行和并行队列、异步和同步

    //串行队列+异步
    //[self serialQueueAsyncStudy];
    //串行队列+同步
    //[self serialQueueSyncStudy];
    //并发队列+异步
    //[self concurrentQueueAsyncStudy];
    //并发队列+同步
    //[self concurrentQueueSyncStudy];

    //2、复杂化的队列和异步

    //串行队列中混有同步和异步任务、任务之间不相互嵌套
    //[self serialQueueAsyncAndSync];
    //并行队列中混有同步和异步任务、任务之间不相互嵌套
    //[self concurrentQueueAsyncAndSync];

    //3、进一步复杂化队列和任务

    //串行队列中混有同步任务和异步任务、任务之间相互嵌套
    //[self serialQueueAsyncAndSyncNesting];
    //并行队列中混有同步和异步任务、任务之间相互嵌套
    //[self concurrentQueueAsyncAndSyncNesting];

    //4、主队列<串行队列>研究

    //主队列+异步
    //[self MainQueueAsyncStudy];
    //主队列+同步--这里会崩溃
    //[self MainQueueSyncStudy];

    //5、全局队列<并发队列>研究

    //全局队列+异步+同步任务,任务之间嵌套
    //[self GlobalQueueAsyncStudy];
}

//串行队列+异步
//分析:串行队列:让任务一个个执行
//    异步执行:会开辟子线程(CPU允许开辟子线程,发现你是串行队列,因此给你1条就行了)
//    这里的子线程是随机给的!!!
//结果:任务在新开的子线程中一个个执行(前面结束了,才会让另一个任务执行)
- (void)serialQueueAsyncStudy
{
    dispatch_queue_t queue = dispatch_queue_create("com.example.gcd.MySerialQueue", DISPATCH_QUEUE_SERIAL);

    //创建多个任务
    void (^task0)() = ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"我是任务0");
        NSLog(@"%@",[NSThread currentThread]);
    };
    void (^task1)() = ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"我是任务1");
        NSLog(@"%@",[NSThread currentThread]);
    };
    void (^task2)() = ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"我是任务2");
        NSLog(@"%@",[NSThread currentThread]);
    };

    //将任务添加到串行队列
    //异步执行
    //这里不会阻断主线程,因为开辟了新的线程
    //不过因为是串行队列,任务还是有执行顺序的
    dispatch_async(queue, task0);
    dispatch_async(queue, task1);
    dispatch_async(queue, task2);
}

//串行队列+同步
//分析:串行队列:让任务一个个执行
//    同步执行:不会开辟子线程(CPU不允许开线程)
//    这里就在主线程执行
//结果:任务在主线程中一个个执行(前面结束了,才会让另一个任务执行)
- (void)serialQueueSyncStudy
{
    dispatch_queue_t queue = dispatch_queue_create("com.example.gcd.MySerialQueue", DISPATCH_QUEUE_SERIAL);

    //创建多个任务
    void (^task0)() = ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"我是任务0");
        NSLog(@"%@",[NSThread currentThread]);
    };
    void (^task1)() = ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"我是任务1");
        NSLog(@"%@",[NSThread currentThread]);
    };
    void (^task2)() = ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"我是任务2");
        NSLog(@"%@",[NSThread currentThread]);
    };

    //将任务添加到串行队列
    //同步执行
    dispatch_sync(queue, task0);//阻断主线程,一个个执行
    dispatch_sync(queue, task1);
    dispatch_sync(queue, task2);
}

//并发队列+异步
//分析:并发队列:可以让多个任务并发（同时）执行
//    异步执行:会开辟新的子线程(CPU看你是并发队列,会多开一些子线程给你)
//    这里的子线程名称和数目是随机给的!!!
//结果:任务被分配不同线程执行,执行顺序是不可控的(各个任务执行顺序不受辖制)
- (void)concurrentQueueAsyncStudy
{
    dispatch_queue_t queue = dispatch_queue_create("com.example.gcd.MySerialQueue", DISPATCH_QUEUE_CONCURRENT);

    //创建多个任务
    void (^task0)() = ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"我是任务0");
        NSLog(@"%@",[NSThread currentThread]);
    };
    void (^task1)() = ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"我是任务1");
        NSLog(@"%@",[NSThread currentThread]);
    };
    void (^task2)() = ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"我是任务2");
        NSLog(@"%@",[NSThread currentThread]);
    };

    //将任务添加到并发队列
    //异步执行
    //这里不会截断主线程,不会会造成卡顿现象
    dispatch_async(queue, task0);
    dispatch_async(queue, task1);
    dispatch_async(queue, task2);
}

//并发队列+同步
//分析:并发队列:可以让多个任务并发（同时）执行
//    同步执行:不会开辟子线程
//    这里默认是主线程(任你队列可以让任务同时执行,但是开发者就给你一条路,无路可选,只能乖乖在主线程执行.根据FIFO原则,结果肯定是任务在主线程一个个按顺序执行)
//结果:任务在主线程一个个按顺序执行(虽然各个任务之间有没有顺序要求)
- (void)concurrentQueueSyncStudy
{
    dispatch_queue_t queue = dispatch_queue_create("com.example.gcd.MySerialQueue", DISPATCH_QUEUE_CONCURRENT);

    //创建多个任务
    void (^task0)() = ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"我是任务0");
        NSLog(@"%@",[NSThread currentThread]);
    };
    void (^task1)() = ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"我是任务1");
        NSLog(@"%@",[NSThread currentThread]);
    };
    void (^task2)() = ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"我是任务2");
        NSLog(@"%@",[NSThread currentThread]);
    };

    //将任务添加到并发队列
    //同步执行
    //因为当前截断的是主线程,会造成卡顿现象
    dispatch_sync(queue, task0);//阻断程序执行,必须执行完block,就算任务之间没有辖制
    dispatch_sync(queue, task1);
    dispatch_sync(queue, task2);
}

//串行队列+同步+异步(任务之间不相互嵌套)
//结果:不管怎样,任务都是按照顺序执行(可能工作的线程不同)
- (void)serialQueueAsyncAndSync
{
    dispatch_queue_t queue = dispatch_queue_create("com.example.gcd.MySerialQueue", DISPATCH_QUEUE_SERIAL);

    //创建多个任务
    void (^task0)() = ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"我是任务0");
        NSLog(@"%@",[NSThread currentThread]);
    };
    void (^task1)() = ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"我是任务1");
        NSLog(@"%@",[NSThread currentThread]);
    };
    void (^task2)() = ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"我是任务2");
        NSLog(@"%@",[NSThread currentThread]);
    };

    //将任务添加到串行队列
    //异步+异步+同步
    dispatch_async(queue, task0);//会开辟新的线程
    dispatch_async(queue, task1);//会开辟新的线程、等待上面执行完毕
    dispatch_sync(queue, task2);//阻断当前的主线程
}

//并行队列+同步+异步(任务之间不相互嵌套)
//结果:task0先执行,后面的不确定
- (void)concurrentQueueAsyncAndSync
{
    dispatch_queue_t queue = dispatch_queue_create("com.example.gcd.MySerialQueue", DISPATCH_QUEUE_CONCURRENT);

    //创建多个任务
    void (^task0)() = ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"我是任务0");
        NSLog(@"%@",[NSThread currentThread]);
    };
    void (^task1)() = ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"我是任务1");
        NSLog(@"%@",[NSThread currentThread]);
    };
    void (^task2)() = ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"我是任务2");
        NSLog(@"%@",[NSThread currentThread]);
    };

    //将任务添加到并发队列
    //同步+异步+异步执行
    dispatch_sync(queue, task0);//这里会阻断一下
    dispatch_async(queue, task1);
    dispatch_async(queue, task2);
}

//串行队列中混有同步任务和异步任务、任务之间相互嵌套
//结果:按照顺序打印,不可能越轨的
//总结:
//1、串行队列里面唯一要防止的是崩溃,造成的死锁
//2、死锁原因就是你在别人的任务里,如果别人要执行(必须要执行完毕,串行队列),这个时候你在人家里面必须要执行
//   人家必须要要执行,而且要执行完毕,才能执行下一个任务;此时你要求必须执行你的,就会造成死锁
//3、例子：串行队列任务中出现的任务以dispatch_sync方式要执行---死锁
- (void)serialQueueAsyncAndSyncNesting
{
    dispatch_queue_t queue = dispatch_queue_create("com.example.gcd.MySerialQueue", DISPATCH_QUEUE_SERIAL);

    //将任务添加到串行队列
    dispatch_async(queue, ^{//任务0
        [NSThread sleepForTimeInterval:3];
        NSLog(@"我是任务0");
        NSLog(@"%@",[NSThread currentThread]);

        //code1:会造成死锁,只会执行"我是任务0",然后卡死,"我是任务2"也不会执行
        //因为死锁,任务1都没有执行完(串行队列),后面的别想执行

        //任务1也是任务0的一部分
        //dispatch_sync(queue, ^{//任务1
        //    [NSThread sleepForTimeInterval:4];
        //    NSLog(@"我是任务1");
        //    NSLog(@"%@",[NSThread currentThread]);
        //});//任务1


        //code2:不会造成死锁,执行"我是任务0",但是后面先执行"我是任务2",后执行"我是任务1"
        //异步特性:可以先绕过去,回来再执行
        //      :这里为了完成"我是任务0",先把"我是任务1"绕过去
        //      :最终造成"我是任务2"在串行队列的第二个位置,先被执行<可能是编译器优化结果,可以理解为级别不够,属于第二梯队>
        //线程:这里同样是开辟了一个新的子线程,按照顺序执行

        //任务1也是任务0的一部分
        dispatch_async(queue, ^{//任务1
            [NSThread sleepForTimeInterval:1];
            NSLog(@"我是任务1");
            NSLog(@"%@",[NSThread currentThread]);
        });//任务1

    });//任务0

    //任务2
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"我是任务2");
        NSLog(@"%@",[NSThread currentThread]);
    });
}

//并行队列中混有同步和异步任务、任务之间相互嵌套
//结果如下分析:
- (void)concurrentQueueAsyncAndSyncNesting
{
    dispatch_queue_t queue = dispatch_queue_create("com.example.gcd.MySerialQueue", DISPATCH_QUEUE_CONCURRENT);

    //将任务添加到并发队列
    dispatch_async(queue, ^{//任务0
        [NSThread sleepForTimeInterval:3];
        NSLog(@"我是任务0");
        NSLog(@"%@",[NSThread currentThread]);

        //code1:这里不会造成死锁,"我是任务0"一定比"我是任务1"先执行,"我是任务2"就不好说了
        //这个看每个哪个任务的耗时操作多.默认第一梯队先执行

        //任务1也是任务0的一部分
        //dispatch_async(queue, ^{//任务1
        //    [NSThread sleepForTimeInterval:2];
        //    NSLog(@"我是任务1");
        //    NSLog(@"%@",[NSThread currentThread]);
        //});//任务1


        //code2:这里即使在里面加入了同步,也不会造成死锁,相互任务之间没有前后顺序,随便阻塞
        //这里阻塞的是当前子线程
        //这里"我是任务2"的执行顺序可能在第一梯队,因为耗时操作原因,不确定

        //任务1也是任务0的一部分
        dispatch_sync(queue, ^{//任务1
            [NSThread sleepForTimeInterval:2];
            NSLog(@"我是任务1");
            NSLog(@"%@",[NSThread currentThread]);
        });//任务1
        NSLog(@"我是任务4");
    });//任务0

    //任务2
    //这里不管用sync还是async都不会出问题,因为上面代码和它走的不是一条路
    //用sync会阻塞主线程!!!
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:10];
        NSLog(@"我是任务2");
        NSLog(@"%@",[NSThread currentThread]);
    });
}

//主队列+异步
//分析: 主队列:主线程中的队列,肯定也是串行队列,任务顺序执行
//     异步:会开辟子线程
//     因为主队列是串行队列,所以任务一定是一个个执行.异步虽然会开辟子线程,但是看你是主队列,身份特殊这里还是在主线程中,也就是并不会开辟新的子线程
//结果:任务按照顺讯一个个在主线程执行,相当于是异步没有起作用,但是这里不卡顿
//   :跟串行队列最大区别是不开辟新的线程
- (void)MainQueueAsyncStudy
{
    dispatch_queue_t queue = dispatch_get_main_queue();

    //创建多个任务
    void (^task0)() = ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"我是任务0");
        NSLog(@"%@",[NSThread currentThread]);
    };
    void (^task1)() = ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"我是任务1");
        NSLog(@"%@",[NSThread currentThread]);
    };
    void (^task2)() = ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"我是任务2");
        NSLog(@"%@",[NSThread currentThread]);
    };

    //将任务添加到主队列
    //异步执行
    dispatch_async(queue, task0);
    dispatch_async(queue, task1);
    dispatch_async(queue, task2);
}

//主队列+同步
//分析: 主队列:主线程中的队列,肯定也是串行队列,任务顺序执行
//     同步:不会开辟子线程
//
//结果:这里会崩溃
//原因:1、类似于串行队列死锁原因:串行队列任务中出现的任务以dispatch_sync方式要执行---死锁
//   :2、当前程序就是在主线程中主队列(串行队列)中运行,此时在主队列中添加同步任务,肯定会造成死锁
- (void)MainQueueSyncStudy
{
    dispatch_queue_t queue = dispatch_get_main_queue();

    //创建多个任务
    void (^task0)() = ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"我是任务0");
        NSLog(@"%@",[NSThread currentThread]);
    };
    void (^task1)() = ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"我是任务1");
        NSLog(@"%@",[NSThread currentThread]);
    };
    void (^task2)() = ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"我是任务2");
        NSLog(@"%@",[NSThread currentThread]);
    };

    dispatch_sync(queue, task0);
    dispatch_sync(queue, task1);
    dispatch_sync(queue, task2);
}

//全局队列+异步
//结果:同并发队列一致
- (void)GlobalQueueAsyncStudy
{
    //第一个参数是值得优先级,使用默认的
    //第二个参数是标识位,使用默认的
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);

    //将任务添加到并发队列
    dispatch_async(queue, ^{//任务0
        [NSThread sleepForTimeInterval:3];
        NSLog(@"我是任务0");
        NSLog(@"%@",[NSThread currentThread]);

        //任务1也是任务0的一部分
        //dispatch_async(queue, ^{//任务1
        //    [NSThread sleepForTimeInterval:2];
        //    NSLog(@"我是任务1");
        //    NSLog(@"%@",[NSThread currentThread]);
        //});//任务1

        //任务1也是任务0的一部分
        dispatch_sync(queue, ^{//任务1
            [NSThread sleepForTimeInterval:2];
            NSLog(@"我是任务1");
            NSLog(@"%@",[NSThread currentThread]);
        });//任务1

        NSLog(@"我是任务4");
    });//任务0

    //任务2
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:10];
        NSLog(@"我是任务2");
        NSLog(@"%@",[NSThread currentThread]);
    });
}

//全局队列+同步
- (void)GlobalQueueSyncStudy
{

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
//   2、队列:用来存放任务<这里粗暴定义一下:类似于一种运输工具,规定了里面的乘客(任务),是同时下车还是按照顺序下车,是对任务的一种封装>

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
//       主队列<串行队列>:dispatch_get_main_queue()
//       全局队列<并发队列>:

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
//        :异步添加进任务队列
//        :它不会做任何等待
//
//     b、同步
//        dispatch_sync(队列,block)
//        :同步添加操作
//        :它是等待添加进队列里面的操作完成之后再继续执行
//        :说白了执行这个操作会阻断当前线程,直到自己的Block被执行了,才允许向下执行


//总结:
//1、串行队列和并发队列注意点
//   a、串行队列里面的任务一定按照顺序执行完毕
//   b、并发队列无顺序要求
//   c、串行队列里面有异步和同步任务时,注意任务的嵌套会造成死锁
//      例子:串行队列任务中出现的任务以dispatch_sync方式要执行---死锁
//   d、并发队列一般不会死锁
//   e、默认情况下,第一梯队先执行,但是也要看耗时操作
//   f、主队列里面的任务一定是按照顺序在主线程中一个个执行,不管异步还是同步
//   g、在主队列中使用dispatch_sync,一定会崩溃


//额外知识补充:
//一、NSThread编程

//二、NSObject分类:
//   a、performSelectorOnMainThread
//   b、performSelector
//   c、performSelectorInBackground

@end



