//
//  ProfileViewModelAboutItem.h
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileViewModelItem.h"
#import "ProfileModel.h"

@interface ProfileViewModelAboutItem : ProfileViewModelItem
//about
@property (nonatomic ,copy) NSString *about;
- (instancetype)initWithModel:(ProfileModel *)model;
@end
