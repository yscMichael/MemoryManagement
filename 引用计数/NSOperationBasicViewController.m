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
//      GCD:声明并发队列,串行队列
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
//
//    6、使用步骤
//       a、创建操作:先将需要执行的操作封装到一个 NSOperation 对象中
//       b、创建队列:创建 NSOperationQueue 对象
//       c、将操作加入到队列中:将 NSOperation 对象添加到 NSOperationQueue 对象中
//       d、系统就会自动将 NSOperationQueue 中的 NSOperation 取出来，在新线程中执行操作
//       备注:
//       NSOperation单独使用时系统同步执行操作;配合NSOperationQueue我们能更好的实现异步执行


@end
