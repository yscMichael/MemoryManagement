//
//  Attribute.h
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Attribute
@interface Attribute : NSObject
//key
@property (nonatomic ,copy) NSString *key;
//value
@property (nonatomic ,copy) NSString *value;
//对象
+ (Attribute *)jsonToModelWithDict:(NSDictionary *)dict;
@end
