//
//  NSTimerRunLoopController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/4/30.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "NSTimerRunLoopController.h"

@interface NSTimerRunLoopController ()

@property (nonatomic , assign) NSInteger count;
@property (nonatomic , strong) NSThread *subThread;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation NSTimerRunLoopController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //定时器会受到影响
    //[self testOne];
    //[self testTwo];

    //定时器不会受到影响
    //[self solveOne];
    [self solveTwo];
}

- (void)testOne
{
    //第一种写法
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [timer fire];//立马开启
}

- (void)testTwo
{
    //第二种写法
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
    //这里默认时添加在defaultMode,所以不重新添加了
    [timer fire];//立马开启
}

//解决滑动tableView时,timerUpdate不会调用
//改变Runloop的Model
- (void)solveOne
{
    //第一种写法
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];//立马开启
}

//让二者不在同一个线程
//这里考察runloop与多线程关系
//这就是多线程与runloop的关系了,每一个线程都有一个与之关联的RunLoop,
//而每一个RunLoop可能会有多个Mode.CPU会在多个线程间切换来执行任务,呈现出多个线程同时执行的效果.
//执行的任务其实就是RunLoop去各个Mode里执行各个item.因为RunLoop是独立的两个,相互不会影响,所以在子线程添加timer,滑动视图时,timer能正常运行

- (void)solveTwo
{
    [self createThread];
}

//首先是创建一个子线程
- (void)createThread
{
    NSThread *subThread = [[NSThread alloc] initWithTarget:self selector:@selector(timerTest) object:nil];
    [subThread start];
    self.subThread = subThread;
}

//创建timer,并添加到runloop的mode中
- (void)timerTest
{
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    NSLog(@"启动RunLoop前--%@",runLoop.currentMode);
    NSLog(@"currentRunLoop:%@",[NSRunLoop currentRunLoop]);
    // 第一种写法
    //    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    //    [timer fire];

    // 第二种写法
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
    [timer fire];

    //必须让当前的runloop执行,否则timer仅执行一次
    [[NSRunLoop currentRunLoop] run];
}

- (void)timerUpdate
{
    NSLog(@"当前线程：%@",[NSThread currentThread]);
    NSLog(@"启动RunLoop后--%@",[NSRunLoop currentRunLoop].currentMode);
    //NSLog(@"currentRunLoop:%@",[NSRunLoop currentRunLoop]);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.count ++;
        NSString *timerText = [NSString stringWithFormat:@"计时器:%ld",self.count];
        self.textLabel.text = timerText;
    });
}

//一、场景:
// 1.我们经常会在应用中看到tableView的header上是一个横向ScrollView,一般我们使用NSTimer,每隔几秒切换一张图片.可是当我们滑动tableView的时候,顶部的scollView并不会切换图片,这可怎么办呢?
//2.界面上除了有tableView,还有显示倒计时的Label,当我们在滑动tableView时,倒计时就停止了,这又该怎么办呢?
//
//二、滑动tableView时,timerUpdate不会调用
//原因:
//是当我们滑动scrollView时,主线程的RunLoop会切换到UITrackingRunLoopMode这个Mode,执行的也是UITrackingRunLoopMode下的任务(Mode中的item);
//而timer是添加在NSDefaultRunLoopMode下的,所以timer任务并不会执行,只有当UITrackingRunLoopMode的任务执行完毕,runloop切换到NSDefaultRunLoopMode后,才会继续执行timer
//
//三、Model
//1. NSDefaultRunLoopMode:App的默认Mode,通常主线程是在这个Mode下运行的
//2. UITrackingRunLoopMode:界面跟踪 Mode,用于ScrollView追踪触摸滑动,保证界面滑动时不受其他Mode影响
//3: NSRunLoopCommonModes:这是一个占位的Mode,没有实际作用
//
//
//
//
//总结:
//1、
//1、从控制台输出可以看出，timer确实被添加到NSDefaultRunLoopMode中了。可是添加到子线程中的NSDefaultRunLoopMode里，无论如何滚动，timer都能够很正常的运转。这又是为啥呢？


//

@end

