//
//  ProfileViewModeFriendsItem.h
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileViewModelItem.h"
#import "ProfileModel.h"

#pragma mark - Item<Friends>
@interface ProfileViewModeFriendsItem : ProfileViewModelItem
//friends
@property (nonatomic,strong) NSArray *friends;
- (instancetype)initWithModel:(ProfileModel *)model;
@end
