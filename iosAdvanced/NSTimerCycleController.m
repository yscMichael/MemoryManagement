//
//  NSTimerCycleController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/4.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "NSTimerCycleController.h"
#import "EOCClass.h"

@interface NSTimerCycleController ()

@property (nonatomic ,strong) EOCClass *eoc;

@end

@implementation NSTimerCycleController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    EOCClass *eoc = [[EOCClass alloc] init];
    self.eoc = eoc;
    [eoc startPolling];
}

- (void)dealloc
{
    NSLog(@"控制器销毁了");
}

//总结:
//
//
//
//
//
//




@end
