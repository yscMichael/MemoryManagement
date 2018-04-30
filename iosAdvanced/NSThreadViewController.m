//
//  NSThreadViewController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/4/30.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "NSThreadViewController.h"
#import "HLThread.h"

@interface NSThreadViewController ()

@property (nonatomic , strong) HLThread *subThread;

@end

@implementation NSThreadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //1.测试线程的销毁
    [self threadTest];
}

//改进代码
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(subThreadOpetion) onThread:self.subThread withObject:nil waitUntilDone:NO];
}

- (void)threadTest
{
    HLThread *subThread = [[HLThread alloc] initWithTarget:self selector:@selector(subThreadEntryPoint) object:nil];
    [subThread setName:@"HLThread"];
    [subThread start];
    self.subThread = subThread;
}

//子线程启动后，启动runloop
- (void)subThreadEntryPoint
{
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    //NSLog(@"添加任务前runloop = %@",runLoop);
    //如果注释了下面这一行，子线程中的任务并不能正常执行
    [runLoop addPort:[NSMachPort port] forMode:NSRunLoopCommonModes];
    //NSLog(@"添加任务后runloop = %@",runLoop);
    NSLog(@"启动RunLoop前Model--%@",runLoop.currentMode);
    [runLoop run];
}

//子线程任务
- (void)subThreadOpetion
{
    NSLog(@"启动RunLoop后Model--%@",[NSRunLoop currentRunLoop].currentMode);
    NSLog(@"%@----子线程任务开始",[NSThread currentThread]);
    [NSThread sleepForTimeInterval:3.0];
    NSLog(@"%@----子线程任务结束",[NSThread currentThread]);
}

//总结:
//1、获取RunLoop只能使用[NSRunLoop currentRunLoop]或[NSRunLoop mainRunLoop];
//2、即使RunLoop开始运行,如果RunLoop中的modes为空,或者要执行的mode里没有item,
//   那么RunLoop会直接在当前loop中返回,并进入睡眠状态
//3、自己创建的Thread中的任务是在kCFRunLoopDefaultMode这个mode中执行的
//4、[runLoop addPort:[NSMachPort port] forMode:NSRunLoopCommonModes]
//   经过NSRunLoop封装后,只可以往mode中添加两类item任务:NSPort（对应的是source)、NSTimer
//   如果使用CFRunLoopRef,则可以使用C语言API,往mode中添加source、timer、observer
//
//  注意:AFNetworking使用的就是这种方式,AFNetworking都是通过调用[NSObject performSelector:onThread:..]将这个任务扔到了后台线程的RunLoop中





@end


