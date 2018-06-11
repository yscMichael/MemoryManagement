//
//  MJExtensionViewController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/11.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "MJExtensionViewController.h"
#import "MJExtension.h"
#import "TestModel.h"

@interface MJExtensionViewController ()

@end

@implementation MJExtensionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    NSDictionary *tempDict = @{@"key_name":@"韩信",
                               @"id":@1166,
                               @"age":@5,
                               @"gender":@{@"id":@1,
                                           @"key_name":@"男"
                                           },
                               @"blood_type":@{@"id":@4,
                                               @"key_name":@"O型"
                                              }
                               };

    [TestModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"name":@"key_name",
                 @"modelId":@"id",
                 @"sex":@"gender.key_name",
                 @"bloodType":@"blood_type.key_name",
                 @"birthday" :@"birthday.key_name"
                };
    }];

    TestModel *testModel = [TestModel mj_objectWithKeyValues:tempDict];
    NSLog(@"name = %@",testModel.name);
    NSLog(@"modelId = %d",testModel.modelId);
    NSLog(@"age = %d",testModel.age);
    NSLog(@"sex = %@",testModel.sex);
    NSLog(@"bloodType = %@",testModel.bloodType);
    //字典中不包含model的属性,结果为(null)
    NSLog(@"tempString = %@",testModel.tempString);//(null)
    //字典中不包含,规则中有,结果为(null),也不崩溃
    NSLog(@"birthday = %@",testModel.birthday);
}



@end
