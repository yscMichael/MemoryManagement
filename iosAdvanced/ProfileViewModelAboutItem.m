//
//  ProfileViewModelAboutItem.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "ProfileViewModelAboutItem.h"

@implementation ProfileViewModelAboutItem
- (instancetype)initWithModel:(ProfileModel *)model
{
    if (self = [super init])
    {
        self.type = about;
        self.sectionTitle = @"About";
        self.rowCount = 1;
        self.about = model.about;
    }
    return self;
}
@end
