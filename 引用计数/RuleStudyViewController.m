//
//  RuleStudyViewController.m
//  引用计数
//
//  Created by 杨世川 on 18/3/27.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "RuleStudyViewController.h"

OBJC_EXTERN int _objc_rootRetainCount(id);

@interface RuleStudyViewController ()

@end

@implementation RuleStudyViewController
//当前要在MRC环境下执行！！！
/**
 ARC下获取引用计数
 1、使用KVC
 [obj valueForKey:@"retainCount"]

 2、使用私有API--不太建议使用，打印结果有问题
 OBJC_EXTERN int _objc_rootRetainCount(id);
 _objc_rootRetainCount(obj)

 3、使用CFGetRetainCount--建议使用
 CFGetRetainCount((__bridge CFTypeRef)(obj))
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //四条法则验证
    //[self testOne];
}

/*
 * 自己生成的对象，自己持有
 * 非自己生成的对象，自己也能持有 --- MRC中通过retain实现；ARC中因为__strong缘故，直接强引用
 * 不再需要自己持有的对象时释放
 * 非自己持有的对象无法释放      --- MRC中无法调用release，否则会崩溃；ARC中不会调用release
 *
 * 以上是否持有关系到自己有没有权利释放。
 **/

/*
- (void)testOne
{
    //1、生成(alloc、new、copy、mutablecopy等)并持有对象、引用计数加1
    id objOne = [[NSObject alloc]init];
    NSLog(@"retain count-1 = %ld",CFGetRetainCount((__bridge CFTypeRef)(objOne)));

    //2、非生成(除以上方法之外)、自己持有(通过retain)
    id objTwo = [NSMutableArray array];
    //这里引用计数为1
    //可以理解这个对象已经在自动缓存池中存有，但是不是objTwo所持有!!!
    NSLog(@"retain count-2 = %ld",CFGetRetainCount((__bridge CFTypeRef)(objTwo)));
    [objTwo retain];
    NSLog(@"retain count-2 = %ld",CFGetRetainCount((__bridge CFTypeRef)(objTwo)));

    //3、不需要自己持有的对象时释放
    id objThree = [[NSObject alloc]init];
    NSLog(@"retain count-3 = %ld",CFGetRetainCount((__bridge CFTypeRef)(objThree)));
    [objThree release];
    //进行以下操作会崩溃、因为对象释放
    //NSLog(@"retain count-3 = %ld",CFGetRetainCount((__bridge CFTypeRef)(objThree)));

    //4、非自己生成并持有的对象，若用retain变为自己持有，也可以用release释放
    id  objFour = [NSMutableArray array];
    NSLog(@"retain count-4 = %ld",CFGetRetainCount((__bridge CFTypeRef)(objFour)));
    [objFour retain];
    NSLog(@"retain count-4 = %ld",CFGetRetainCount((__bridge CFTypeRef)(objFour)));
    [objFour release];
    //此时引用计数还是1，而不是0；可以理解为对象还放在缓存池中，不由当前对象释放。
    NSLog(@"retain count-4 = %ld",CFGetRetainCount((__bridge CFTypeRef)(objFour)));

    //5、直接释放自己没有持有的对象，会造成崩溃
    id  objFive = [NSMutableArray array];
    NSLog(@"retain count-5 = %ld",CFGetRetainCount((__bridge CFTypeRef)(objFive)));
    //不能直接进行以下操作，会崩溃
    //[objFive release];
}

//模仿生成并持有对象的过程
- (id)allocObject
{
    id  obj = [[NSObject alloc]init];
    return obj;
}

//模仿对象存在，但自己不持有对象的过程
- (id)object
{
    id obj = [[NSObject alloc]init];
    //因为加入了autorelease
    //autorelease:使对象在超出指定的生存范围时，能够自动并正确地释放(调用release)
    [obj autorelease];//obj注册到autoreleasepool中，pool结束时自动调用release
    return obj;
}

*/

@end


