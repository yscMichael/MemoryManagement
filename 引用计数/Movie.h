//
//  Movie.h
//  引用计数
//
//  Created by 杨世川 on 2018/4/23.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <Foundation/Foundation.h>

//必须遵守NSCoding协议
@interface Movie : NSObject <NSCoding>

@property (nonatomic, copy) NSString *movieId;

@property (nonatomic, copy) NSString *movieName;

@property (nonatomic, copy) NSString *pic_url;

@end
