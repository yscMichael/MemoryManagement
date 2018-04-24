//
//  msgSendViewController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/5.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "msgSendViewController.h"
#import <objc/runtime.h>
#import "Father.h"
#import "Son.h"

@interface msgSendViewController ()

@end

@implementation msgSendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self selfAndSuper];
}

//解析msgSend
- (void)resolveMsgSend
{
    //[receiver message]
    //等价于:
    //id objc_msgSend ( id self, SEL op, ... );

    //参数解析:
    //1、
    //id是函数objc_msgSend第一个参数的数据类型,id是通用类型指针
    //id其实就是一个指向objc_object结构体指针，它包含一个Class isa成员，根据isa指针就可以顺藤摸瓜找到对象所属的类

    //在objc.h中 typedef struct objc_object *id;
    //struct objc_object {
    //  Class isa  OBJC_ISA_AVAILABILITY;
    //};

    //Class分析:
    //isa指针的数据类型是Class,Class表示对象所属的类
    //在objc.h中 typedef struct objc_class *Class;
    //Class其实就是一个objc_class结构体指针,在runtime.h有详细解释

    //objc_class内部解析解析:
    //struct objc_class {
    //    Class isa  OBJC_ISA_AVAILABILITY;
    //1、
    //:::isa表示一个Class对象的Class，也就是Meta Class
    //:::结构体objc_class也是继承objc_object

    //#if !__OBJC2__
    //    Class super_class                                        OBJC2_UNAVAILABLE;
    //2、
    //:::super_class表示实例对象对应的父类

    //    const char *name                                         OBJC2_UNAVAILABLE;
    //3、
    //:::name表示类名

    //    struct objc_ivar_list *ivars                             OBJC2_UNAVAILABLE;
    //4、
    //:::ivars表示多个成员变量，它指向objc_ivar_list结构体
    //objc_ivar_list结构体解析:
    //  struct objc_ivar_list {
    //        int ivar_count                                     OBJC2_UNAVAILABLE;
    //#ifdef __LP64__
    //        int space                                                OBJC2_UNAVAILABLE;
    //#endif
    //        /* variable length structure */
    //        struct objc_ivar ivar_list[1]                            OBJC2_UNAVAILABLE;
    //    }
    //objc_ivar_list其实就是一个链表，存储多个objc_ivar，而objc_ivar结构体存储类的单个成员变量信息


    //    struct objc_method_list **methodLists                    OBJC2_UNAVAILABLE;
    //5、
    //methodLists表示方法列表
    //它指向objc_method_list结构体的二级指针，可以动态修改*methodLists的值来添加成员方法，也是Category实现原理，同样也解释Category不能添加属性的原因

    //    struct objc_cache *cache                                 OBJC2_UNAVAILABLE;
    //6、
    //cache用来缓存经常访问的方法，它指向objc_cache结构体

    //    struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;
    //7、
    //protocols表示类遵循哪些协议
    //#endif
    //
    //}

    //2、
    //SEL是函数objc_msgSend第二个参数的数据类型，表示方法选择器
    //在objc.h中 typedef struct objc_selector *SEL;

    //3、objc_msgSend它具体是如何发送消息
    //a、首先根据receiver对象的isa指针获取它对应的class；
    //b、优先在class的cache查找message方法，如果找不到，再到methodLists查找；
    //c、如果没有在class找到，再到super_class查找；
    //d、一旦找到message这个方法，就执行它实现的IMP
}

//self与super对比
- (void)selfAndSuper
{
    Son *son = [[Son alloc]init];
    NSLog(@"class = %@",[son class]);
}


//总结:
//一、objc_msgSend
//   1、objc_msgSend:包含接受者、方法名称、参数
//   2、objc_msgSend运作过程如下:
//      a、首先在接受者所属类中搜寻其方法列表(list of methods).
//         若能顺利找到方法,就跳至实现代码.
//      b、如果找不到,则继续向上查找,直到找到合适的方法,再跳转至实现代码.
//      c、如果还是找不到合适代码,那就执行消息转发(message forwarding).
//
//      注意:调用一个方法并不一定要执行以上步骤,因为objc_msgSend会将匹配结果
//      缓存在"快速映射表"里面,下次找就不那么麻烦了.
//
//二、消息转发
//   1、基本概念
//      一个对象调用方法,但是自己并没有实现这个方法,父类也没有实现这个方法.此时会消息转发
//      如果你做一些处理操作,可以避免崩溃等突发状况.
//   2、有以下几种方案
//      a、
//         + (BOOL)resolveInstanceMethod:(SEL)sel//你要用的方法是实例方法
//         + (BOOL)resolveClassMethod:(SEL)sel//你要用的方法是类方法
//
//      b、
//         - (id)forwardingTargetForSelector:(SEL)aSelector
//
//      c、
//         - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;
//         - (void)forwardInvocation:(NSInvocation *)anInvocation;
//
//    参考文章:
//    1、轻松学习之 Objective-C消息转发
//      http://www.cocoachina.com/ios/20150604/12013.html


//总结:
//   1、objc_msgSend组成 id + SEL(方法选择器) + 参数
//      id : 结构体指针,里面包含isa指针(根据isa可以找到所属哪个类)
//      SEL : 指向方法的地址


//参考文章:
//1、深入理解Objective-C的Runtime机制
//   https://www.csdn.net/article/2015-07-06/2825133-objective-c-runtime/1
//
//2、Objective-C特性：Runtime
//  https://www.jianshu.com/p/25a319aee33d
//

@end


