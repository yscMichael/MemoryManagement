//
//  synthesizeAndDynamicController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/18.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "synthesizeAndDynamicController.h"

@interface synthesizeAndDynamicController ()

@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) NSString *price;

@end

@implementation synthesizeAndDynamicController
{
    NSString *_price;
}
@synthesize name = _newName;//重新指定成员变量
@dynamic price;//不实现set和get方法,直接赋值会出错

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.name = @"name";
    _newName = @"newName";
    self.price = @"10";

    NSLog(@"self.name = %@",self.name);
}

//必须存储一个私有变量
- (void)setPrice:(NSString *)price
{
    _price = price;
}

- (NSString *)price
{
    if (nil == _price)
    {
        _price = @"0";
    }
    return _price;
}

//总结:
//@property
//1、@property有两个对应的词,@synthsize @dynamic如果都没写,
//   那么默认就是@synthsize var = _var;
//2、@synthsize 如果没有手动实现setter getter方法那么自动生成,自动生成_var变量
//3、@dynamic告诉编译器:属性的setter,getter方法有用户自己实现,不自动生成.
//   假如一个属性被声明为@dynamic var 那么如果不实现setter getter方法,
//   编译阶段不会报错,但是一旦使用instance.var = someVar ,crash



@end
