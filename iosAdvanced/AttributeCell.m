//
//  AttributeCell.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/16.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "AttributeCell.h"

@implementation AttributeCell

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

- (void)setItem:(Attribute *)item
{
    _item = item;
    self.titleLabel.text = item.key;
    self.contentLabel.text = item.value;
}



@end
