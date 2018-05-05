//
//  Apple+AppleOne.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "Apple+AppleOne.h"
#import <objc/runtime.h>

@implementation Apple (AppleOne)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        //获取方法名称,映射到具体方法
        SEL originalSelector = @selector(canEat);
        SEL swizzledSelector = @selector(swizzlingApplecanEat);

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
            //NSLog(@"苹果方法添加成功");
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
            //NSLog(@"苹果交换方法");
            //交换IMP
            method_exchangeImplementations(originalMethod, swizzledMethod);
            //最终实现效果
            //现在通过旧方法SEL来调用,就会实现新方法的IMP,通过新方法的SEL来调用,就会实现旧方法的IMP
        }
    });
}

#pragma mark - Method Swizzling
- (void)swizzlingApplecanEat
{
    //会调用父类方法
    //[self swizzlingApplecanEat];
    NSLog(@"swizzling---苹果");
}

@end
