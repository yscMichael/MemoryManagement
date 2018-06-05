//
//  XibViewShowController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/5.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "XibViewShowController.h"
#import "testView.h"

@interface XibViewShowController ()

@property (nonatomic , strong) testView *testView;

@end

@implementation XibViewShowController
#pragma mark - Cycle Life
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.testView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGRect frame = self.testView.frame;
    frame.size.width = ScreenWidth;
    frame.origin.y = 64;
    self.testView.frame = frame;
    self.testView.backgroundColor = [UIColor redColor];
    self.testView.leftLabel.text = @"111111111111111111111111111";
    self.testView.rightLabel.text = @"222222222222222222222222222";
}

//总结：
//1、加载xib方法loadNibNamed
//2、加载顺序
//   viewDidLoad➡️initWithCoder➡️awakeFromNib➡️layoutSubviews
//   ➡️viewDidAppear➡️layoutSubviews
//3、设置子控件在父控件中的宽高比例
//4、不会调用initWithFrame
//5、使用init会调用initWithFrame,而使用initWithFrame不会调用init

#pragma mark - Getter And Setter
- (testView *)testView
{
    if(!_testView)
    {
        NSArray *newArray = [[NSBundle mainBundle] loadNibNamed:@"testView" owner:nil options:nil];
        _testView = [newArray lastObject];
    }
    return _testView;
}

@end


