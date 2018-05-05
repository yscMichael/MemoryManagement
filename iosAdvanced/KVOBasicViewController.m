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

@end


