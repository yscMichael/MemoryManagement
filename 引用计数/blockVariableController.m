//
//  blockVariableController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/7.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "blockVariableController.h"

@interface blockVariableController ()

@end

@implementation blockVariableController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self testBlock];
}

- (void)testBlock
{
    __block int val = 0;
    void (^blk)(void) = [^{
        ++val;//val = 2
    } copy];

    ++val;//val = 1
    blk();
    NSLog(@"val = %d",val);
}

//

//总结:
//1、当block被复制到堆上时,它所捕获的对象、变量也全部复制到堆上
//2、__block是一个结构体,结构体中有一个字段叫__forwarding,用于指向自动这个结构体.
//  那么有了这个__forwarding指针，无论是栈上的block还是被拷贝到堆上，那么都会正确的访问自动变量的值




@end


