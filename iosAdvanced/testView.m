//
//  testView.m
//  testXib
//
//  Created by 杨世川 on 2018/6/5.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "testView.h"

@implementation testView


//执行顺序如下:
//initWithCoder  -> awakeFromNib
- (void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"awakeFromNib");
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        NSLog(@"initWithCoder");
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSLog(@"initWithFrame");
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"layoutSubviews");
}


@end
