//
//  NameCell.h
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/18.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NameItem.h"

@interface NameCell : UITableViewCell
//item
@property (nonatomic,strong) NameItem *item;
//加载xib
+ (UINib *)nib;
+ (NSString *)identifier;

@end
