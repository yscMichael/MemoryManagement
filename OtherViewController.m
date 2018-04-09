//
//  OtherViewController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/6.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "OtherViewController.h"

@interface OtherViewController ()

@end

@implementation OtherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

}

// sizeof
// const char text[]
// block对全局变量
// copy
//kvo监听数组
//成员变量、实例变量、属性变量的联系
//_变量和self.变量区别
//__weak、__block对比
//__weak、__unsafe_unretained对比
//sizeof????
//字符串数组和字符串指针
//block属性用strong还是weak


//c 语言在内存划分中分为：栈区 堆区 全局静态区 常量区 代码区
//栈区：在函数内部定义的局部变量和局部数组，都在栈区。栈区的空间有系统管理，调用函数时开辟空间，函数执行结束空间回收
//
//堆区 ：空间有开发人员手动开辟，手动回收
//
//全局静态区： 存放一些全局变量和静态变量。空间有系统管理，程序开始执行开辟空间，程序运行结束空间回收，在程序执行期间一直存在（和程序的生命周期一致）
//
//常量区：存放常量，不可更改，空间有系统管理，生命周期和程序的生命周期一致。比如：字符串。
//
//代码区 ：存放代码编译之后的CPU指令，告诉计算机如何来执行程序

//一个由c/C++编译的程序占用的内存分为以下几个部分
//1、栈区（stack）— 由编译器自动分配释放 ，存放函数的参数值，局部变量的值等。其操作方式类似于数据结构中的栈。
//2、堆区（heap） — 一般由程序员分配释放， 若程序员不释放，程序结束时可能由OS回收 。注意它与数据结构中的堆是两回事，分配方式倒是类似于链表，呵呵。
//3、全局区（静态区）（static）—，全局变量和静态变量的存储是放在一块的，初始化的全局变量和静态变量在一块区域， 未初始化的全局变量和未初始化的静态变量在相邻的另一块区域。 - 程序结束后有系统释放
//4、文字常量区—常量字符串就是放在这里的。 程序结束后由系统释放
//5、程序代码区—存放函数体的二进制代码。

//内存分为五个区：栈区、堆区、全局区、常量区、代码区。这五个区在物理上是分开的，如下图所示：

//字符串数组长度




@end



