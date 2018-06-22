//
//  ChoosePopViewItem.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/22.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "ChoosePopViewItem.h"

@implementation ChoosePopViewItem

//初始化item
- (instancetype)initWithModel:(PatientModel *)model
{
    self = [super init];
    if (self)
    {
        self.type = PatientItemTypeChoosePopView;
        self.sectionTitle = @"";
        self.rowCount = 1;
        self.patientModel = model;
    }
    return self;
}

- (void)setPatientModel:(PatientModel *)patientModel
{
    _patientModel = patientModel;
}

@end
