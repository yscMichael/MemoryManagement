//
//  AttributeCell.h
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/16.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Attribute.h"

@interface AttributeCell : UITableViewCell

@property (nonatomic,strong) Attribute *item;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

+ (UINib *)nib;
+ (NSString *)identifier;

@end
