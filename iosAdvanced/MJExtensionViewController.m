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
    //[self testMJ];
    //[self testNil];

    NSDictionary *temp = @{@"id":[NSNumber numberWithInt:1],
                           @"key_name":@"女"
                           };
//    NSLog(@"temp = %@",temp);
//    //执行错误
//    [temp setValue:[NSNumber numberWithInt:2] forKey:@"id"];
//    NSLog(@"temp = %@",temp);

    //NSDictionary不能执行setValue:forKey:
    NSMutableDictionary *tempTwo = [[NSMutableDictionary alloc] initWithDictionary:temp];
    NSLog(@"tempTwo = %@",tempTwo);
    //执行错误
    [tempTwo setValue:[NSNumber numberWithInt:2] forKey:@"id"];
    NSLog(@"tempTwo = %@",tempTwo);
}

#pragma mark - 测试MJ
- (void)testMJ
{
    NSDictionary *tempDict = @{@"key_name":@"韩信",
                               @"id":@1166,
                               @"age":@5,
                               @"gender":@{@"id":@1,
                                           @"key_name":@"男"
                                           },
                               @"blood_type":@{@"id":@4,
                                               @"key_name":@"O型"
                                               },
                               @"province":@{@"id":@1,
                                             @"key_name":@"北京市"
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
    //模型直接是字典
    NSLog(@"province = %@",testModel.province);
    NSLog(@"provinceId = %@",[testModel.province objectForKey:@"id"]);
    NSLog(@"provincekey_name = %@",[testModel.province objectForKey:@"key_name"]);
}

#pragma mark - 测试nil是否崩溃
- (void)testNil
{
    //    不会崩溃
    //    NSString *string = nil;
    //    NSLog(@"string = %@",string);//(null)

    //    会崩溃
    //    NSString *string = [NSNull null];
    //    NSLog(@"string = %@",string);//<null>

    //不会崩溃
    NSString *string;
    NSLog(@"string = %@",string);//(null)

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 200, 30)];
    label.backgroundColor = [UIColor blueColor];
    label.textColor = [UIColor whiteColor];
    label.text = string;
    [self.view addSubview:label];
}



@end
