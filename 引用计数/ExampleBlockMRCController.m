//
//  ExampleBlockMRCController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/9.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "ExampleBlockMRCController.h"

@interface ExampleBlockMRCController ()

@end

@implementation ExampleBlockMRCController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self exampleBlock];
}

//Block例题
- (void)exampleBlock
{
    //exampleA_MRC();
    //exampleB_MRC();
    //exampleC_MRC();
    //exampleD_MRC();
    exampleE_MRC();
}

//-----------第一道题：--------------
void exampleA_MRC() {
    char a = 'A';
    ^{
        printf("%c\n", a);
    }();
}
//A.始终能够正常运行

//A.始终能够正常运行
//B.只有在使用ARC的情况下才能正常运行
//C.不使用ARC才能正常运行
//D.永远无法正常运行

//-----------第二道题：选项同第一题--------------
void exampleB_addBlockToArray_MRC(NSMutableArray *array)
{
    char b = 'B';
    //在MRC情况下,当前block在栈下面,里面的引用变量也在栈下面
    //在超出函数作用域的情况下,使用block,block要使用变量b,肯定崩溃
    //解决办法:
    //      a、把block进行复制
    //      b、把变量b改为全局全局变量或者静态变量
    [array addObject:^{
        printf("%c\n", b);
    }];
}

void exampleB_MRC()
{
    NSMutableArray *array = [NSMutableArray array];
    exampleB_addBlockToArray_MRC(array);
    void (^block)() = [array objectAtIndex:0];
    block();
}
//B.只有在使用ARC的情况下才能正常运行

//A.始终能够正常运行
//B.只有在使用ARC的情况下才能正常运行
//C.不使用ARC才能正常运行
//D.永远无法正常运行

//-----------第三道题：选项同第一题--------------
void exampleC_addBlockToArray_MRC(NSMutableArray *array)
{
    //因为没有用到自动变量
    //这里引用的是常量,block相当于是在数据区,所以不会崩溃
    [array addObject:^{printf("C\n");}];
}

void exampleC_MRC()
{
    NSMutableArray *array = [NSMutableArray array];
    exampleC_addBlockToArray_MRC(array);
    void (^block)() = [array objectAtIndex:0];
    block();
}
//A.始终能够正常运行

//A.始终能够正常运行
//B.只有在使用ARC的情况下才能正常运行
//C.不使用ARC才能正常运行
//D.永远无法正常运行

//-----------第四道题：选项同第一题--------------
typedef void (^dBlockMRC)();

dBlockMRC exampleD_getBlock_MRC()
{
    char d = 'D';
    //这里这样写,编译直接会出错.
    //return ^{printf("%c\n", d);};

    //这里使用了自动变量,所以这里的block放在栈.
    //这里必须使用copy,把block复制到堆上.否则,立马被释放了.
    return [^{printf("%c\n", d);} copy];
}

void exampleD_MRC()
{
    dBlockMRC blockMRC;
    blockMRC = exampleD_getBlock_MRC();
    blockMRC();
}
//B.只有在使用ARC的情况下才能正常运行

//A.始终能够正常运行
//B.只有在使用ARC的情况下才能正常运行
//C.不使用ARC才能正常运行
//D.永远无法正常运行

//-----------第五道题：选项同第一题--------------
typedef void (^eBlockMRC)();

eBlockMRC exampleE_getBlock_MRC()
{
    char e = 'E';
    //这里编译不会报错
    //运行也不会出错,原因可能是会把block复制一下,对比第4题
    void (^block)() = ^{printf("%c\n", e);};
    return block;
}

void exampleE_MRC()
{
    eBlockMRC block = exampleE_getBlock_MRC();
    block();
}
//A.

//A.始终能够正常运行
//B.只有在使用ARC的情况下才能正常运行
//C.不使用ARC才能正常运行
//D.永远无法正常运行




@end


