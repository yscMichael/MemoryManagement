//
//  PatientModel.h
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/22.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatientModel : NSObject
//是否有监护人
@property (nonatomic ,copy) NSString *hasCaregiver;
//患者id
@property (nonatomic, strong) NSString *patientId;
//患者姓名
@property (nonatomic, strong) NSString *key_name;
//诊所id
@property (nonatomic, strong) NSDictionary *clinic_id;
//性别
@property (nonatomic, strong) NSMutableDictionary *gender;
//是否是孕妇
@property (nonatomic, strong) NSMutableDictionary *is_pregnant;
//生日
@property (nonatomic, strong) NSString *birthday;
//月
@property (nonatomic, strong) NSString *month;
//手机号码
@property (nonatomic, strong) NSString *mobile;
//体重
@property (nonatomic, strong) NSString *weight;
//省份
@property (nonatomic, strong) NSMutableDictionary *province;
//城市
@property (nonatomic, strong) NSMutableDictionary *city;
//区域
@property (nonatomic, strong) NSMutableDictionary *district;
//所在地区(暂时没有用到)
@property (nonatomic, strong) NSString *region;
//详细地址
@property (nonatomic, strong) NSString *address;
//上次访问时间
@property (nonatomic, strong) NSString *last_visit_time;
//是否有监护人
@property (nonatomic, strong) NSMutableDictionary *is_relationship;
//与监护人关系
@property (nonatomic, strong) NSMutableDictionary *relationship;
//监护人姓名
@property (nonatomic, strong) NSString *caregiver_name;
//监护人电话号码
@property (nonatomic, strong) NSString *caregiver_mobile;
//血型
@property (nonatomic, strong) NSMutableDictionary *blood_type;
//过敏史
@property (nonatomic, strong) NSArray *patient_allergic;
//备注
@property (nonatomic, strong) NSString *remark;
//消费金额
@property (nonatomic, assign) float consume_amount;
//欠款金额
@property (nonatomic, assign) float debt_amount;
//访问次数
@property (nonatomic, strong) NSString *visit_count;
//创建时间
@property (nonatomic, strong) NSString *create_time;
//创建实体
@property (nonatomic, strong) NSMutableDictionary *create_entity;
//更改实体
@property (nonatomic, strong) NSMutableDictionary *modify_entity;
//暂时没有用到
@property (nonatomic, strong) NSString *subcompany_id;
//年龄
@property (nonatomic, strong) NSString *age;
//民族
@property (nonatomic, strong) NSString *national;

@end
