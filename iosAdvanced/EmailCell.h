//
//  EmailCell.h
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/16.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewModelEmailItem.h"

@interface EmailCell : UITableViewCell
@property (nonatomic,strong) ProfileViewModelEmailItem *item;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

+ (UINib *)nib;
+ (NSString *)identifier;

@end
