//
//  InterceptedObjectsController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/7.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "InterceptedObjectsController.h"

//声明block类型
typedef void (^blk_O)(id obj);



@interface InterceptedObjectsController ()

@end

@implementation InterceptedObjectsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //截获对象并使用对象
    //[self InterceptedObjectsUse];
    //截获对象并赋值
    //[self InterceptedObjectsAssignment];
}

//截获对象并使用对象--无问题
- (void)InterceptedObjectsUse
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    void (^blk)(id) = ^(id obj){
        [array addObject:obj];
        NSLog(@"array.count = %lu",(unsigned long)array.count);//2
    };

    [array addObject:@"obj"];
    blk([[NSObject alloc]init]);
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

//总结:
//1、如果对象是局部变量,在不加__block的情况下,只能截获使用,不能重新赋值
//2、如果对象是静态变量、静态全局变量、全局变量,则可以进行截取并使用

@end



