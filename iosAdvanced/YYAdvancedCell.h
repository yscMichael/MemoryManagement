//
//  YYCell.h
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/1.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYAdvancedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *firstIView;
@property (weak, nonatomic) IBOutlet UIImageView *secondIView;
@property (weak, nonatomic) IBOutlet UIImageView *threeIView;

+(instancetype)xibTableViewCell;

@end
