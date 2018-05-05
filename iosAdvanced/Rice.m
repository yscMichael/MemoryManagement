//
//  Rice.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/5.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "Rice.h"

@implementation Rice

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.name = @"大米";
        self.price = 10;
    }
    return self;
}

//加上这句话,就不能自动触发KVO了
//+ (BOOL)automaticallyNotifiesObserversForName
//{
//    return NO;
//}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    NSLog(@"automaticallyNotifiesObserversForKey = %@",key);
    if ([key isEqualToString:@"price"])
    {
        NSLog(@"return NO");
        return NO;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

- (void)setPrice:(NSInteger)price
{
    NSLog(@"price-set方法");
    //[self willChangeValueForKey:@"price"];
    if (price != _price)
    {
        _price = price;
    }
    //[self didChangeValueForKey:@"price"];
}

@end
