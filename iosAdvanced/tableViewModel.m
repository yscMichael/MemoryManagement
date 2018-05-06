//
//  tableViewModel.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/6.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "tableViewModel.h"

@implementation tableViewModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.name = @"模型";
        self.modelArray = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    }
    return self;
}

@end
