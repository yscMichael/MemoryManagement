//
//  BlockStorageController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/7.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "BlockStorageController.h"

//全局Block
void (^blk)(void) = ^{printf("Global Block\n");};
//声明一个block类型
typedef int (^blk_t)(int);
typedef void (^blk_v)(void);
typedef int (^blk_t1)(void);

@interface BlockStorageController ()

@end

@implementation BlockStorageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //[self exampleMallocBlockOne];
    [self stackOrHeapOne];
}

//1、默认block是设置在栈上的

//2、全局block
- (void)exampleGlobalBlock
{
    //1、在声明全局变量的地方,定义Block(一定是定义,不是类型),是_NSConcretGlobalBlock
    //2、定义在函数内部的Block,没有捕获任何自动变量,也是_NSConcretGlobalBlock

    //全局block
    for(int rate = 0; rate < 100; rate++)
    {
        //这里进行定义<这里的返回值int可以省略>
        blk_t blk = ^(int count) {
            return count;
        };
        blk(10);
    }

    //栈block
    for(int rate = 0; rate < 100; rate++)
    {
        //这里进行定义<这里的返回值int可以省略>
        blk_t blk = ^int (int count) {
            return rate * count;
        };
        blk(10);
    }
}

//3、堆block
//a、block作为返回值使用
blk_t func(int rate)
{
    return ^(int count){return rate * count;};
}

//备注:
//如果在非ARC下,以下会报错.
//Returning block that lives on the local stack
//因为rate是在栈上的自动变量,被block捕获的时候,会放在block的结构体内,返回block的话就是返回局部变量,所以会出问题.
//这也从一个侧面印证了block截获自动变量的话,block就处于栈上
//ARC会自动判断,自动加上autorelease
//在MRC下加上autorelease,就能避免报错

blk_t fun()
{
    return ^(int count){
        return count;
    };
}
//不使用栈上的自动变量,在ARC和MRC下就没有问题,因为此时block是全局的

//b、使用copy,将block拷贝到堆上
- (void)exampleMallocBlockOne
{
    //这个会造成崩溃
    //id obj = [self getBlockArray];
    id obj = [self getBlockArrayCopy];
    blk_v blk = (blk_v)[obj objectAtIndex:0];
    blk();
}//这里会发生崩溃
//崩溃原因:数组里的block是栈上的,因为val是栈上的<截获使用了自动变量>.
//解决办法:调用copy方法

- (id)getBlockArray
{
    int val =10;
    return [[NSArray alloc]initWithObjects:
            ^{NSLog(@"blk0:%d",val);},
            ^{NSLog(@"blk1:%d",val);},nil];
}

- (id)getBlockArrayCopy
{
    int val =10;
    return [[NSArray alloc]initWithObjects:
            [^{NSLog(@"blk0:%d",val);} copy],
            [^{NSLog(@"blk1:%d",val);} copy],nil];
}

/*******************************/
//注意:
//在栈上调用copy那么复制到堆上
//在全局block调用copy什么也不做
//在堆上调用block 引用计数增加

//不管block配置在何处,用copy方法复制都不会引起任何问题.
//在ARC环境下,如果不确定是否要copy block尽管copy即可.ARC会打扫战场

/*****************************/
- (void)stackOrHeapOne
{
    __block int val =10;
    int *valPtr = &val;//使用int的指针，来检测block到底在栈上,还是堆上
    blk_t1 s = ^{
        NSLog(@"val_block = %d",++val);
        return val;
    };

    s();
    NSLog(@"valPointer = %d",*valPtr);
}

- (void)stackOrHeapTwo
{
    __block int val =10;
    int *valPtr = &val;//使用int的指针，来检测block到底在栈上，还是堆上
    blk_t1 s= ^{
        NSLog(@"val_block = %d",++val);
        return val;};
    blk_t1 h = [s copy];
    
    h();
    NSLog(@"valPointer = %d",*valPtr);
}






//总结:
//1、主要分为三种存储区域
//   a、_NSConcretStackBlock  栈
//   b、_NSConcretGlobalBlock 全局
//   c、_NSConcretMallocBlock 堆
//   __main_block_impl_0结构体中的isa就是这个值


@end
