//
//  NumberInputCell.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/22.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "NumberInputCell.h"

@implementation NumberInputCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Public Methods
+ (UINib *)nib;
{
    return  [UINib nibWithNibName:self.identifier bundle:nil];
}

+ (NSString *)identifier
{
    return [self description];
}

#pragma mark - Getter And Setter
- (void)setItem:(NumberInputItem *)item
{
    _item = item;
    //这里赋值的时候,直接提取(Model)里面数据
    if ([item.titleString isEqualToString:@"联系方式"])
    {
        //self.item.patientModel.mobile
    }
    else
    {//体重
        //self.item.patientModel.weight
    }
}

//如果当前有输入框或者选择框
//直接将结果赋值给Model(因为Model是强引用(strong)过来的)

@end
