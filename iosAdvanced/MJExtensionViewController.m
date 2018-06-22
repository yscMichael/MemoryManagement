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
    //[self testNull];
    //[self testCopyModel];
    //[self testSubstringToIndex];

    UIFont *font = [UIFont systemFontOfSize:12.0];
    NSLog(@"font.name = %@",font.familyName);

    NSArray *familyNames = [UIFont familyNames];
    for( NSString *familyName in familyNames )
    {
        NSLog(@"Family: %@",familyName);
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for( NSString *fontName in fontNames )
        {
            NSLog(@"Font: %@",fontName);
        }
    }

    //总结:
    //1、systemFontOfSize:默认字体是font.name = .SF UI Text
    //2、
}

#pragma mark - 测试substringToIndex
- (void)testSubstringToIndex
{
    NSString *string = @"0123456789";
    NSString *tempString = [string substringToIndex:0];
    NSLog(@"tempString = %@",tempString);
    //总结:使用substringToIndex时, 没有0的概念,不包含ToIndex后面的数
}

#pragma mark - 测试拷贝模型
- (void)testCopyModel
{
    TestModel *testOne = [[TestModel alloc] init];
    testOne.name = @"nameOne";
    testOne.modelId = 1;
    testOne.province = @{@"id":[NSNumber numberWithInt:1],
                         @"key_name":@"nanjing"
                         };
    [testOne.area setValue:@"1111111" forKey:@"area"];


    TestModel *testTwo = [testOne mutableCopy];
    testTwo.name = @"nameTwo";
    testTwo.modelId = 2;
    testTwo.province = @{@"id":[NSNumber numberWithInt:2],
                         @"key_name":@"beijing"
                         };
    [testTwo.area setValue:@"2222222" forKey:@"area"];


    NSLog(@"testOne.name = %@",testOne.name);
    NSLog(@"testOne.modelId = %d",testOne.modelId);
    NSLog(@"testOne.province = %@",testOne.province);
    NSLog(@"testOne.area = %@",testOne.area);


    NSLog(@"testTwo.name = %@",testTwo.name);
    NSLog(@"testTwo.modelId = %d",testTwo.modelId);
    NSLog(@"testTwo.province = %@",testTwo.province);
    NSLog(@"testTwo.area = %@",testTwo.area);


    testOne = [testTwo mutableCopy];

    NSLog(@"testOne.name = %@",testOne.name);
    NSLog(@"testOne.modelId = %d",testOne.modelId);
    NSLog(@"testOne.province = %@",testOne.province);
    NSLog(@"testOne.area = %@",testOne.area);
}

#pragma mark - 测试null
- (void)testNull
{

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

//总结
// nil ---- (null)

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
