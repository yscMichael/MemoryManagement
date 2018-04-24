//
//  InterceptedObjectsMRCController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/9.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "InterceptedObjectsMRCController.h"
#import "MyClass.h"

@interface InterceptedObjectsMRCController ()

@end

@implementation InterceptedObjectsMRCController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    MyClass* obj = [[[MyClass alloc] init] autorelease];
    [obj test];
}



@end
