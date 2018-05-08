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
//JavaScriptCore.framework ios7以后默认是标准库(不用手动导入)

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
//share('测试分享的标题','测试分享的内容','url=http://www.baidu.com');
- (void)addShareWithContext:(JSContext *)context
{
    context[@"share"] = ^() {
        NSArray *args = [JSContext currentArguments];
        if (args.count < 3)
        {
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
        if (args.count < 4)
        {
            return ;
        }

        CGFloat r = [[args[0] toNumber] floatValue];
        CGFloat g = [[args[1] toNumber] floatValue];
        CGFloat b = [[args[2] toNumber] floatValue];
        CGFloat a = [[args[3] toNumber] floatValue];

        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a];
        });
    };
}

#pragma mark - 支付
- (void)addPayActionWithContext:(JSContext *)context
{
    context[@"payAction"] = ^() {
        NSArray *args = [JSContext currentArguments];
        if (args.count < 4)
        {
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
        dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf.navigationController popViewControllerAnimated:YES];
        });
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
//1、JSVirtualMachine.h : JS虚拟机
//1.1、解释:
//    (1)、JavaScript通过加锁虚拟机保证JSVirtualMachine是线程安全的,如果要并发执行JavaScript,
//       那我们必须创建多个独立的JSVirtualMachine实例,在不同的实例中执行JavaScript.
//    (2)、但是我们一般不用新建JSVirtualMachine对象,因为创建JSContext时,
//       如果我们不提供一个特性的JSVirtualMachine,内部会自动创建一个JSVirtualMachine对象
//
//2、JSContext.h
//1.1、解释:
//    (1)、JSContext是为JavaScript的执行提供运行环境,所有的JavaScript的执行都必须在JSContext环境.
//    (2)、JSContext也管理JSVirtualMachine中对象的生命周期.
//    (3)、每一个JSValue对象都要强引用关联一个JSContext.当与某JSContext对象关联的所有JSValue释放后,
//      JSContext也会被释放。
//1.2、创建方式:
//    (1)、这种方式需要传入一个JSVirtualMachine对象,如果传nil,会导致应用崩溃的
//         JSVirtualMachine *JSVM = [[JSVirtualMachine alloc] init];
//         JSContext *JSCtx = [[JSContext alloc] initWithVirtualMachine:JSVM];
//
//    (2)、这种方式,内部会自动创建一个JSVirtualMachine对象,可以通过JSCtx.virtualMachine
//         看其是否创建了一个JSVirtualMachine对象
//         JSContext *JSCtx = [[JSContext alloc] init];
//
//    (3)、通过webView的获取JSContext
//       JSContext *context = [self.webView
//       valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

//
//3、JSValue.h
//1.1、解释:
//     JSValue都是通过JSContext返回或者创建的,并没有构造方法.
//     JSValue包含了每一个JavaScript类型的值,
//     通过JSValue可以将Objective-C中的类型转换为JavaScript中的类型,
//     也可以将JavaScript中的类型转换为Objective-C中的类型
//
//
//4、JSManagedValue.h
//1.1、解释
//     JSManagedValue主要用途是解决JSValue对象在Objective-C 堆上的安全引用问题.
//     把JSValue保存进Objective-C堆对象中是不正确的,这很容易引发循环引用,而导致JSContext不能释放.
//
//
//5、JSExport.h
//1.1、解释
//    JSExport是一个协议类,但是该协议并没有任何属性和方法
//    我们可以自定义一个协议类,继承自JSExport.
//    无论我们在JSExport里声明的属性,实例方法还是类方法,继承的协议都会自动的提供给任何JavaScript代码
//    因此,我们只需要在自定义的协议类中,添加上属性和方法就可以了
//
//
//参考网址:
//1、iOS下JS与OC互相调用（四）--JavaScriptCore
//   https://www.jianshu.com/p/4db513ed2c1a
//
//
//

@end


