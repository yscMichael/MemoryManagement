//
//  ProfileModel.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/16.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "ProfileModel.h"
#import "Friend.h"
#import "Attribute.h"

@interface ProfileModel ()

@end

@implementation ProfileModel
+ (ProfileModel *)jsonToModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        [self jsonToModel:dict];
    }
    return self;
}

- (void)jsonToModel:(NSDictionary *)dict
{
    NSDictionary *data = dict[@"data"];
    self.fullName = data[@"fullName"];
    self.pictureUrl = data[@"pictureUrl"];
    self.email = data[@"email"];
    self.about = data[@"about"];

    NSArray *friendsArray = data[@"friends"];
    for (NSDictionary *dict in friendsArray)
    {
        Friend *friend = [Friend jsonToModelWithDict:dict];
        [self.friends addObject:friend];
    }
    NSArray *attributesArray = data[@"profileAttributes"];
    for (NSDictionary *dict in attributesArray)
    {
        Attribute *attribute = [Attribute jsonToModelWithDict:dict];
        [self.profileAttributes addObject:attribute];
    }
}

#pragma mark - Getter And Setter
- (NSMutableArray *)friends
{
    if (!_friends)
    {
        _friends = [[NSMutableArray alloc] init];
    }
    return _friends;
}

- (NSMutableArray *)profileAttributes
{
    if (!_profileAttributes)
    {
        _profileAttributes = [[NSMutableArray alloc] init];
    }
    return _profileAttributes;
}
@end

