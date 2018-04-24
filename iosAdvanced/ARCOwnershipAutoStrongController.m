//
//  ARCOwnershipAutoStrongController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/4.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "ARCOwnershipAutoStrongController.h"

@interface ARCOwnershipAutoStrongController ()

@end

@implementation ARCOwnershipAutoStrongController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

//查看模拟代码
- (void)simulationStrong
{
    //1、
    {
        id __strong obj = [[NSObject alloc] init];
    }

    //等价代码如下:
    //{
    //    id obj = objc_msgSend(NSObject, @selector(alloc));
    //    objc_msgSend(obj, @selector(alloc));
    //    objc_release(obj);
    //}

    //2、
    {
        id __strong obj = [NSMutableArray array];
    }

    //等价于以下代码
    //{
    //    id obj = objc_msgSend(NSMutableArray, @selector(array));
    //    objc_retainAutoreleasedReturnValue(obj);
    //    objc_release(obj);
    //}

}

//3、
+ (id) array
{
    return [[NSMutableArray alloc] init];
}

//等价于以下代码
//+ (id)array
//{
//    id obj = objc_msgSend(NSMutableArray, @selector(alloc));
//    objc_msgSend(obj, @selector(init));
//    return objc_autoreleaseReturnValue(obj);
//}


//总结:
//1、__strong:所有对象和id默认的类型;引用计数加1
//2、被__strong修饰符修饰的变量会自动初始化为nil.


@end
