//
//  NamePictureCell.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/16.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "NamePictureCell.h"

@implementation NamePictureCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

+ (UINib *)nib;
{
    return  [UINib nibWithNibName:self.identifier bundle:nil];
}

+ (NSString *)identifier
{
    return [self description];
}

- (void)setItem:(ProfileViewModelNamePictureItem *)item
{
    _item = item;
    self.contentImage.image = [UIImage imageNamed:item.pictureUrl];
    self.contentLabel.text = item.name;
}

//这里有输入怎么办???怎么关联
//解决办法,声明一个代码,这个代理直接赋值,将处理的结果直接通过代理传递过去


@end
