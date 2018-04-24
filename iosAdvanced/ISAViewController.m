//
//  ISAViewController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/5.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "ISAViewController.h"

@interface ISAViewController ()

@end

@implementation ISAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

//    NSObject
}

//解析
- (void)resolveNSObject
{
   //NSObject 属性 Class isa

   //1、Class 是一个 objc_class 结构类型的指针;

   //Class指的是 typedef struct objc_class *Class
   //objc_class里面内容如下:
   //struct objc_class {
        //Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
        //
        //#if !__OBJC2__
        //    Class _Nullable super_class                              OBJC2_UNAVAILABLE;
        //    const char * _Nonnull name                               OBJC2_UNAVAILABLE;
        //    long version                                             OBJC2_UNAVAILABLE;
        //    long info                                                OBJC2_UNAVAILABLE;
        //    long instance_size                                       OBJC2_UNAVAILABLE;
        //    struct objc_ivar_list * _Nullable ivars                  OBJC2_UNAVAILABLE;
        //    struct objc_method_list * _Nullable * _Nullable methodLists                    OBJC2_UNAVAILABLE;
        //    struct objc_cache * _Nonnull cache                       OBJC2_UNAVAILABLE;
        //    struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE;
        //#endif
        //
        //}

    //2、id（任意对象） 是一个 objc_object 结构类型的指针
    //typedef struct objc_object *id;
    //struct objc_object {
    //    Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
    //}
}


//参考网址:
//1、iOS中isa指针
//   https://blog.csdn.net/miao_em/article/details/56671616




@end


