//
//  InterceptedObjectsController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/7.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "InterceptedObjectsController.h"

//声明block类型
typedef void (^blk_t)(id);

@interface InterceptedObjectsController ()

@end

@implementation InterceptedObjectsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //[self InterceptedObjectsUse];
    //[self InterceptedObjectsAssignment];
    //[self InterceptedObjectsOne];
    [self InterceptedObjectsTwo];
    //[self charArrayCWrong];
    //[self charArrayCRight];
}

//截获对象并使用对象--无问题
- (void)InterceptedObjectsUse
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    void (^blk)(void) = ^{

        id obj = [[NSObject alloc]init];
        [array addObject:obj];
        NSLog(@"array.count = %lu",(unsigned long)array.count);//2
    };

    [array addObject:@"obj"];
    blk();
}

//截获对象并赋值--会有问题
- (void)InterceptedObjectsAssignment
{
    __block NSMutableArray *array = [[NSMutableArray alloc]init];
    void (^blk)(void) = ^{
        //不加__block,这里会报错
        array = [[NSMutableArray alloc]init];
    };

    blk();
}

//截获对象
- (void)InterceptedObjectsOne
{
    blk_t blk;
    {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        blk = [^(id obj){
            [array addObject:obj];
            NSLog(@"array.count-1 = %lu",(unsigned long)array.count);
        } copy];
    }

    blk([[NSObject alloc] init]);
    blk([[NSObject alloc] init]);
    blk([[NSObject alloc] init]);
}

//截获对象
- (void)InterceptedObjectsTwo
{
    blk_t blk;
    {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        blk = ^(id obj){
            [array addObject:obj];
            NSLog(@"array.count-2 = %lu",(unsigned long)array.count);
        };
    }

    blk([[NSObject alloc] init]);
    blk([[NSObject alloc] init]);
    blk([[NSObject alloc] init]);
}


//C语言字符串数组
//会有问题:截获自动变量的方法并没有实现对C语言数组的截获
- (void)charArrayCWrong
{
    const char text[] = "hello";
    void (^blk)(void) = ^{
        //这里会报错
        //printf("%c\n",text[0]);
    };
}

//C语言字符串数组
//没有问题
- (void)charArrayCRight
{
    const char *text = "hello";
    void (^blk)(void) = ^{
        //这里会报错
        printf("字符 = %c\n",text[0]);//h

        //sizeof
        const char temp[] = "hello";
        printf("sizeof-*text = %lu\n",sizeof(text));//8
        //包含\0在内
        printf("sizeof-temp[] = %lu\n",sizeof(temp));//6
    };

    blk();
}


//总结:
//1、如果对象是局部变量,在不加__block的情况下,只能截获使用,不能重新赋值
//2、如果对象是静态变量、静态全局变量、全局变量,则可以进行截取并使用
//3、C语言中数组是不能被截获的,只能使用指针


@end



