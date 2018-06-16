//
//  ProfileModel.h
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/16.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileModel : NSObject
@property (nonatomic ,copy) NSString  *fullName;
@property (nonatomic ,copy) NSString *pictureUrl;
@property (nonatomic ,copy) NSString *email;
@property (nonatomic ,copy) NSString *about;
@property (nonatomic ,strong) NSMutableArray *friends;
@property (nonatomic,strong) NSMutableArray *profileAttributes;

+ (ProfileModel *)jsonToModelWithDict:(NSDictionary *)dict;
@end
