//
//  YYAnimation.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/7/2.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "YYAnimation.h"
#define DURATION 0.7f

@implementation YYAnimation

#pragma mark - CATransition
- (void)transitionWithType:(NSString *)type WithSubtype:(NSString *)subtype ForView:(UIView *)view
{
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    //设置运动时间
    animation.duration = DURATION;
    //设置运动type
    animation.type = type;
    //设置子subtype
    if (subtype != nil)
    {
        animation.subtype = subtype;
    }
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    [view.layer addAnimation:animation forKey:@"animation"];
}

#pragma mark - UIView类本身提供四种过渡效果
- (void)animationWithView:(UIView *)view WithAnimationTransition:(UIViewAnimationTransition) transition
{
    [UIView animateWithDuration:DURATION animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:transition forView:view cache:YES];
    }];
}

@end
