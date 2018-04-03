//
//  ARCOwnershipViewController.m
//  引用计数
//
//  Created by 杨世川 on 18/3/27.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "ARCOwnershipViewController.h"
#import "NSObject+Category.h"


extern void _objc_autoreleasePoolPrint();//打印注册到自动释放池中的对象
extern uintptr_t _objc_rootRetainCount(id obj);//获取对象的引用计数

@interface ARCOwnershipViewController ()

@end

@implementation ARCOwnershipViewController
//当前要在ARC环境下执行！！！

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //所有权修饰符探究
//    [self testOne];
//    [self testTwo];
//    [self testThree];
    [self testFour];
//    [self testFive];
//    [self testSix];
}

/**
 * __autoreleasing研究 崩溃1
 */
- (void)testTwo
{
    id __unsafe_unretained obj1 = nil;
    {
        //这里如果添加__autoreleasing,不会崩溃
        id  obj0 = [NSMutableArray array];
        [obj0 addObject:@"obj"];
        obj1 = obj0;
        NSLog(@"obj0 = %@", obj0);
        _objc_autoreleasePoolPrint();
    }
    //以下代码等价于:
    {
        //objc_retainAutoreleasedReturnValue函数与objc_retain函数不同，它即便不注册到autoreleasepool中而返回对象，也能够正确地获取对象
        //id obj = objc_msgSend(NSMutableArray, @selector(array));
        //...
        //objc_release(obj);
    }
    _objc_autoreleasePoolPrint();

    //同样这里会崩溃,因为对象已经被销毁了
//    NSLog(@"obj1 = %@", obj1);
}

/**
 *  紧接上面  崩溃2
 */
- (void)testThree
{
    id __unsafe_unretained obj1 = nil;
    {
        //这里如果添加__autoreleasing,不会崩溃
        id  obj0 = [[NSMutableArray alloc]init];
        [obj0 addObject:@"obj"];
        obj1 = obj0;
        NSLog(@"obj0RetainCount-1 = %lu",_objc_rootRetainCount(obj0));
        NSLog(@"obj0 = %@", obj0);
    }//到这里obj0就release、因为使用的是__unsafe_unretained,所以obj1仍然指向原来区域

    //以上代码等价于以下代码：
    //{
    //   id obj = objc_msgSend(NSObject, @selector(alloc));
    //   objc_msgSend(obj, @selector(init));
    //   //...
    //   objc_release(obj);
    //}

    //由于原来的区域已经释放,它自己又不会变为nil,所以出现也指针崩溃
    //    NSLog(@"obj1 = %@", obj1);
}

/**
 *  紧接上面  不崩溃1
 */
- (void)testFour
{
    id __unsafe_unretained obj1 = nil;
    {
//        @autoreleasepool{
        //它的内容会被返回到自动释放池中
        id obj0 = [NSMutableArray arrayWithObjects:@"obj",nil];
        obj1 = obj0;
//        _objc_autoreleasePoolPrint();
        NSLog(@"obj0RetainCount-2 = %lu",_objc_rootRetainCount(obj0));
        NSLog(@"obj0 = %@", obj0);
//        }
    }
    NSLog(@"obj1 = %@", obj1);

//    NSMutableArray *array1 = [NSMutableArray array];
//    NSLog(@"retain count1 = %lu", _objc_rootRetainCount(array1));
//
//    NSMutableArray *array2 = [NSMutableArray arrayWithObjects:@"obj", nil];
//    NSLog(@"retain count2 = %lu", _objc_rootRetainCount(array2));
}

/**
 *  紧接上面 不崩溃2
 */
- (void)testFive
{
    id __unsafe_unretained obj1 = nil;
    {
        id obj0 = [[self class] Object];
        [obj0 addObject:@"obj"];
        obj1 = obj0;
        NSLog(@"obj0 = %@", obj0);
    }
    NSLog(@"obj1 = %@", obj1);
}

/**
 *  紧接上面 崩溃3
 */
- (void)testSix
{
    id __unsafe_unretained obj1 = nil;
    {
        id obj0 = [[self class] copy];
        [obj0 addObject:@"obj"];
        obj1 = obj0;
        NSLog(@"obj0 = %@", obj0);
    }
    //    NSLog(@"obj1 = %@", obj1);
}

/*
 * __strong、__weak、__unsafe_unretained、__autoreleasing对引用计数的影响
 * 被以上修饰符修饰的变量会自动初始化为nil.

 * __strong:所有对象和id默认的类型;引用计数加1

 * __weak:不影响引用计数
 * __weak:修饰的变量不持有对象
 * __weak:持有某对象的弱引用时，若该对象被废弃时，则弱引用自动失效且处于nil
 * __weak:修饰符只能用于IOS5以上的应用程序(ARC是IOS5推出的)、在IOS4程序中可以使用__unsafe_unretained修饰符代替
 * __weak:不能用于MRC环境

 * __unsafe_unretained:不持有对象的强引用也不持有弱引用
 * __unsafe_unretained与__weak的区别：
    1、__weak只能用于ARC,也就是IOS5以后;__unsafe_unretained无限制
    2、__weak持有对象的弱引用,当对象被废弃时,则弱引用自动失效且处于nil
       __unsafe_unretained不持有对象的弱引用也不弱引用,当对象被废弃时,指针不会自动处于nil,还指向原来的内存区域,容易出现野指针
    备注：ARC的内存管理工作是编译器的工作，但是__unsafe_unretained修饰的变量不属于编译器的内存管理对象

 * __autoreleasing:
 *
 *
 *
 *
 *
 *
 **/


/*
 * 研究__weak和__unsafe_unretained区别
 **/
- (void)testOne
{
    //1、这里会提示对象会立即释放
    //id __weak objOne = [[NSObject alloc]init];
    //NSLog(@"objOne = %@",objOne);

    //2、这里会提示对象会立即释放
    //id __unsafe_unretained objTwo = [[NSObject alloc]init];
    //NSLog(@"objTwo = %@",objTwo);

    //3、以上都会提示对象释放，到底有什么区别呢
    //这里不会崩溃,objThree会自动变为nil,对nil发送消息不会崩溃

    //id __unsafe_unretained objThree = [[NSMutableArray alloc]init];
    //[objThree addObject:@"obj"];

    //这里会崩溃,这里的指针不会变为nil,还是指向一段已经释放的内存
    //id __weak objFour = [[NSMutableArray alloc]init];
    //[objFour addObject:@"obj"];

    //4、以下代码依然会崩溃,原因是obj0超出作用域失效,obj1既不强引用也不弱引用,因此对象就被释放了.
    //但是obj1还是指向这块回收的内存区域,出现野指针.

    //id __unsafe_unretained obj1 = nil;
    //{
    //    id  obj0 = [[NSMutableArray alloc]init];
    //    [obj0 addObject:@"obj"];
    //    obj1 = obj0;
    //    NSLog(@"obj0 = %@", obj0);
    //}
    //NSLog(@"obj1 = %@", obj1);
}




@end


