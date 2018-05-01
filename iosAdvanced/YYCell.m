//
//  YYCell.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/1.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "YYCell.h"

@implementation YYCell

+ (instancetype)xibTableViewCell
{
 //在类方法中加载xib文件,注意:loadNibNamed:owner:options:这个方法返回的是NSArray,所以在后面加上firstObject或者lastObject或者[0]都可以;因为我们的Xib文件中,只有一个cell
  return [[[NSBundle mainBundle] loadNibNamed:@"YYCell" owner:nil options:nil] lastObject];
}

- (void)setFirstImage:(UIImage *)firstImage
{
    self.firstImageView.image = firstImage;
}

- (void)setSecondImage:(UIImage *)secondImage
{
    self.secondImageView.image = secondImage;
}

- (void)setThreeImage:(UIImage *)threeImage
{
    self.threeImageView.image = threeImage;
}

@end
