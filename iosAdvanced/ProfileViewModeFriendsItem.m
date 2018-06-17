//
//  ProfileViewModeFriendsItem.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "ProfileViewModeFriendsItem.h"

@implementation ProfileViewModeFriendsItem
- (instancetype)initWithModel:(ProfileModel *)model
{
    if (self = [super init])
    {
        self.type = friend;
        self.sectionTitle = @"Friends";
        self.rowCount = (int)model.friends.count;
        self.friends = model.friends;
    }
    return self;
}
@end
