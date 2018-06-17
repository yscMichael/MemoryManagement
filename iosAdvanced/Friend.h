//
//  Friend.h
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject
//姓名
@property (nonatomic ,copy) NSString *name;
//照片
@property (nonatomic ,copy) NSString *pictureUrl;
//对象
+ (Friend *)jsonToModelWithDict:(NSDictionary *)dict;
@end
