//
//  NSObject+KVO.h
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/5.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import <Foundation/Foundation.h>

//定义Block
typedef void(^YYObserverBlock) (id observedObject, NSString *observedKey, id oldValue, id newValue);

@interface NSObject (KVO)

- (void)YY_addObserver:(NSObject *)observer
                forKey:(NSString *)key
             withBlock:(YYObserverBlock)block;

- (void)YY_removeObserver:(NSObject *)observer forKey:(NSString *)key;

@end
