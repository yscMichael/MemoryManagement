//
//  ViewController.m
//  引用计数
//
//  Created by 杨世川 on 18/3/24.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "ViewController.h"

OBJC_EXTERN int _objc_rootRetainCount(id);

@interface ViewController ()

@end

@implementation ViewController
/**
 ARC下获取引用计数
 1、使用KVC
    [obj valueForKey:@"retainCount"]

 2、使用私有API
   OBJC_EXTERN int _objc_rootRetainCount(id);
   _objc_rootRetainCount(obj)

 3、使用CFGetRetainCount
    CFGetRetainCount((__bridge CFTypeRef)(obj))
 
 */


- (void)viewDidLoad
{
    [super viewDidLoad];

    id obj = [[NSObject alloc]init];
    NSLog(@"retain count = %@",[obj valueForKey:@"retainCount"]);
    NSLog(@"retain count = %d",_objc_rootRetainCount(obj));
    NSLog(@"retain count = %ld",CFGetRetainCount((__bridge CFTypeRef)(obj)));


}


@end
