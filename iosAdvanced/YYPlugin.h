//
//  YYPlugin.h
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/8.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "CDVPlugin.h"

@interface YYPlugin : CDVPlugin

- (void)scan:(CDVInvokedUrlCommand *)command;

- (void)location:(CDVInvokedUrlCommand *)command;

- (void)pay:(CDVInvokedUrlCommand *)command;

- (void)share:(CDVInvokedUrlCommand *)command;

- (void)changeColor:(CDVInvokedUrlCommand *)command;

- (void)shake:(CDVInvokedUrlCommand *)command;

- (void)playSound:(CDVInvokedUrlCommand *)command;

@end
