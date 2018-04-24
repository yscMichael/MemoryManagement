//
//  Person+NewPerson.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/18.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "Person+NewPerson.h"
#import <objc/message.h>

static const NSString *KEY_Name = @"name";
static const NSString *KEY_Height = @"height";

@implementation Person (NewPerson)
//手动设置set和get方法
@dynamic name;
@dynamic height;

- (void)setName:(NSString *)name
{
    //objc_setAssociatedObject（将某个值跟某个对象关联起来，将某个值存储到某个对象中）
    //objc_setAssociatedObject(id _Nonnull object, const void * _Nonnull key,
    //                         id _Nullable value, objc_AssociationPolicy policy)
    //object:给哪个对象添加属性
    //key:属性名称
    //value:属性值
    //policy:保存策略
    objc_setAssociatedObject(self, @"name", name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //objc_setAssociatedObject(self, &KEY_Name, name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setHeight:(NSString *)height
{
    objc_setAssociatedObject(self, @"height", height, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //objc_setAssociatedObject(self, &KEY_Height, height, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)name
{
    return objc_getAssociatedObject(self, @"name");
    //return objc_getAssociatedObject(self, &KEY_Name);
}

- (NSString *)height
{
    return objc_getAssociatedObject(self, @"height");
    //return objc_getAssociatedObject(self, &KEY_Height);
}

@end
