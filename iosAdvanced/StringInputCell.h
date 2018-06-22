//
//  StringInputCell.h
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/22.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringInputItem.h"

@interface StringInputCell : UITableViewCell
//item
@property (nonatomic,strong) StringInputItem *item;
//加载xib
+ (UINib *)nib;
+ (NSString *)identifier;

@end
