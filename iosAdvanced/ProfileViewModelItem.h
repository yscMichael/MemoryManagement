//
//  ProfileViewModelItem.h
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger , ProfileViewModelItemType){
    nameAndPicture,
    about,
    email,
    friend,
    attribute
};

#pragma mark - Item的基类
@interface ProfileViewModelItem : NSObject
//类型
@property (nonatomic,assign) ProfileViewModelItemType type;
//每组标题
@property (nonatomic,strong) NSString *sectionTitle;
//每组多少行
@property (nonatomic,assign) int rowCount;
@end
