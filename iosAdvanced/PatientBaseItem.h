//
//  PatientBaseItem.h
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/22.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger , PatientItemType){
    PatientItemTypeName = 0,//姓名
    PatientItemTypeSelectYesOrNo,//性别、孕妇、陪护人
    PatientItemTypeAge,//年龄
    PatientItemTypeNumber,//联系方式、体重
    PatientItemTypeChoosePopView,//过敏史、血型、所在地区
    PatientItemTypeSelectRelationship,//与患者关系
    PatientItemTypeStringInput//所在地区、详细地址
};

@interface PatientBaseItem : NSObject
//类型
@property (nonatomic,assign) PatientItemType type;
//每组标题
@property (nonatomic,strong) NSString *sectionTitle;
//每组多少行
@property (nonatomic,assign) int rowCount;
//每个cell名称
@property (nonatomic,strong) NSString *titleString;

@end




