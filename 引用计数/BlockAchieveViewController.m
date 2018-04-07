//
//  BlockAchieveViewController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/7.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "BlockAchieveViewController.h"

@interface BlockAchieveViewController ()

@end

@implementation BlockAchieveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

}

//内部实现原理
//Objective-C高级编程
#pragma mark - block内部解析
- (void)blockPrinciple
{
//__block_impl:更像一个block的基类，所有block都具备这些字段
//__main_block_impl_0:block变量,0表示第0个block.
//__main_block_func_0:虽然block叫匿名函数.但是,还是被编译器起了个名字
//__main_block_desc_0:block的描述.注意,他有一个实例__main_block_desc_0_DATA
}

//捕获自动变量原理分析
#pragma mark - 自动变量如何传值解析
- (void)InterceptedVariable
{
    int val = 10;
    void (^blk)(void) = ^{
        printf("val=%d\n",val);//10
    };
    val = 2;
    blk();
}
//分析如下:

//1、block内部结构体:
//__main_block_impl_0
//{
//   void *isa;
//   int Flags;
//   int Reserved;
//   void *FuncPtr;
//   struct __main_block_desc_0 *Desc;
//   int val；
//}

//2、val是如何传递到block结构体中的?
//int main()
//{
//    struct __main_block_impl_0 *blk =  &__main_block_impl_0(__main_block_func_0,&__main_block_desc_0_DATA,val);
//}
//备注:这里传入了一个val

//3、传入block结构体后,怎么使用
//static struct __main_block_func_0(struct __main_block_impl_0 *__cself)
//{
//    printf("val=%d\n"，__cself-val);
//}
//备注:类似于OC的self.


//_block说明符
#pragma mark - __block内部解析
- (void)blockSpecifier
{
    //使用__block才能改变截取自动变量的值
    __block int val = 10;
    void (^blk)(void) = ^{
        val = 1;

    };
    blk();
}

//__block内部代码解析:
//struct __block_byref_val_0
//{
//    void *__isa;
//    __block_byref_val_0 *__forwarding;
//    int _flags;
//    int __size;
//    int val;
//}

//以上代码等价于:
//__block_byref_val_0 val = {
//    0,
//    &val,
//    0,
//    sizeof(__block_byref_val_0),
//    10
//};//自己持有自己的指针
//但是这里不能直接保存val的指针,因为val是栈上的,保存栈变量的指针很危险













//Block例题
- (void)exampleBlock
{
    exampleA();
    exampleB();
    exampleC();
    exampleD();
    exampleE();
}

//-----------第一道题：--------------
void exampleA() {
    char a = 'A';
    ^{
      printf("%c\n", a);
    }();
}
//A.始终能够正常运行
//B.只有在使用ARC的情况下才能正常运行
//C.不使用ARC才能正常运行
//D.永远无法正常运行

//-----------第二道题：选项同第一题--------------
void exampleB_addBlockToArray(NSMutableArray *array)
{
    char b = 'B';
    [array addObject:^{
        printf("%c\n", b);
    }];
}

void exampleB()
{
    NSMutableArray *array = [NSMutableArray array];
    exampleB_addBlockToArray(array);
    void (^block)() = [array objectAtIndex:0];
    block();
}

//-----------第三道题：选项同第一题--------------
void exampleC_addBlockToArray(NSMutableArray *array)
{
    [array addObject:^{printf("C\n");}];
}

void exampleC()
{
    NSMutableArray *array = [NSMutableArray array];
    exampleC_addBlockToArray(array);
    void (^block)() = [array objectAtIndex:0];
    block();
}

//-----------第四道题：选项同第一题--------------
typedef void (^dBlock)();

dBlock exampleD_getBlock()
{
    char d = 'D';
    return ^{printf("%c\n", d);};
}

void exampleD()
{
    exampleD_getBlock()();
}

//-----------第五道题：选项同第一题--------------
typedef void (^eBlock)();

eBlock exampleE_getBlock()
{
    char e = 'E';
    void (^block)() = ^{printf("%c\n", e);};
    return block;
}

void exampleE()
{
    eBlock block = exampleE_getBlock();
    block();
}

//总结:
//1、参考文章
//   a、blocl内部实现
//      https://blog.csdn.net/hherima/article/details/38586101




@end
