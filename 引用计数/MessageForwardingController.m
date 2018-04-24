//
//  MessageForwardingController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/5.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "MessageForwardingController.h"

@interface MessageForwardingController ()

@end

@implementation MessageForwardingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

}

//总结:
//   1、某个对象调用某个方法,发现自己没有实现,父类也没有实现,此时会进入消息转发机制
//      此时系统会调用以下方法:
//      a、+ (BOOL)resolveInstanceMethod:(SEL)selector//实例对象
//         + (BOOL)resolveClassMethod:(SEL)selector//类对象
//      b、- (id)forwardingTargetForSelector:(SEL)selector
//         - (void)forwardInvocation:(NSInvocation *)invocation


//参考文章:
//1、深入理解Objective-C的Runtime机制
//  https://www.csdn.net/article/2015-07-06/2825133-objective-c-runtime/5



@end

