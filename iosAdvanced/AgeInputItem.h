//
//  AgeInputItem.h
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/22.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PatientBaseItem.h"
#import "PatientModel.h"

@interface AgeInputItem : PatientBaseItem
//患者模型
@property (nonatomic,strong) PatientModel *patientModel;
//初始化item
- (instancetype)initWithModel:(PatientModel *)model;
@end
