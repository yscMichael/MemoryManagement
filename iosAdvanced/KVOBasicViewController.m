//
//  KVOBasicViewController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/5.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "KVOBasicViewController.h"
#import "YYPerson.h"

@interface KVOBasicViewController ()

@property(nonatomic, strong) YYPerson *person;
@property(nonatomic, strong) UILabel *personAgeLabel;


@end

@implementation KVOBasicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //需求,让控制器能够监听到person年龄的变化,并且将最新的年龄显示到界面上去

    //1、初始化person
    YYPerson *person = [YYPerson new];
    self.person = person;
    person.age = 10;

    //2、展示年龄label
    UILabel *personAge = [UILabel new];
    personAge.frame = CGRectMake(100, 100, 200, 200);
    personAge.text = [NSString stringWithFormat:@"%zd",person.age];
    personAge.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:personAge];
    self.personAgeLabel = personAge;

    //3、添加观察者,监听person属性
    [self.person addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

// NSKeyValueObservingOptionOld 把更改之前的值提供给处理方法
// NSKeyValueObservingOptionNew 把更改之后的值提供给处理方法
// NSKeyValueObservingOptionInitial 把初始化的值提供给处理方法,一旦注册,立马就会调用一次.
//                                  通常它会带有新值,而不会带有旧值.
// NSKeyValueObservingOptionPrior 分2次调用.在值改变之前和值改变之后.


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.person.age = 20;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"keyPath=%@",keyPath);
    NSLog(@"object=%@",object);
    NSLog(@"change=%@",change);
    NSLog(@"context=%@",context);
    //这里需要将NSNumber类型转换为字符串类型
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    NSString *ageStr = [numberFormatter stringFromNumber:[change objectForKey:@"new"]];

    self.personAgeLabel.text = ageStr;
}

- (void)dealloc
{
    [self.person removeObserver:self forKeyPath:@"age"];
}

@end


