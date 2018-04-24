//
//  LoadAndInitializeViewController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/17.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "LoadAndInitializeViewController.h"
#import "Bulldog.h"

@interface LoadAndInitializeViewController ()


@end

@implementation LoadAndInitializeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    Bulldog *bullDog = [[Bulldog alloc] init];
    bullDog.name = @"222";
}

//场景:
//   1、Dog、Bulldog、Bulldog(Category)都实现load
//      我是Dog
//      我是斗牛犬
//      我是斗牛犬的分类
//
//   2、这里面因为是继承NSObject,里面有load方法,所以无法验证子类本身没有实现load方法
//      父类的load方法也不会被调用

//总结:
//一、load
//   1、如果加入load方法,必定会被调用(系统程序运行,非认为调用,在main函数之前调用)
//      只调用一次
//   2、一般执行顺序:父类->子类->分类
//   3、在load方法中调用其它类是不安全的,因为载入顺序的问题,不知道是否完成初始化
//   4、load不遵从集成规则,某个类没有实现load方法,不会去调用父类的
//   5、尽量精简load方法,防止线程阻塞
//   6、load 方法中最常用的就是方法交换method swizzling
//
//二、initialize
//   1、惰性调用,只有用到的时候才会调用、只调用一次
//   2、
//
//三、二者区别
//   不同点:
//   1、调用方式
//      load必定先调用(应用程序会阻塞,等着所有的load执行完毕)
//      initialize只有使用到的时候才会被调用
//      都是只调用一次
//
//   2、从线程安全来讲
//      load方法中不应调用其它类的方法,因为此时运行程序处于"脆弱状态"
//      initialize处于正常状态,运行期系统会确保initialize方法是在线程安全的环境中执行
//
//   3、继承规则
//     a、如果类未实现initialize方法,而其超类实现了,那么会运行超类的实现代码,而且会运行两次(没有判断类别的前提下)
//     b、load不遵循这个规则
//
//相同点:
//    1、都要保持精简
//应用场景:
//    1、无法在编译期设定的全局常量,可以放在initialize方法里初始化
//    2、load中method swizzling


//参考文章:
//1、不得不知的load与initialize
//   http://www.cocoachina.com/ios/20161012/17732.html

@end

