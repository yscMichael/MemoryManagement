//
//  SegmentedViewController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/7/10.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "SegmentedViewController.h"

@interface SegmentedViewController ()

@end

@implementation SegmentedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //先生成存放标题的数据
    NSArray *array = [NSArray arrayWithObjects:@"家具",@"灯饰",@"建材",@"装饰", nil];
    //初始化UISegmentedControl
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
    //设置frame
    segment.frame = CGRectMake(10, 100, self.view.frame.size.width-20, 30);
    //添加到视图
    [self.view addSubview:segment];

    //插入一个分段
    [segment insertSegmentWithTitle:@"五金电料" atIndex:2 animated:NO];
    //修改分段标题
    [segment setTitle:@"巧克力巧克力" forSegmentAtIndex:2];
    //根据内容定分段宽度(此时会挤压其它部分)
    segment.apportionsSegmentWidthsByContent = YES;
    //设定默认选中分段
    segment.selectedSegmentIndex = 2;
    //控件渲染色
    segment.tintColor = [UIColor redColor];

    // 设置指定索引选项的宽度(设置下标为2的分段宽度)(受最大宽度限制,会挤压别人)
    //[segment setWidth:340.0 forSegmentAtIndex:2];
    // 设置分段中标题的位置(0,0点为中心)
    //[segment setContentOffset:CGSizeMake(10,10) forSegmentAtIndex:3];

    [segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];

    //设置边框颜色
    segment.layer.borderColor = [UIColor lightGrayColor].CGColor;//边框颜色
    segment.layer.borderWidth = 1.0;

//    segment.tintColor = [UIColor clearColor];//去掉颜色,现在整个segment都看不见
//    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
//                                             NSForegroundColorAttributeName: [UIColor whiteColor]};
//    [segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
//    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
//                                               NSForegroundColorAttributeName: [UIColor lightTextColor]};
//    [segment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
}

//点击不同分段就会有不同的事件进行相应
-(void)change:(UISegmentedControl *)sender
{
    NSLog(@"测试");
    if (sender.selectedSegmentIndex == 0)
    {
        NSLog(@"1");
    }
    else if (sender.selectedSegmentIndex == 1)
    {
        NSLog(@"2");
    }
    else if (sender.selectedSegmentIndex == 2)
    {
        NSLog(@"3");
    }
    else if (sender.selectedSegmentIndex == 3)
    {
        NSLog(@"4");
    }
}




@end
