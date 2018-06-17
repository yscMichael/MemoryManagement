//
//  AboutCell.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/16.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "AboutCell.h"

@implementation AboutCell

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

- (void)setItem:(ProfileViewModelAboutItem *)item
{
    _item = item;
    self.contentLabel.text = item.about;
}


@end
