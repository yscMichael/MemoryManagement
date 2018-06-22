//
//  PatientViewModel.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/22.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "PatientViewModel.h"

#import "NameItem.h"
#import "SelectYesOrNoItem.h"
#import "AgeInputItem.h"
#import "NumberInputItem.h"
#import "ChoosePopViewItem.h"
#import "SelectRelationshipItem.h"
#import "StringInputItem.h"


@implementation PatientViewModel

//处理模型
- (void)dealItemWithPatientModel:(PatientModel *)patientModel Success:(void(^)(NSArray<PatientBaseItem *> *result))success
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    //姓名
    NameItem *nameItem = [[NameItem alloc] initWithModel:patientModel];
    nameItem.titleString = @"姓名";
    [dataArray addObject:nameItem];
    //性别
    SelectYesOrNoItem *selectItem = [[SelectYesOrNoItem alloc] initWithModel:patientModel];
    selectItem.titleString = @"性别";
    [dataArray addObject:selectItem];
    //是否为孕妇<非必选项>
    if ([patientModel.gender isKindOfClass:[NSDictionary class]] && [patientModel.gender[@"key_name"] isEqualToString:@"女"])
    {
        SelectYesOrNoItem *selectItem = [[SelectYesOrNoItem alloc] initWithModel:patientModel];
        selectItem.titleString = @"是否为孕妇";
        [dataArray addObject:selectItem];
    }
    //年龄
    AgeInputItem *ageItem = [[AgeInputItem alloc] initWithModel:patientModel];
    ageItem.titleString = @"年龄";
    [dataArray addObject:ageItem];
    //联系方式
    NumberInputItem *mobileItem = [[NumberInputItem alloc] initWithModel:patientModel];
    mobileItem.titleString = @"联系方式";
    [dataArray addObject:mobileItem];
    //体重
    NumberInputItem *weightItem = [[NumberInputItem alloc] initWithModel:patientModel];
    weightItem.titleString = @"体重";
    [dataArray addObject:weightItem];
    //过敏史
    ChoosePopViewItem *allergicItem = [[ChoosePopViewItem alloc] initWithModel:patientModel];
    allergicItem.titleString = @"过敏史";
    [dataArray addObject:allergicItem];
    //是否填写陪护人信息
    SelectYesOrNoItem *selectRelationshipItem = [[SelectYesOrNoItem alloc] initWithModel:patientModel];
    selectRelationshipItem.titleString = @"是否填写陪护人信息";
    [dataArray addObject:selectRelationshipItem];
    //陪护人联系方式<非必选项>
    if ([patientModel.is_relationship isKindOfClass:[NSDictionary class]] && [patientModel.is_relationship[@"key_name"] isEqualToString:@"是"])
    {
        NumberInputItem *numberItem = [[NumberInputItem alloc] initWithModel:patientModel];
        numberItem.titleString = @"陪护人联系方式";
        [dataArray addObject:numberItem];
    }
    //与患者关系<非必选项>
    if ([patientModel.is_relationship isKindOfClass:[NSDictionary class]] && [patientModel.is_relationship[@"key_name"] isEqualToString:@"是"])
    {
        SelectRelationshipItem *relationshipItem = [[SelectRelationshipItem alloc] initWithModel:patientModel];
        relationshipItem.titleString = @"与患者关系";
        [dataArray addObject:relationshipItem];
    }
    //血型
    ChoosePopViewItem *bloodItem = [[ChoosePopViewItem alloc] initWithModel:patientModel];
    bloodItem.titleString = @"血型";
    [dataArray addObject:bloodItem];
    //所在地区
    ChoosePopViewItem *regionItem = [[ChoosePopViewItem alloc] initWithModel:patientModel];
    regionItem.titleString = @"所在地区";
    [dataArray addObject:regionItem];
    //详细地址
    StringInputItem *addressItem = [[StringInputItem alloc] initWithModel:patientModel];
    addressItem.titleString = @"详细地址";
    [dataArray addObject:addressItem];
    //备注
    StringInputItem *remarkItem = [[StringInputItem alloc] initWithModel:patientModel];
    remarkItem.titleString = @"备注";
    [dataArray addObject:remarkItem];
}

@end
