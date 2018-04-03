//
//  AutoReleaseMemoryViewController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/2.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "AutoReleaseMemoryViewController.h"

extern void _objc_autoreleasePoolPrint();//打印注册到自动释放池中的对象
extern uintptr_t _objc_rootRetainCount(id obj);//获取对象的引用计数

@interface AutoReleaseMemoryViewController ()

@end

@implementation AutoReleaseMemoryViewController

//当前可以在ARC也可以在MRC环境下执行、这里是MRC环境
//在MRC下使用NSAutoreleasePool
//在ARC下使用@autoreleasepool{}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //测试内存
    [self testMemory];
}

- (void)testMemory
{
    for (int i =0; i < 1000000; i++)
    {
        //这里的前提是中间部分代码有autorelease对象产生
        //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

        NSString *string =@"Abc";
        string = [string lowercaseString];
        string = [string stringByAppendingString:@"xyz"];
        NSLog(@"%@", string);

        //[pool release];
    }
}



@end

