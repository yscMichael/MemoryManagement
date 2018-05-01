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

@property (nonatomic ,strong) NSString *firstText;
@property (nonatomic ,strong) UIImage *firstImage;
@property (nonatomic ,strong) UIImage *secondImage;
@property (nonatomic ,strong) UIImage *threeImage;

+(instancetype)xibTableViewCell;

@end
