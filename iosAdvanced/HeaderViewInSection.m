//
//  HeaderViewInSection.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/13.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "HeaderViewInSection.h"

@interface HeaderViewInSection ()

@property (nonatomic , strong) UILabel *titleLabel;

@end

@implementation HeaderViewInSection
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.titleLabel];
    }
    return self;

}

#pragma mark - setter and getter
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = _title;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 10, 40)];
        _titleLabel.textColor =  [UIColor colorWithRed:221/255.0 green:61/255.0 blue:47/255.0 alpha:1];
    }
    return _titleLabel;
}

@end

