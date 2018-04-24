//
//  DynamicAddMethodController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/18.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "DynamicAddMethodController.h"

@interface DynamicAddMethodController ()

@end

@implementation DynamicAddMethodController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

}

//总结:
//   class_addMethod(class,originalSelector,method_getImplementation(swizzledMethod),
//   method_getTypeEncoding(swizzledMethod));
//   :给某个类动态添加方法

@end

