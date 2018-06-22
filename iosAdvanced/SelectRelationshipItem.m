//
//  SelectRelationshipItem.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/22.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "SelectRelationshipItem.h"

@implementation SelectRelationshipItem

//初始化item
- (instancetype)initWithModel:(PatientModel *)model
{
    self = [super init];
    if (self)
    {
        self.type = PatientItemTypeSelectRelationship;
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
