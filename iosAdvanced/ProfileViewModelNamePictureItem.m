//
//  ProfileViewModelNamePictureItem.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "ProfileViewModelNamePictureItem.h"
#import "ProfileModel.h"

@implementation ProfileViewModelNamePictureItem
- (instancetype)initWithModel:(ProfileModel *)model
{
    if (self = [super init])
    {
        self.type = nameAndPicture;
        self.sectionTitle = @"Main Info";
        self.rowCount = 1;
        self.name = model.fullName;
        self.pictureUrl = model.pictureUrl;
    }
    return self;
}
@end
