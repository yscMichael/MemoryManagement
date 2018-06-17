//
//  ProfileViewModeAttributeItem.h
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileViewModelItem.h"
#import "ProfileModel.h"

#pragma mark - Item<Attribute>
@interface ProfileViewModeAttributeItem : ProfileViewModelItem
//attribute
@property (nonatomic,strong) NSArray *attribute;
- (instancetype)initWithModel:(ProfileModel *)model;
@end
