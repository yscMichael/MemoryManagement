//
//  UIViewController+Swizzling.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "UIViewController+Swizzling.h"

@implementation UIViewController (Swizzling)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        //获取方法名称,映射到具体方法
        SEL originalSelector = @selector(viewDidLoad);
        SEL swizzledSelector = @selector(swizzlingViewDidLoad);

        //获取到方法
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        //class_addMethod:给类添加一个新的方法和该方法的具体实现
        //Class cls:需要添加新方法的类(目标)
        //SEL name:表示方法的名称
        //IMP imp:表示方法的实现
        //const char *types:表示要添加的方法的返回值和参数

        //class_addMethod:如果发现方法已经存在目标类,会返回NO(可以用来做检查用).
        //我们这里是为了避免目标类没有该方法的情况;
        //如果目标类的确没有该方法,我们先尝试为其添加该方法
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

        if (didAddMethod)
        {//这里说明子类没有实现该方法(只有父类有),上面已经将原来方法orl重新定义
         //也就是说调用原来的方法,可以达到新的实现效果
            NSLog(@"方法添加成功");
            //但是原来的旧方法实现怎么办?万一以后要用呢
            //此时让新方法的SEL指向旧方法实现
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
            //最终实现效果
            //现在通过旧方法SEL来调用,就会实现新方法的IMP,通过新方法的SEL来调用,就会实现旧方法的IMP
        }
        else
        {//这里说明子类实现了这个方法,这里直接进行IMP交换就可以了
            NSLog(@"交换方法");
            //交换IMP
            method_exchangeImplementations(originalMethod, swizzledMethod);
            //最终实现效果
            //现在通过旧方法SEL来调用,就会实现新方法的IMP,通过新方法的SEL来调用,就会实现旧方法的IMP
        }
    });
}

#pragma mark - Method Swizzling
- (void)swizzlingViewDidLoad
{
    //[self swizzlingViewDidLoad];
    //NSLog(@"swizzlingViewDidLoad: %@", self);
    NSLog(@"swizzlingViewDidLoad");
}

//第一种情况是要复写的方法(overridden)并没有在目标类中实现(notimplemented)，而是在其父类中实现了
//对于第一种情况，应当先在目标类增加一个新的实现方法(override)，然后将复写的方法替换为原先(的实现(original one)

//第二种情况是这个方法已经存在于目标类中(does existin the class itself)
//对于第二情况(在目标类重写的方法)


//参考文章:
//1、官方文档
//   https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtDynamicResolution.html#//apple_ref/doc/uid/TP40008048-CH102-SW1

@end
