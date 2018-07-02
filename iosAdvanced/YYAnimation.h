//
//  YYAnimation.h
//  iosAdvanced
//
//  Created by 杨世川 on 2018/7/2.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYAnimation : NSObject

//CATransition
//参数type:
// kCATransitionFade 淡化
// kCATransitionPush 推挤
// kCATransitionReveal 揭开
// kCATransitionMoveIn 覆盖
// @"cube" 立方体
// @"suckEffect" 吸收
// @"oglFlip" 翻转
// @"rippleEffect" 波纹
// @"pageCurl" 翻页
// @"pageUnCurl" 反翻页
// @"cameraIrisHollowOpen" 镜头开
// @"cameraIrisHollowClose" 镜头关
//参数subtype:
//kCATransitionFromRight
//kCATransitionFromLeft
//kCATransitionFromTop
//kCATransitionFromBottom

- (void)transitionWithType:(NSString *)type WithSubtype:(NSString *)subtype ForView:(UIView *)view;

//UIView类本身提供四种过渡效果
//参数transition：
//UIViewAnimationTransitionNone 正常
//UIViewAnimationTransitionFlipFromLeft 从左向右翻
//UIViewAnimationTransitionFlipFromRight 从右向左翻
//UIViewAnimationTransitionCurlUp 从下向上卷
//UIViewAnimationTransitionCurlDown 从上向下卷
- (void)animationWithView:(UIView *)view WithAnimationTransition:(UIViewAnimationTransition) transition;




@end
