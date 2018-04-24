//
//  Movie.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/23.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "Movie.h"
#import <objc/message.h>

//必须遵守NSCoding协议
@implementation Movie
//自定义对象的解档和归档

//以下是运行时方法
//归档
- (void)encodeWithCoder:(NSCoder *)encoder
{
    unsigned int count = 0;
    //获取所有的成员变量
    Ivar *ivars = class_copyIvarList([Movie class], &count);
    for (int i = 0; i < count; i ++)
    {
        //取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        //查看成员变量
        const char *name = ivar_getName(ivar);
        //归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [encoder encodeObject:value forKey:key];
    }
}

//解档
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([Movie class], &count);
        for (int i = 0; i < count; i ++)
        {
            // 取出i位置对应的成员变量
            Ivar ivar = ivars[i];
            // 查看成员变量
            const char *name = ivar_getName(ivar);
            // 归档
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [decoder decodeObjectForKey:key];
            // 设置到成员变量身上
            [self setValue:value forKey:key];
        }
    }
    return self;
}


//以下是普通方法
//归档
//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [aCoder encodeObject:self.movieId forKey:@"id"];
//    [aCoder encodeObject:self.movieName forKey:@"name"];
//    [aCoder encodeObject:self.pic_url forKey:@"url"];
//}

//解档
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super init])
//    {
//        self.movieId = [aDecoder decodeObjectForKey:@"id"];
//        self.movieName = [aDecoder decodeObjectForKey:@"name"];
//        self.pic_url = [aDecoder decodeObjectForKey:@"url"];
//    }
//    return self;
//}

@end
