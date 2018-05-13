//
//  MessageHandlerController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/7.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "MessageHandlerController.h"
#import <AVFoundation/AVFoundation.h>
#import "YYAudioPlayer.h"
#import <WebKit/WebKit.h>

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define BarHeight 20

@interface MessageHandlerController ()<WKUIDelegate,WKScriptMessageHandler>

@property (strong, nonatomic) WKWebView  *wkWebView;
@property (strong, nonatomic) UIProgressView  *progressView;

@end

@implementation MessageHandlerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"MessageHandler";
    [self initViews];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //addScriptMessageHandler很容易导致循环引用
    //self➡️WKWebView➡️configuration➡️userContentController
    //  ⬆️                                         ⬇️
    //  |-------------------⬅️--------------------|

    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"ScanAction"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"Location"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"Share"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"Color"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"Pay"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"Shake"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"GoBack"];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"PlaySound"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.view.backgroundColor = [UIColor whiteColor];

    // 因此这里要记得移除handlers
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"ScanAction"];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"Location"];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"Share"];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"Color"];
    [self.wkWebView.configuration.userContentController
        removeScriptMessageHandlerForName:@"Pay"];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"Shake"];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"GoBack"];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"PlaySound"];
}

#pragma mark - initView
- (void)initViews
{
    //NSString *urlStr = @"http://www.baidu.com";
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    //[self.wkWebView loadRequest:request];

    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"indexThree.html" ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:urlStr];
    [self.wkWebView loadFileURL:fileURL allowingReadAccessToURL:fileURL];

    self.wkWebView.UIDelegate = self;
    [self.view addSubview:self.wkWebView];
    [self.view addSubview:self.progressView];
}

#pragma mark - KVO监听进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"])
    {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1)
        {
            [self.progressView setProgress:1.0 animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            });
        }
        else
        {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //message.body: NSNumber,NSString,NSDate,NSArray,NSDictionary,NSNull
    NSLog(@"message.name:%@",message.name);
    NSLog(@"message.body:%@",message.body);
    if ([message.name isEqualToString:@"ScanAction"])
    {
        NSLog(@"扫一扫");
    }
    else if ([message.name isEqualToString:@"Location"])
    {
        [self getLocation];
    }
    else if ([message.name isEqualToString:@"Share"])
    {
        [self shareWithParams:message.body];
    }
    else if ([message.name isEqualToString:@"Color"])
    {
        [self changeBGColor:message.body];
    }
    else if ([message.name isEqualToString:@"Pay"])
    {
        [self payWithParams:message.body];
    }
    else if ([message.name isEqualToString:@"Shake"])
    {
        [self shakeAction];
    }
    else if ([message.name isEqualToString:@"GoBack"])
    {
        [self goBack];
    }
    else if ([message.name isEqualToString:@"PlaySound"])
    {
        [self playSound:message.body];
    }
}

#pragma mark - private method
- (void)getLocation
{
    // 获取位置信息
    // 将结果返回给js
    NSString *jsStr = [NSString stringWithFormat:@"setLocation('%@')",@"广东省深圳市南山区学府路XXXX号"];
    [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@----%@",result, error);
    }];

    NSString *jsStr2 = @"window.ctuapp_share_img";
    [self.wkWebView evaluateJavaScript:jsStr2 completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@----%@",result, error);
    }];
}

- (void)changeBGColor:(NSArray *)params
{
    if (![params isKindOfClass:[NSArray class]])
    {
        return;
    }

    if (params.count < 4)
    {
        return;
    }

    CGFloat r = [params[0] floatValue];
    CGFloat g = [params[1] floatValue];
    CGFloat b = [params[2] floatValue];
    CGFloat a = [params[3] floatValue];

    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a];
}

- (void)shareWithParams:(NSDictionary *)tempDic
{
    if (![tempDic isKindOfClass:[NSDictionary class]])
    {
        return;
    }

    NSString *title = [tempDic objectForKey:@"title"];
    NSString *content = [tempDic objectForKey:@"content"];
    NSString *url = [tempDic objectForKey:@"url"];
    // 在这里执行分享的操作

    // 将分享结果返回给js
    NSString *jsStr = [NSString stringWithFormat:@"shareResult('%@','%@','%@')",title,content,url];
    [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@----%@",result, error);
    }];
}

- (void)payWithParams:(NSDictionary *)tempDic
{
    if (![tempDic isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    NSString *orderNo = [tempDic objectForKey:@"order_no"];
    long long amount = [[tempDic objectForKey:@"amount"] longLongValue];
    NSString *subject = [tempDic objectForKey:@"subject"];
    NSString *channel = [tempDic objectForKey:@"channel"];
    NSLog(@"%@---%lld---%@---%@",orderNo,amount,subject,channel);

    //支付操作

    //将支付结果返回给js
    NSString *jsStr = [NSString stringWithFormat:@"payResult('%@')",@"支付成功"];
    [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@----%@",result, error);
    }];
}

- (void)shakeAction
{
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    [YYAudioPlayer playMusic:@"shake_sound_male.wav"];
}

- (void)playSound:(NSString *)fileName
{
    if (![fileName isKindOfClass:[NSString class]])
    {
        return;
    }

    [YYAudioPlayer playMusic:fileName];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - setter and getter
- (WKWebView *)wkWebView
{
    if (!_wkWebView)
    {
        //偏好设置
        WKPreferences *preferences = [[WKPreferences alloc] init];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.minimumFontSize = 30.0;

        //配置信息
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = [[WKUserContentController alloc] init];
        configuration.preferences = preferences;

        //初始化
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) configuration:configuration];
        //取消回弹效果
        _wkWebView.scrollView.bounces = NO;
        //正常速度
        _wkWebView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    }
    return _wkWebView;
}

- (UIProgressView *)progressView
{
    if (!_progressView)
    {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 4)];
        _progressView.tintColor = [UIColor redColor];
        _progressView.trackTintColor = [UIColor blueColor];
    }
    return _progressView;
}

//总结:
//1、MessageHandler简介
//
//  WKWebView初始化时,有一个参数叫configuration,它是WKWebViewConfiguration类型的参数,
//  而WKWebViewConfiguration有一个属性叫userContentController,
//  它又是WKUserContentController类型的参数.
//  WKUserContentController对象有一个方法: addScriptMessageHandler:name:
//
//2、addScriptMessageHandler:name参数介绍
//
//   2.1、
//   [self.wkWebView.configuration.userContentController
//   addScriptMessageHandler:self name:@"ScanAction"];
//   第一个参数是userContentController的代理对象,第二个参数是JS里发送postMessage的对象
//
//   2.2、
//   window.webkit.messageHandlers.ScanAction.postMessage(null);
//   window.webkit.messageHandlers.<name>.postMessage(<messageBody>)
//   备注:
//     a、其中<name>,就是上面方法里的第二个参数'name'
//     b、<messageBody>是一个键值对,键是body,值可以有多种类型的参数
//     c、在'WKScriptMessageHandler'协议中,我们可以看到mssage是'WKScriptMessage'类型,
//        有一个属性叫body.
//     d、而注释里写明了body的类型:
//        NSNumber,NSString,NSDate,NSArray,NSDictionary,NSNull
//

@end


