//
//  TestModel.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/11.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "TestModel.h"
#import <objc/runtime.h>// 导入运行时文件

@implementation TestModel

- (id)copyWithZone:(NSZone *)zone
{

    TestModel * model = [[[self class] allocWithZone:zone] init];

    model.age = self.age;//self是被copy的对象

    model.name = self.name;
    model.province = self.province;
    model.area = self.area;
    
    return model;

}

- (id)mutableCopyWithZone:(NSZone *)zone
{

    TestModel * model = [[[self class] allocWithZone:zone] init];

    model.age = self.age;//self是被copy的对象

    model.name = self.name;
    model.modelId = self.modelId;
    model.province = self.province;
    model.area = [self.area mutableCopy];

//    unsigned int count;// 记录属性个数
//    objc_property_t *properties = class_copyPropertyList([self class], &count);
//    NSMutableArray *mArray = [NSMutableArray array];
//    for (int i = 0; i < count; i++)
//    {
//
//        // An opaque type that represents an Objective-C declared property.
//        // objc_property_t 属性类型
//        objc_property_t property = properties[i];
//        // 获取属性的名称 C语言字符串
//        const char *cName = property_getName(property);
//        // 转换为Objective C 字符串
//        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
//        [mArray addObject:name];
//    }


    unsigned int countSelf;// 记录属性个数
    Ivar *ivars = class_copyIvarList([self class], &countSelf);
    Ivar *ivarsTemp = class_copyIvarList([model class], &countSelf);
    for (int i = 0; i < countSelf; i ++)
    {
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        // 查看成员变量
        const char *name = ivar_getName(ivar);

        for (int j = 0; j < countSelf; j ++)
        {
            Ivar ivarTemp = ivarsTemp[i];
            const char *nameTemp = ivar_getName(ivarTemp);
            if (name == nameTemp)
            {
//                ivarTemp = [ivar muta];
            }
        }

    }


    return model;

}

- (NSMutableDictionary *)area
{
    if (!_area)
    {
        _area = [[NSMutableDictionary alloc] init];
    }
    return _area;
}


@end
