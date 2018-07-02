//
//  LoadViewController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/7/2.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "LoadViewController.h"
#import "otherViewController.h"
#import "YYAnimation.h"
#import <QuartzCore/QuartzCore.h>

@interface LoadViewController ()

@property (nonatomic ,strong) UIView *firstView;
@property (nonatomic ,strong) UIView *secondView;
@property (nonatomic ,strong) UIView *threeView;
@property (nonatomic,strong) YYAnimation *animation;

@end

@implementation LoadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 100,100, 50)];
    [button setTitle:@"点击" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(scrollButtonView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    [self.view addSubview:self.firstView];
    [self.view addSubview:self.secondView];
    [self.view addSubview:self.threeView];
    [self layoutViews];
}

- (void)layoutViews
{
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        //这个是相对于父类的center来讲的(即相对于父类的偏移)
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(@200);
        make.width.mas_equalTo(@200);
    }];
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ScreenWidth);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(@200);
        make.width.mas_equalTo(@200);
    }];
    [self.threeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ScreenWidth * 2);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(@200);
        make.width.mas_equalTo(@200);
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"centerX = %f",self.firstView.center.x);
    NSLog(@"centerY = %f",self.firstView.center.y);
}

- (void)scrollButtonView:(UIButton *)sender
{
    NSString *type = kCATransitionPush;
    NSString *subtype = kCATransitionFromLeft;
    [self.animation transitionWithType:type WithSubtype:subtype ForView:self.firstView];
    //不能这种字符串
    //[self transitionWithType:@"kCATransitionPush" WithSubtype:@"kCATransitionFromLeft" ForView:self.firstView];
}

#pragma mark - Getter And Setter
- (UIView *)firstView
{
    if (!_firstView)
    {
        _firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        _firstView.backgroundColor = [UIColor redColor];
    }
    return _firstView;
}

- (UIView *)secondView
{
    if (!_secondView)
    {
        _secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        _secondView.backgroundColor = [UIColor greenColor];
    }
    return _secondView;
}

- (UIView *)threeView
{
    if (!_threeView)
    {
        _threeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        _threeView.backgroundColor = [UIColor blueColor];
    }
    return _threeView;
}

- (YYAnimation *)animation
{
    if (!_animation)
    {
        _animation = [[YYAnimation alloc] init];
    }
    return _animation;
}

@end
