//
//  AutoReleaseMRCViewController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/2.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "AutoReleaseMRCViewController.h"
#import "Person.h"
#import "Animal.h"

extern void _objc_autoreleasePoolPrint();//打印注册到自动释放池中的对象
extern uintptr_t _objc_rootRetainCount(id obj);//获取对象的引用计数

@interface AutoReleaseMRCViewController ()

@end

@implementation AutoReleaseMRCViewController

//当前是MRC环境!!!

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //[self autoReleaseStudy];
    //[self autoReleaseMany];
    [self autoReleaseClass];
}

//主动使用autorelease
- (void)autoReleaseStudy
{
    //因为自动释放池释放时机是当前runloop结束,不好控制,所以这里自己创建自动释放池
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    Person *person = [[Person alloc]init];
    NSLog(@"personCount-1 = %ld",(long)CFGetRetainCount((__bridge CFTypeRef)(person)));
    //调用这个,对象引用计数为0,立马释放
    //[person release];

    //调用这个,发现引用计数没有发生改变,它只是提供一种延时释放机制
    [person autorelease];
    NSLog(@"personCount-2 = %ld",(long)CFGetRetainCount((__bridge CFTypeRef)(person)));

    //当前自动释放池中含有Person对象
    _objc_autoreleasePoolPrint();
    [pool release];

    //当前自动释放池中不包含Person对象
    _objc_autoreleasePoolPrint();
}

//多次使用autorelease
- (void)autoReleaseMany
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    Person *person = [[Person alloc]init];
    [person autorelease];
    [person autorelease];

    //当前自动释放池中含有Person对象,是两个相同地址的对象<同一个对象>
    _objc_autoreleasePoolPrint();
    //这里会崩溃,因为person两次被加入自动释放池;
    //当自动释放池被销毁时,会向对象发送两次release消息;
    //但是引用计数开始为1,减两次为-1,所以会崩溃
    [pool release];
}

//类方法研究autorelease
- (void)autoReleaseClass
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    // it的引用计数为1
    Animal* it = [Animal productItem];
    // 接下来可以调用it的方法
    NSLog(@"%ld" , it.retainCount);
    // ...
    // 创建一个FKUser对象，并将它添加到自动释放池
    Person* user = [[[Person alloc] init] autorelease];
    // 接下来可以调用user的方法
    NSLog(@"%ld" , user.retainCount);
    // ...
    // 系统将因为池的引用计数变为0而回收自动释放池，
    // 回收自动释放池时会调用池中所有对象的release方法
    [pool release];
}

//总结：
//1、autorelease:该方法不会改变对象的引用计数,只是将该对象添加到自动释放池中
//2、自动释放池销毁时机:一次runloop结束||作用域超出{}||执行[pool release]
//3、执行几次autorelease,自动释放池销毁时,会向对象发送几次release消息
//4、release和drain区别:release会导致自动释放池自身的引用计数变为0,从而让系统回收NSAutoreleasePool;而drain只是回收释放池中的所有对象
//5、只要方法不是以alloc、new、copy、mutableCopy开头的,系统会默认创建自动释放的对象
//6、自动释放池中的对象是临时对象,要想保住这个临时对象,需要手动调用retain或者将临时对象赋值给retain、strong、copy指示符修饰的属性
//7、放在自动释放池中对象,会被延迟释放;此时可以理解为引用计数为1
//   当自动释放池被销毁时,会向里面的对象发送一条release信息


@end


