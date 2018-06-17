//
//  FriendCell.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/16.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "FriendCell.h"

@implementation FriendCell

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

- (void)setItem:(Friend *)item
{
    _item = item;
    NSLog(@"");
    self.contentImage.image = [UIImage imageNamed:item.pictureUrl];
    self.contentLabel.text = item.name;
}


@end
