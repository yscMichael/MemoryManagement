//
//  Person.h
//  引用计数
//
//  Created by 杨世川 on 2018/3/31.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Animal.h"

@interface Person : NSObject
{
    //定义Person对象持有Animal对象
    Animal* _item;
}

- (void)setItem:(Animal*) item;
- (Animal*)item;

@end
