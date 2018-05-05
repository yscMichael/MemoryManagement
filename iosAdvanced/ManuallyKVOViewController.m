//
//  ManuallyKVOViewController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/4.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "ManuallyKVOViewController.h"
#import "Rice.h"

@interface ManuallyKVOViewController ()

@property (nonatomic ,strong) Rice *rice;

@end

@implementation ManuallyKVOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self.rice addObserver:self forKeyPath:@"price" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.rice.price += 1;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"keyPath=%@",keyPath);
    NSLog(@"object=%@",object);
    NSLog(@"change=%@",change);
    NSLog(@"context=%@",context);

    if ([keyPath isEqualToString:@"price"])
    {
        int price = [[change objectForKey:@"new"] intValue];
        NSLog(@"price = %d",price);
    }
}

- (void)dealloc
{
    NSLog(@"dealloc");
    [self.rice removeObserver:self forKeyPath:@"price"];
}


#pragma mark - setter and getter
- (Rice *)rice
{
    if (!_rice)
    {
        _rice = [[Rice alloc] init];
    }
    return _rice;
}

//总结:
//一、手动触发KVO
//1、重写automaticallyNotifiesObserversForName
//官网固定写法:
//+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey
//{
//      BOOL automatic = NO;
//      if ([theKey isEqualToString:@"balance"])
//      {
//          automatic = NO;
//      }
//      else
//      {
//          automatic = [super automaticallyNotifiesObserversForKey:theKey];
//      }
//      return automatic;
//}
//备注:想让哪个属性手动触发,将balance替换为哪个属性
//
//2、重写set方法
//主要添加两个方法:
//willChangeValueForKey和didChangeValueForKey
//
//例子:
//- (void)setPrice:(NSInteger)price
//{
//    [self willChangeValueForKey:@"price"];
//    if (price != _price)
//    {
//        _price = price;
//    }
//    [self didChangeValueForKey:@"price"];
//}
//
//3、KVO中的addObserver和observeValueForKeyPath照常使用
//   感觉手动触发KVO没有什么用途
//
//二、使用KVO需要注意哪些点
//1、如果没有observer监听keypath,removeObsever:forKeyPath:context: 这个key path,就会crash,不像NSNotificationCenter removeObserver
//2、不要忘记removeObserver,防止内存泄漏
//3、对代码你很难发现谁监听你的property的改动，查找起来比较麻烦。
//4、对于一个复杂和相关性很高的class,最好还是不要用KVO,就用delegate或者 notification的方式比较简洁
//
//参考网址:
//1、手动触发KVO
//https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/KeyValueObserving/Articles/KVOCompliance.html#//apple_ref/doc/uid/20002178-SW3
//2、官网地址
//https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/KeyValueObserving/Articles/KVOCompliance.html#//apple_ref/doc/uid/20002178-SW3



@end
