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
@property (nonatomic , strong) UITextView *textView;
@property (nonatomic , strong) UILabel *textLabel;

@end

@implementation XibViewShowController
#pragma mark - Cycle Life
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.testView];

//    [self.view addSubview:self.textView];
    self.textView.text = @"在UI开发中，纯代码和Interface Builder我都是用过的，在开发过程中也积累了一些经验。对于初学者学习纯代码AutoLayout，我建议还是先学会Interface Builder方式的AutoLayout，领悟苹果对自动布局的规则和思想，然后再把这套思想嵌套在纯代码上。这样学习起来更好入手，也可以避免踩好多坑。在UI开发中，纯代码和Interface Builder我都是用过的，在开发过程中也积累了一些经验。对于初学者学习纯代码AutoLayout，我建议还是先学会Interface Builder方式的AutoLayout，领悟苹果对自动布局的规则和思想，然后再把这套思想嵌套在纯代码上。这样学习起来更好入手，也可以避免踩好多坑。";

    [self.view addSubview:self.textLabel];
    self.textLabel.text = @"在UI开发中，纯代码和Interface Builder我都是用过的，在开发过程中也积累了一些经验。对于初学者学习纯代码AutoLayout，我建议还是先学会Interface Builder方式的AutoLayout，领悟苹果对自动布局的规则和思想，然后再把这套思想嵌套在纯代码上。这样学习起来更好入手，也可以避免踩好多坑。在UI开发中，纯代码和Interface Builder我都是用过的，在开发过程中也积累了一些经验。对于初学者学习纯代码AutoLayout，我建议还是先学会Interface Builder方式的AutoLayout，领悟苹果对自动布局的规则和思想，然后再把这套思想嵌套在纯代码上。这样学习起来更好入手，也可以避免踩好多坑。";
    self.textLabel.numberOfLines = 0;
    [self.textLabel sizeToFit];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    CGRect frame = self.testView.frame;
//    frame.size.width = ScreenWidth;
//    frame.origin.y = 64;
//    self.testView.frame = frame;
//    self.testView.backgroundColor = [UIColor redColor];
//    self.testView.leftLabel.text = @"111111111111111111111111111";
//    self.testView.rightLabel.text = @"222222222222222222222222222";
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

- (UITextView *)textView
{
    if (!_textView)
    {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 100)];
        _textView.layer.borderColor = [UIColor redColor].CGColor;
        _textView.layer.borderWidth = 1.0;
    }
    return _textView;
}

- (UILabel *)textLabel
{
    if (!_textLabel)
    {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, ScreenWidth, 100)];
        _textLabel.layer.borderColor = [UIColor blueColor].CGColor;
        _textLabel.layer.borderWidth = 1.0;
    }
    return _textLabel;
}

@end


