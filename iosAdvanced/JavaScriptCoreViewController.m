//
//  JavaScriptCoreViewController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/7.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "JavaScriptCoreViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <AVFoundation/AVFoundation.h>

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define BarHeight 20

@interface JavaScriptCoreViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation JavaScriptCoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"UIWebView-JavaScriptCore";
    [self initViews];
}

#pragma mark - 初始化View
- (void)initViews
{
    [self.view addSubview:self.webView];
    //1、获取网页
    //1.1、加载本地html
    NSURL *htmlURL = [[NSBundle mainBundle] URLForResource:@"indexTwo.html" withExtension:nil];
    //1.2、加载网页html
    //NSURL *htmlURL = [NSURL URLWithString:@"http://www.baidu.com"];

    //2、封装NSURLRequest
    NSURLRequest *request = [NSURLRequest requestWithURL:htmlURL];
    //3、加载request
    [self.webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"开始加载");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"加载结束");
    [self addCustomActions];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"加载失败");
}

#pragma mark - private methods
- (void)addCustomActions
{
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //展示数组
    [context evaluateScript:@"var arr = [3, 4, 'abc'];"];

    [self addScanWithContext:context];
    [self addLocationWithContext:context];
    [self addShareWithContext:context];
    [self addSetBGColorWithContext:context];
    [self addPayActionWithContext:context];
    [self addShakeActionWithContext:context];
    [self addGoBackWithContext:context];
}

#pragma mark - 扫一扫
- (void)addScanWithContext:(JSContext *)context
{
    context[@"scan"] = ^() {
        NSLog(@"扫一扫啦");
    };
}

#pragma mark - 定位信息
- (void)addLocationWithContext:(JSContext *)context
{
    context[@"getLocation"] = ^() {
        // 获取位置信息

        // 将结果返回给js
        NSString *jsStr = [NSString stringWithFormat:@"setLocation('%@')",@"广东省深圳市南山区学府路XXXX号"];
        [[JSContext currentContext] evaluateScript:jsStr];
    };
}

#pragma mark - 分享
- (void)addShareWithContext:(JSContext *)context
{
    context[@"share"] = ^() {
        NSArray *args = [JSContext currentArguments];

        if (args.count < 3) {
            return ;
        }

        NSString *title = [args[0] toString];
        NSString *content = [args[1] toString];
        NSString *url = [args[2] toString];
        // 在这里执行分享的操作

        // 将分享结果返回给js
        NSString *jsStr = [NSString stringWithFormat:@"shareResult('%@','%@','%@')",title,content,url];
        [[JSContext currentContext] evaluateScript:jsStr];
    };
}

#pragma mark - 设置颜色
- (void)addSetBGColorWithContext:(JSContext *)context
{
    __weak typeof(self) weakSelf = self;
    context[@"setColor"] = ^() {
        NSArray *args = [JSContext currentArguments];

        if (args.count < 4) {
            return ;
        }

        CGFloat r = [[args[0] toNumber] floatValue];
        CGFloat g = [[args[1] toNumber] floatValue];
        CGFloat b = [[args[2] toNumber] floatValue];
        CGFloat a = [[args[3] toNumber] floatValue];

        weakSelf.view.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
    };
}

#pragma mark - 支付
- (void)addPayActionWithContext:(JSContext *)context
{
    context[@"payAction"] = ^() {
        NSArray *args = [JSContext currentArguments];

        if (args.count < 4) {
            return ;
        }

        NSString *orderNo = [args[0] toString];
        NSString *channel = [args[1] toString];
        long long amount = [[args[2] toNumber] longLongValue];
        NSString *subject = [args[3] toString];

        // 支付操作
        NSLog(@"orderNo:%@---channel:%@---amount:%lld---subject:%@",orderNo,channel,amount,subject);

        // 将支付结果返回给js
        //        NSString *jsStr = [NSString stringWithFormat:@"payResult('%@')",@"支付成功"];
        //        [[JSContext currentContext] evaluateScript:jsStr];
        [[JSContext currentContext][@"payResult"] callWithArguments:@[@"支付成功"]];
    };
}

#pragma mark - 摇一摇
- (void)addShakeActionWithContext:(JSContext *)context
{

    context[@"shake"] = ^() {
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    };
}

#pragma mark - 返回
- (void)addGoBackWithContext:(JSContext *)context
{
    __weak typeof(self) weakSelf = self;
    context[@"goBack"] = ^() {
        [weakSelf.webView goBack];
    };
}

#pragma mark - setter and getter
- (UIWebView *)webView
{
    if (!_webView)
    {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _webView.delegate = self;
        //取消回弹效果
        _webView.scrollView.bounces = NO;
        //正常速度
        _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    }
    return _webView;
}

//总结:
//一、JavaScriptCore简介
//  
//
//
//

@end


