//
//  ARCOwnershipViewController.m
//  引用计数
//
//  Created by 杨世川 on 18/3/27.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "ARCOwnershipAutoReleaseController.h"
#import "NSObject+Category.h"


extern void _objc_autoreleasePoolPrint();//打印注册到自动释放池中的对象
extern uintptr_t _objc_rootRetainCount(id obj);//获取对象的引用计数

@interface ARCOwnershipAutoReleaseController ()

@end

@implementation ARCOwnershipAutoReleaseController
//当前要在ARC环境下执行！！！

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self autoreleaseStudy];
}

//查看模拟代码
- (void)simulationAutoRelease
{
    @autoreleasepool {
        id __autoreleasing obj = [[NSObject alloc] init];
    }

    //等价代码如下:
    //id pool = objc_autoreleasePoolPush();

    //id obj = objc_msgSend(NSObject, @selector(alloc));
    //objc_msgSend(obj, @selector(init));
    //objc_autorelease(obj);//这里又添加到自动释放池中了

    //objc_autoreleasePoolPop(pool);

    //等价MRC代码:
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    //id obj = [[NSObject alloc] init];
    //[obj autorelease];
    //[pool drain];


    @autoreleasepool {
        id __autoreleasing obj = [NSMutableArray array];
    }

    //等价代码如下:
    //id pool = objc_autoreleasePoolPush();

    //id obj = objc_msgSend(NSMutableArray, @selector(array));
    //objc_retainAutoreleasedReturnValue(obj);//类似于alloc
    //objc_autorelease(obj);//又将其加入自动释放池

    //objc_autoreleasePoolPop(pool);
}

#pragma mark - __autoreleasing修饰符
- (void)autoreleaseStudy
{
    //[self autoreleaseStudyOne];
    //[self autoreleaseStudyTwo];
    //[self autoreleaseStudyThree];
    //[self autoreleaseStudyFour];
}

//崩溃1
- (void)autoreleaseStudyOne
{
    id __unsafe_unretained target = nil;

    @autoreleasepool {
        id __autoreleasing temp = [[NSObject alloc]init];
        target = temp;
        NSLog(@"temp = %@", temp);
    }
    NSLog(@"target = %@", target);
}//这里会崩溃,虽然加入了自动释放池,但是超出自动释放池范围,对象一样被销毁

//崩溃2
- (void)autoreleaseStudyTwo
{
    id __unsafe_unretained target = nil;

    @autoreleasepool {
        id  temp = [[NSObject alloc]init];
        target = temp;
        NSLog(@"temp = %@", temp);
    }
    NSLog(@"target = %@", target);
}//这里会崩溃,超出作用域被编译器插入objc_release方法释放掉

//不崩溃3
- (void)autoreleaseStudyThree
{
    id __unsafe_unretained target = nil;
    {
        //temp被注册到自动释放池中
        id __autoreleasing temp = [NSMutableArray array];
        [temp addObject:@"obj"];
        target = temp;
        NSLog(@"temp.retainCount = %lu",_objc_rootRetainCount(temp));
    }//temp在自动释放池中,超出大括号,也没有被销毁
    NSLog(@"target = %@",target);
}

//不崩溃4
- (void)autoreleaseStudyFour
{
    id __unsafe_unretained target = nil;
    {
        //被注册到自动释放池中了
        id __autoreleasing temp = [[NSMutableArray alloc]init];
        [temp addObject:@"obj"];
        target = temp;
        NSLog(@"temp.retainCount = %lu",_objc_rootRetainCount(temp));
    }//temp在自动释放池中,超出大括号,也没有被销毁
    NSLog(@"target = %@",target);
}

//总结:
//1、在ARC下__autoreleasing代替了autorelease
//2、以下两种情况默认是添加了__autoreleasing修饰符
//   a、对象作为函数的返回值，编译器会自动将其注册到自动释放池<ARC对其进行了优化>
//   b、id的指针或对象的指针在没有显示指定时会被附加上__autoreleasing修饰符
//3、参考网址:
//   https://blog.csdn.net/junjun150013652/article/details/53149145
//   http://blog.sunnyxx.com/2014/10/15/behind-autorelease/

@end


