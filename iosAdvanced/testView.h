//
//  testView.h
//  testXib
//
//  Created by 杨世川 on 2018/6/5.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface testView : UIView
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *test;

@end
