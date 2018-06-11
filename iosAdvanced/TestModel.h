//
//  TestModel.h
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/11.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestModel : NSObject

//姓名
@property (nonatomic ,copy) NSString *name;
//id
@property (nonatomic ,assign) int modelId;
//年龄
@property (nonatomic ,assign) int age;
//性别
@property (nonatomic ,copy) NSString *sex;
//血型
@property (nonatomic ,copy) NSString *bloodType;
//出生日期
@property (nonatomic ,copy) NSString *birthday;
//尝试
@property (nonatomic ,copy) NSString *tempString;


@end
