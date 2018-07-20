//
//  XibCollectionViewCell.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/7/20.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "XibCollectionViewCell.h"

@implementation XibCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark - Private Methods
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    //自适应size
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    //当前cell的frame
    CGRect cellFrame = layoutAttributes.frame;
    //对当前cell进行赋值
    cellFrame.size.height = size.height;
    cellFrame.size.width = size.width;
    //判断当前宽度是否大于屏幕宽度
    if (size.width >= ScreenWidth)
    {
        cellFrame.size.width = ScreenWidth;
    }

    layoutAttributes.frame = cellFrame;
    return layoutAttributes;
}

@end
