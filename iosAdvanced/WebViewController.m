//
//  WebViewController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/7.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "WebViewController.h"
#import <AVFoundation/AVFoundation.h>

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define BarHeight 20

@interface WebViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];

    self.title = @"UIWebView拦截URL";
    [self initViews];
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
}

- (void)initViews
{
    [self.view addSubview:self.webView];
    //1、获取网页
    //1.1、加载本地html
    NSURL *htmlURL = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];
    //1.2、加载网页html
    //NSURL *htmlURL = [NSURL URLWithString:@"http://www.baidu.com"];

    //2、封装NSURLRequest
    NSURLRequest *request = [NSURLRequest requestWithURL:htmlURL];
    //3、加载request
    [self.webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
//iOS SDK并没有原生提供js调用native代码的API.
//1、但是UIWebView的一个delegate方法使我们可以做到让js需要调用时,通知native
//2、在native执行完相应调用后,可以用stringByEvaluatingJavaScriptFromString方法,
//   将执行结果返回给js
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *URL = request.URL;
    NSLog(@"即将加载URL = %@",URL);
    NSString *scheme = [URL scheme];
    NSLog(@"scheme = %@",scheme);
    if ([scheme isEqualToString:@"haleyaction"])
    {
        //在这里做js调native的事情
        [self handleCustomAction:URL];
        //做完之后用如下方法调回js
        //[webView stringByEvaluatingJavaScriptFromString:@"alert('done')"];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"开始加载");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"加载结束");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"加载失败");
}

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
    [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
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
                [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
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
    [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
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
//一、iframe相关
//1、简介
//   <iframe> 标签规定一个内联框架.一个内联框架被用来在当前HTML文档中嵌入另一个文档.
//   也可以这样说在当前网页加载一个新的网页
//
//2、应用
//   通常我们使用iframe直接在页面嵌套iframe标签指定的src就可以了
//   例如:
//   <iframe name="myiframe" id="myrame" src="external_file.html" frameborder="0" align="left" width="200" height="200" scrolling="no">
//
//3、常用属性
//　   　  name : 规定<iframe>的名称
//       width : 规定<iframe>的宽度
//      height : 规定<iframe>的高度
//         src : 规定在<iframe>中显示的文档的URL
// frameborder : 规定是否显示<iframe>周围的边框.(0为无边框,1位有边框)
//       align : 规定如何根据周围的元素来对齐<iframe>.(left,right,top,middle,bottom)
//   scrolling : 规定是否在<iframe>中显示滚动条.(yes,no,auto)
//
//4、优缺点
//优点:
//
//　　重载页面时不需要重载整个页面,只需要重载页面中的一个框架页(减少数据的传输,减少网页的加载时间).
//　　技术简单,使用方便,主要应用于不需要搜索引擎来搜索的页面.
//　　方便开发,减少代码的重复率(比如页面的header,footer).
//
//缺点:
//
//　　会产生很多的页面,不易于管理.
//　　不易打印.
//　　多框架的页面会增加服务气得http请求.
//　　浏览器的后退按钮无效等.
//
//5、最后小结
//   因为document.body.appendChild(iFrame),
//   iFrame设置了src,相当于当前界面加载一个新的网页,会被shouldStartLoadWithRequest拦截
//

@end


