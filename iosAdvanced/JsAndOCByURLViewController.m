//
//  JsAndOCByURLViewController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/6.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "JsAndOCByURLViewController.h"
#import "WebViewController.h"
#import "WKWebViewController.h"

@interface JsAndOCByURLViewController ()

@end

@implementation JsAndOCByURLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];


}

- (IBAction)webViewClick:(id)sender
{
    WebViewController *webVC = [[WebViewController alloc] init];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)WKWebViewClick:(id)sender
{
    WKWebViewController *wkWebVC = [[WKWebViewController alloc] init];
    [self.navigationController pushViewController:wkWebVC animated:YES];
}

//总结:
//一、常用方式
//iOS与JS交互的方法：
//1.拦截url（适用于UIWebView和WKWebView）
//2.JavaScriptCore（只适用于UIWebView，iOS7+）
//3.WKScriptMessageHandler（只适用于WKWebView，iOS8+）
//4.WebViewJavascriptBridge（适用于UIWebView和WKWebView，属于第三方框架）

@end

