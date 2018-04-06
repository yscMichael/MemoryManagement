//
//  Son.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/5.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "Son.h"

@implementation Son

- (id)init
{
    self = [super init];
    if (self)
    {
        NSLog(@"%@", NSStringFromClass([self class]));
        NSLog(@"%@", NSStringFromClass([super class]));
    }
    return self;
}

//总结self与super不同:
//1、self表示当前这个类的对象,而super是一个编译器标示符,和self指向同一个消息接受者
//2、self调用class方法时，是在子类Son中查找方法，而super调用class方法时，是在父类Father中查找方法
//3、[self class]等价代码如下:
//   id objc_msgSend(id self, SEL op, ...)
//   当前Son类的方法列表中查找，如果没有，就到Father类查找，还是没有，最后在NSObject类查找到class方法
//  NSObject类中的class方法等价代码如下:
//  - (Class)class {
//    return object_getClass(self);
//  }

//4、[super class]等价代码如下:
//   id objc_msgSendSuper(struct objc_super *super, SEL op, ...)
//  第一个参数super的数据类型是一个指向objc_super的结构体
//  struct objc_super {
//     id receiver; //这个还是self
//     Class superClass;//这个指的是父类
//  };
//  等价于:
//  objc_msgSend(objc_super->receiver, @selector(class))去调用
//  与[self class]调用相同,但是它是从父类开始查找

//总的来说,二者都没有实现class方法,最终会调用NSObject的class方法,它会查找当前的isa指针指向,因为当前消息发送是son,isa指向了son,所以最终返回的是son





@end
