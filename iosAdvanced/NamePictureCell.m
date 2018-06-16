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

@end
