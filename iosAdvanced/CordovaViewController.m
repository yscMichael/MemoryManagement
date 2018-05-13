//
//  CordovaViewController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/7.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "CordovaViewController.h"

@interface CordovaViewController ()

@end

@implementation CordovaViewController

- (void)viewDidLoad
{
    //1、一定要在html之前调用
    //self.wwwFolderName = @"www";//这个采用默认值
    //self.startPage = @"http://www.baidu.com";
    self.startPage = @"indexFour.html";

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"测试" style:UIBarButtonItemStylePlain target:self action:@selector(testClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)testClick
{
    NSString *jsStr = @"asyncAlert('oc调用js')";
    [self.commandDelegate evalJs:jsStr];
}

//总结:
//一、安装步骤
//1、安装Node.js
//2、执行指令
//
//(1)安装Cordova
//   npm install -g cordova
//   或sudo npm install -g cordova
//
//(2)创建一个工程
//   cordova create 工程名
//   cordova help create
//   eg:cordova create /Users/yangshichuan/Desktop/cordova/myApp
//
//(3)添加平台
//   cordova platform add <platform name>
//
//(4)运行App
//   cordova run <platform name>
//
//(5)cordova run ios不好使,需要添加其它指令
//   npm install -g ios-deploy
//   sudo npm install -g ios-deploy
//
//二、加载html文件注意点
//(1)、CDVViewController中的wwwFolderName和startPage
//     wwwFolderName: www
//     startPage: index.html
//
//(2)、config.xml中<content src="indexFour.html" />
//
//(3)、加载远程HTML注意事项
//     1、self.startPage的赋值,必须在[super viewDidLoad]之前,
//        否则self.startPage 会被默认赋值为index.html。
//     2、需要在config.xml中修改一下配置,否则加载远程H5时,会自动打开浏览器加载
//        需要添加的配置是：
//              <allow-navigation href="https://*/*" />
//              <allow-navigation href="http://*/*"  />
//     3、远程H5中也要引用cordova.js文件
//     4、在info.plist中添加 App Transport Security Setting的设置
//
//三、js调用oc方法
//(1)、YYPlugin继承自YYPlugin
//(2)、添加方法
//     - (void)scan:(CDVInvokedUrlCommand *)command;
//(3)、config.xml配置
//       <feature name="YYPlugin">
//           <param name="ios-package" value="YYPlugin" />
//       </feature>
//(4)、实现方法
//- (void)scan:(CDVInvokedUrlCommand *)command
//{
//    a、
//    runInBackground:在后台执行,防止阻塞线程
//    b、
//    CDVInvokedUrlCommand:包含以下四个参数
//                        :arguments、callbackId、className、methodName
//    c、参数数组
//    NSArray *arguments = command.arguments;
//}
//
//四、将Native结果返回js
//1、直接执行JS,调用UIWebView的执行js方法
//   NSString *jsStr = [NSString
//       stringWithFormat:@"shareResult('%@','%@','%@')",title,content,url];
//   [self.commandDelegate evalJs:jsStr];
//
//2、使用Cordova封装好的对象CDVPluginResult和API
//   前提:在js调用Native时,使用cordova.exec
//   successCallback : 成功的回调方法
//   failCallback : 失败的回调方法
//   server : 所要请求的服务名字，就是插件类的名字
//   action : 所要请求的服务具体操作，其实就是Native 的方法名，字符串。
//   actionArgs : 请求操作所带的参数，这是个数组。
//   cordova.exec(successCallback, failCallback, service, action, actionArgs);
//
//   eg:
//   function locationClick()
//   {
//      cordova.exec(setLocation,locationError,"YYPlugin","location",[]);
//   }
//
//- (void)location:(CDVInvokedUrlCommand *)command
//{
//    [self.commandDelegate runInBackground:^{
//        CDVPluginResult *result = [CDVPluginResult
//        resultWithStatus:CDVCommandStatus_ERROR messageAsString:locationStr];
//        [self.commandDelegate sendPluginResult:result
//        callbackId:command.callbackId];
//    }];
//}
//

@end

