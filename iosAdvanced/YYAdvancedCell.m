//
//  YYCell.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/1.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "YYAdvancedCell.h"

@implementation YYAdvancedCell

+ (instancetype)xibTableViewCell
{
 //在类方法中加载xib文件,注意:loadNibNamed:owner:options:这个方法返回的是NSArray,所以在后面加上firstObject或者lastObject或者[0]都可以;因为我们的Xib文件中,只有一个cell
  return [[[NSBundle mainBundle] loadNibNamed:@"YYAdvancedCell" owner:nil options:nil] lastObject];
}

- (void)setFirstImage:(UIImage *)firstImage
{
    self.firstIView.image = firstImage;
}

- (void)setSecondImage:(UIImage *)secondImage
{
    self.secondIView.image = secondImage;
}

- (void)setThreeImage:(UIImage *)threeImage
{
    self.threeIView.image = threeImage;
}

@end
