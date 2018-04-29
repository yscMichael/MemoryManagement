//
//  NSTimerViewController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/4/29.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "NSTimerViewController.h"

@interface NSTimerViewController ()

@end

@implementation NSTimerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

}

//总结:
//系统总共有8个方法、6个类创建方法，2个实例初始化方法
//
//1、有三个方法直接将timer添加到了当前runloop(default mode),而不需要我们自己操作,
//   当然这样的代价是runloop只能是当前runloop,模式是default mode:
//
//+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo;
//+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;
//+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;
//
//2、下面五种创建,不会自动添加到runloop,还需调用addTimer:forMode:
//
//+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;
//+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo;
//+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;
//- (instancetype)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)ti target:(id)t selector:(SEL)s userInfo:(id)ui repeats:(BOOL)rep;
//- (instancetype)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;
//
//  参数说明:
//  a、yesOrNo(rep):是否重复,如果是YES则重复触发,直到调用invalidate方法;如果是NO,
//  则只触发一次就自动调用invalidate方法
//
//  b、aTarget(t):发送消息的目标,timer会强引用aTarget,直到调用invalidate方法
//
//  c、date:触发的时间,一般情况下我们都写[NSDate date],这样的话定时器会立马触发一次,并且以此时间为基准.如果没有此参数的方法,则都是以当前时间为基准,第一次触发时间是当前时间加上时间间隔ti.
//
//3、- (void)fire;
//  a、对于重复定时器，它不会影响正常的定时触发
//  b、对于非重复定时器，触发后就调用了invalidate方法，既使正常的还没有触发
//
//4、一个timer可以被添加到runloop的多个模式
//   a、主线程中runloop一般处于NSDefaultRunLoopMode
//   b、当滑动屏幕的时候,比如UIScrollView或者它的子类UITableView、UICollectionView等滑动时runloop处于UITrackingRunLoopMode模式下
//
//  因此,如果你想让timer在滑动的时候也能够触发，就可以分别添加到这两个模式下。或者直接用NSRunLoopCommonModes一个模式集





@end
