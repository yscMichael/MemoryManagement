//
//  SelectCell.h
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/22.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectYesOrNoItem.h"

@interface SelectYesOrNoCell : UITableViewCell
//item
@property (nonatomic,strong) SelectYesOrNoItem *item;
//加载xib
+ (UINib *)nib;
+ (NSString *)identifier;

@end
