//
//  ProfileViewModeAttributeItem.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "ProfileViewModeAttributeItem.h"

@implementation ProfileViewModeAttributeItem
- (instancetype)initWithModel:(ProfileModel *)model
{
    if (self = [super init])
    {
        self.type = attribute;
        self.sectionTitle = @"Attributes";
        self.rowCount = (int)model.profileAttributes.count;
        self.attribute = model.profileAttributes;
    }
    return self;
}
@end
