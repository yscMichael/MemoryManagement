//
//  CategoryAttributesController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/18.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "CategoryAttributesController.h"
#import "Person.h"
#import "Person+NewPerson.h"

@interface CategoryAttributesController ()

@end

@implementation CategoryAttributesController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    Person *person = [[Person alloc] init];
    person.name = @"张三";
    person.height = @"172";
    NSLog(@"name = %@,height = %@",person.name,person.height);
}



@end
