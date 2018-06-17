//
//  ProfileViewModelEmailItem.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "ProfileViewModelEmailItem.h"

@implementation ProfileViewModelEmailItem
- (instancetype)initWithModel:(ProfileModel *)model
{
    if (self = [super init])
    {
        self.type = email;
        self.sectionTitle = @"Email";
        self.rowCount = 1;
        self.email = model.email;
    }
    return self;
}
@end
