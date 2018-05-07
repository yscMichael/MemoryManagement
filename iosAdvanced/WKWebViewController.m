//
//  WKWebViewController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/7.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
#import <AVFoundation/AVFoundation.h>

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define BarHeight 20

@interface WKWebViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (strong, nonatomic) WKWebView *wkWebView;
@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation WKWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"WKWebView拦截URL";
    [self initViews];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - initView
- (void)initViews
{
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"index.html" ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:urlStr];
    [self.wkWebView loadFileURL:fileURL allowingReadAccessToURL:fileURL];

    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
    [self.view addSubview:self.wkWebView];

    [self.view addSubview:self.progressView];
}

#pragma mark - WKNavigationDelegate
//页面跳转代理方法(三个)
//在发送请求之前,决定是否跳转的代理
//预加载
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"WKNavigationDelegate---预加载页面");
    NSURL *URL = navigationAction.request.URL;
    NSLog(@"URL = %@",URL);
    NSString *scheme = [URL scheme];
    NSLog(@"scheme = %@",scheme);
    if ([scheme isEqualToString:@"haleyaction"])
    {
        [self handleCustomAction:URL];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

//页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"准备加载页面");
}

//当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"开始加载页面");
}

//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"页面加载完成");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"页面加载失败");
}

//页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"页面加载失败了");
}

//接收到服务器跳转请求之后调用
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
//{
//
//}

//在收到响应后,决定是否跳转的代理
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
//{
//
//}

//其余方法之一
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
//{
//
//}

//其余方法之二
//- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
//{
//
//}

#pragma mark - WKUIDelegate
//警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"弹出警告框");
    NSLog(@"message = %@",message);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}

//创建一个新的WebView
//- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
//{
//
//}

//输入框
//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
//{
//
//}

//确认框
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
//{
//
//}

//关闭
//- (void)webViewDidClose:(WKWebView *)webView
//{
//    NSLog(@"webView关闭");
//}

//- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo
//{
//
//}

//- (UIViewController *)webView:(WKWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id<WKPreviewActionItem>> *)previewActions
//{
//
//}

//- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController
//{
//
//}

#pragma mark - KVO监听方法
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

#pragma mark - Private Methods
#pragma mark - private method
- (void)handleCustomAction:(NSURL *)URL
{
    NSString *host = [URL host];
    NSLog(@"host = %@",host);
    if ([host isEqualToString:@"scanClick"])
    {
        [self scanQCode];
    }
    else if ([host isEqualToString:@"getLocation"])
    {
        [self getLocationOC];
    }
    else if ([host isEqualToString:@"setColor"])
    {
        [self changeBGColor:URL];
    }
    else if ([host isEqualToString:@"shareClick"])
    {
        [self share:URL];
    }
    else if ([host isEqualToString:@"payAction"])
    {
        [self payAction:URL];
    }
    else if ([host isEqualToString:@"shake"])
    {
        [self shakeAction];
    }
    else if ([host isEqualToString:@"back"])
    {
        [self goBack];
    }
}

#pragma mark - 扫一扫
//haleyAction://scanClick
- (void)scanQCode
{
    NSLog(@"扫一扫");
}

#pragma mark - 获取位置信息
//haleyAction://getLocation
- (void)getLocationOC
{
    //将结果返回给js
    //这里调用js的函数,并传递参数
    NSString *jsStr = [NSString stringWithFormat:@"setLocation('%@')",@"广东省深圳市南山区学府路XXXX号"];
    [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"result = %@",result);
        NSLog(@"error = %@",error);
    }];
}

#pragma mark - 更改背景颜色
//haleyAction://setColor?r=67&g=205&b=128&a=0.5
- (void)changeBGColor:(NSURL *)URL
{
    NSLog(@"URL = %@",URL);
    NSArray *params =[URL.query componentsSeparatedByString:@"&"];

    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSString *paramStr in params)
    {
        NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
        if (dicArray.count > 1)
        {
            NSString *decodeValue = [dicArray[1] stringByRemovingPercentEncoding];
            [tempDic setObject:decodeValue forKey:dicArray[0]];
        }
    }
    CGFloat r = [[tempDic objectForKey:@"r"] floatValue];
    CGFloat g = [[tempDic objectForKey:@"g"] floatValue];
    CGFloat b = [[tempDic objectForKey:@"b"] floatValue];
    CGFloat a = [[tempDic objectForKey:@"a"] floatValue];

    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a];
}

#pragma mark - 分享
//haleyAction://shareClick?title=测试分享的标题&content=测试分享的内容&url=http://www.baidu.com
- (void)share:(NSURL *)URL
{
    NSArray *params =[URL.query componentsSeparatedByString:@"&"];

    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSString *paramStr in params)
    {
        NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
        if (dicArray.count > 1)
        {
            NSString *decodeValue = [dicArray[1] stringByRemovingPercentEncoding];
            [tempDic setObject:decodeValue forKey:dicArray[0]];
        }
    }
    NSString *title = [tempDic objectForKey:@"title"];
    NSString *content = [tempDic objectForKey:@"content"];
    NSString *url = [tempDic objectForKey:@"url"];

    //在这里执行分享的操作
    NSArray *items = @[title,content,url];
    UIActivityViewController *activityController=[[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    activityController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    //分享之后的回调
    activityController.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed)
        {
            NSLog(@"completed");
            //将分享结果返回给js
            NSString *jsStr = [NSString stringWithFormat:@"shareResult('%@','%@','%@')",title,content,url];
            [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                NSLog(@"%@----%@",result, error);
            }];
        }
        else
        {
            NSLog(@"cancled");
        }
    };

    [self.navigationController presentViewController:activityController animated:YES completion:nil];
}

#pragma mark - 支付
//haleyAction://payAction?order_no=201511120981234&channel=wx&amount=1&subject=粉色外套
- (void)payAction:(NSURL *)URL
{
    NSArray *params =[URL.query componentsSeparatedByString:@"&"];

    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSString *paramStr in params)
    {
        NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
        if (dicArray.count > 1)
        {
            NSString *decodeValue = [dicArray[1] stringByRemovingPercentEncoding];
            [tempDic setObject:decodeValue forKey:dicArray[0]];
        }
    }
    NSString *orderNo = [tempDic objectForKey:@"order_no"];
    long long amount = [[tempDic objectForKey:@"amount"] longLongValue];
    NSString *subject = [tempDic objectForKey:@"subject"];
    NSString *channel = [tempDic objectForKey:@"channel"];
    //支付操作
    NSLog(@"orderNo = %@",orderNo);
    NSLog(@"amount = %lld",amount);
    NSLog(@"subject = %@",subject);
    NSLog(@"channel = %@",channel);

    // 将支付结果返回给js
    NSUInteger code = 1;
    NSString *jsStr = [NSString stringWithFormat:@"payResult('%@',%lu)",@"支付成功",(unsigned long)code];
    [self.wkWebView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@----%@",result, error);
    }];
}

#pragma mark - 摇一摇
//haleyAction://shake
- (void)shakeAction
{
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

#pragma mark - 返回
//haleyAction://back
- (void)goBack
{
    NSLog(@"goBack");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - dealloc
- (void)dealloc
{
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
        preferences.minimumFontSize = 40.0;

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
//1、WKWebView增加的属性
//   WKWebViewConfiguration *configuration: 初始化WKWebView的时候的配置,后面会用到
//   WKBackForwardList *backForwardList: 相当于访问历史的一个列表
//   double estimatedProgress: 进度,有这个之后就不用自己写假的进度条了
//
//2、WKWebView两个代理方法
//   WKWebView有两个delegate,WKUIDelegate和WKNavigationDelegate.WKNavigationDelegate主要处理一些跳转、加载处理操作,WKUIDelegate主要处理JS脚本,确认框,警告框等.
//  因此WKNavigationDelegate更加常用.
//
//3、Html弹出选择框
//   此时在html中加入alert,不会有作用,一定要重写runJavaScriptAlertPanelWithMessage
//   这里面的message参数就是Html要弹出的内容
//   

@end
