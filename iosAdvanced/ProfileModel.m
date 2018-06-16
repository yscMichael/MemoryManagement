//
//  ProfileModel.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/16.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "ProfileModel.h"

#pragma mark - Friend
@interface Friend : NSObject
//姓名
@property (nonatomic ,copy) NSString *name;
//照片
@property (nonatomic ,copy) NSString *pictureUrl;
//对象
+ (Friend *)jsonToModelWithDict:(NSDictionary *)dict;
@end

@implementation Friend
+ (Friend *)jsonToModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end

#pragma mark - Attribute
@interface Attribute : NSObject
//key
@property (nonatomic ,copy) NSString *key;
//value
@property (nonatomic ,copy) NSString *value;
//对象
+ (Attribute *)jsonToModelWithDict:(NSDictionary *)dict;
@end

@implementation Attribute
+ (Attribute *)jsonToModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end

#pragma mark - ProfileModel
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
        [self.friends addObject:attribute];
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

