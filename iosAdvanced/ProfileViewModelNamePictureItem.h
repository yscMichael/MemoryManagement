//
//  ProfileViewModelNamePictureItem.h
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileViewModelItem.h"
#import "ProfileModel.h"

#pragma mark - Item<姓名和图片>
@interface ProfileViewModelNamePictureItem : ProfileViewModelItem
//姓名
@property (nonatomic ,copy) NSString *name;
//图片
@property (nonatomic ,copy) NSString *pictureUrl;
- (instancetype)initWithModel:(ProfileModel *)model;
@end
