//
//  CustomizeKVOController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/5.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "CustomizeKVOController.h"
#import "NSObject+KVO.h"
#import "Tomato.h"

@interface CustomizeKVOController ()

@property (nonatomic, strong) Tomato *tomato;

@end

@implementation CustomizeKVOController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self.tomato YY_addObserver:self forKey:NSStringFromSelector(@selector(price)) withBlock:^(id observedObject, NSString *observedKey, id oldValue, id newValue) {

        NSLog(@"observedObject = %@",observedObject);
        NSLog(@"observedKey = %@",observedKey);
        NSLog(@"oldValue = %@",oldValue);
        NSLog(@"newValue = %@",newValue);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSArray *msgs = @[@"10块钱一斤", @"20块钱一斤", @"30块钱一斤", @"40块钱一斤", @"50块钱一斤", @"60块钱一斤", @"70块钱一斤"];
    NSUInteger index = arc4random_uniform((u_int32_t)msgs.count);
    self.tomato.price = msgs[index];
}

- (void)dealloc
{
    NSLog(@"移除观察者");
    [self.tomato YY_removeObserver:self forKey:@"price"];
}

#pragma mark - setters And getters
- (Tomato *)tomato
{
    if (!_tomato)
    {
        _tomato = [[Tomato alloc] init];
    }
    return _tomato;
}

//总结:
//一、原理简单阐述
//1、当你观察一个对象时,一个新的类会动态被创建.
//2、这个类继承自该对象的原本的类,并重写了被观察属性的setter方法.
//3、重写的setter方法会负责在调用原setter方法之前和之后,通知所有观察对象值的更改.
//4、最后把这个对象的isa指针(isa指针告诉Runtime系统这个对象的类是什么)指向这个新创建的子类,对象就神奇的变成了新创建的子类的实例.
//5、原来,这个中间类,继承自原本的那个类.
//6、不仅如此,Apple还重写了-class方法,企图欺骗我们这个类没有变,就是原本那个类.
//7、更具体的信息，去跑一下 Mike Ash 的那篇文章里的代码就能明白，这里就不再重复。
//
//参考文章:
//1、如何自己动手实现 KVO
//http://www.cocoachina.com/ios/20150313/11321.html
//http://www.cocoachina.com/ios/20171127/21338.html



@end
