//
//  OperationAttributesController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "OperationAttributesController.h"

@interface OperationAttributesController ()

@end

@implementation OperationAttributesController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

}

//总结:
//1、取消操作方法
//- (void)cancel; 可取消操作，实质是标记 isCancelled 状态。
//
//2、判断操作状态方法
//- (BOOL)isFinished; 判断操作是否已经结束。
//- (BOOL)isCancelled; 判断操作是否已经标记为取消。
//- (BOOL)isExecuting; 判断操作是否正在在运行。
//- (BOOL)isReady; 判断操作是否处于准备就绪状态，这个值和操作的依赖关系相关。
//
//3、操作同步
//- (void)waitUntilFinished; 阻塞当前线程，直到该操作结束。可用于线程执行顺序的同步。
//- (void)setCompletionBlock:(void (^)(void))block; completionBlock 会在当前操作执行完毕时执行 completionBlock。
//- (void)addDependency:(NSOperation *)op; 添加依赖，使当前操作依赖于操作 op 的完成。
//- (void)removeDependency:(NSOperation *)op; 移除依赖，取消当前操作对操作 op 的依赖。
//@property (readonly, copy) NSArray *dependencies; 在当前操作开始执行之前完成执行的所有操作对象数组。



@end


