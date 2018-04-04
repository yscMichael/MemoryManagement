//
//  AutoReleaseARCViewController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/3.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "AutoReleaseARCViewController.h"
#import "NSObject+Category.h"

extern void _objc_autoreleasePoolPrint();//打印注册到自动释放池中的对象
extern uintptr_t _objc_rootRetainCount(id obj);//获取对象的引用计数

@interface AutoReleaseARCViewController ()

@end

@implementation AutoReleaseARCViewController

//这里主要查看反编译代码
//1、将代码转化为汇编指令(学习内存管理很有用)!!!
//clang -S -fobjc-arc main.m
//
//2、在终端使用Clang命令 编译（相比于Xcode运行，可以单独的编译文件并运行）
//clang -fobjc-arc -framework Foundation AAAA.m -o BBBB
//
//3、Clang重写m文件为cpp文件(重点说下，在学习Runtime时候很有用，可以逆向观察学习)!!!
//clang -rewrite-objc main.m

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self systemClassMethodStudy];
    [self customizeClassMethodStudy];
}

#pragma mark - 系统方法
- (void)systemClassMethodStudy
{
    //[self systemClassMethodStudyOne];
    //[self systemClassMethodStudyTwo];
    //[self systemClassMethodStudyThree];
}

#pragma mark - 自定义方法
- (void)customizeClassMethodStudy
{
    //[self customizeClassMethodStudyOne];
    //[self customizeClassMethodStudyTwo];
    //[self customizeClassMethodStudyThree];
    //[self customizeClassMethodStudyFour];

    //[self customizeClassMethodStudyFive];
    //[self customizeClassMethodStudySix];
    //[self customizeClassMethodStudySeven];
    //[self customizeClassMethodStudyEight];
}

//系统类方法-1-崩溃
- (void)systemClassMethodStudyOne
{
    id __unsafe_unretained target = nil;
    {
        //temp没有被注册到自动释放池中
        id  temp = [NSMutableArray array];
        [temp addObject:@"obj"];
        target = temp;
        NSLog(@"temp = %@",temp);
        _objc_autoreleasePoolPrint();
    }//超出作用域,temp所指对象就被销毁,target还指向一段被回收的内存,所以崩溃
    NSLog(@"target = %@",target);

    //大括号中的等价内容<详情见Objective-C高级编程p62>：
    {
        //objc_retainAutoreleasedReturnValue函数与objc_retain函数不同，它即便不注册到autoreleasepool中而返回对象，也能够正确地获取对象

        //id temp = objc_msgSend(NSMutableArray, @selector(array));
        //...
        //objc_release(temp);
    }
}

//系统类方法-2-崩溃
- (void)systemClassMethodStudyTwo
{
    id __unsafe_unretained target = nil;
    {
        //这里返回的对象直接是自己持有,更没有注册到自动释放池中了
        id  temp = [[NSMutableArray alloc]init];
        [temp addObject:@"obj"];
        target = temp;
        NSLog(@"temp = %@", temp);
    }//超出作用域,temp所指对象就被销毁,target还指向一段被回收的内存,所以崩溃
    NSLog(@"target = %@",target);

    //以上代码等价于以下代码：
    {
        //id obj = objc_msgSend(NSObject, @selector(alloc));
        //objc_msgSend(obj, @selector(init));
        //...
        //objc_release(obj);
    }
}

//系统类方法-3-不崩溃
- (void)systemClassMethodStudyThree
{
    id __unsafe_unretained target = nil;
    {
      //@autoreleasepool {//手动添加自动释放池,会崩溃
        //这里对象已经被加入到自动释放池
        id temp = [NSMutableArray arrayWithObjects:@"obj",nil];
        target = temp;

        //自动释放池+temp强引用=2
        NSLog(@"temp-RetainCount = %lu",_objc_rootRetainCount(temp));
        NSLog(@"temp = %@", temp);
      //}
    }//因为在自动释放池中,所以这里对象还没有被释放,会等到下一次时间循环时释放自动释放池
    NSLog(@"target = %@", target);
}

//自定义类方法研究-1-不会崩溃
- (void)customizeClassMethodStudyOne
{
    id __unsafe_unretained target = nil;
    {
        //对象被放到了自动释放池中
        id temp = [[self class] Object];
        [temp addObject:@"obj"];

        target = temp;
        NSLog(@"temp.RetainCount = %lu",_objc_rootRetainCount(temp));
        NSLog(@"temp = %@", temp);
    }
    NSLog(@"target = %@", target);
}

//自定义类方法研究-2-崩溃
- (void)customizeClassMethodStudyTwo
{
    id __unsafe_unretained target = nil;
    {
        //这里对象没有出现在自动释放池中
        id temp = [[self class] Objects];
        [temp addObject:@"obj"];

        target = temp;
        NSLog(@"temp.RetainCount = %lu",_objc_rootRetainCount(temp));
        NSLog(@"temp = %@", temp);
    }
    NSLog(@"target = %@", target);
}

//自定义类方法研究-3-崩溃
- (void)customizeClassMethodStudyThree
{
    id __unsafe_unretained target = nil;
    {
        id temp = [[self class] Objectss];
        [temp addObject:@"obj"];

        target = temp;
        NSLog(@"temp.RetainCount = %lu",_objc_rootRetainCount(temp));
        NSLog(@"temp = %@", temp);
    }
    NSLog(@"target = %@", target);
}

//自定义类方法研究-4-崩溃
- (void)customizeClassMethodStudyFour
{
    id __unsafe_unretained target = nil;
    {
        id temp = [[self class] Objectsss];
        [temp addObject:@"obj"];

        target = temp;
        NSLog(@"temp.RetainCount = %lu",_objc_rootRetainCount(temp));
        NSLog(@"temp = %@", temp);
    }
    NSLog(@"target = %@", target);
}

//自定义类方法研究-5-崩溃
- (void)customizeClassMethodStudyFive
{
    id __unsafe_unretained target = nil;
    {
        id temp = [[self class] copyObject];
        [temp addObject:@"obj"];

        target = temp;
        NSLog(@"temp.RetainCount = %lu",_objc_rootRetainCount(temp));
        NSLog(@"temp = %@", temp);
    }
    NSLog(@"target = %@", target);
}

//自定义类方法研究-6-崩溃
- (void)customizeClassMethodStudySix
{
    id __unsafe_unretained target = nil;
    {
        id temp = [[self class] copyObjects];
        [temp addObject:@"obj"];

        target = temp;
        NSLog(@"temp.RetainCount = %lu",_objc_rootRetainCount(temp));
        NSLog(@"temp = %@", temp);
    }
    NSLog(@"target = %@", target);
}

//自定义类方法研究-7-崩溃
- (void)customizeClassMethodStudySeven
{
    id __unsafe_unretained target = nil;
    {
        id temp = [[self class] copyObjectss];
        [temp addObject:@"obj"];

        target = temp;
        NSLog(@"temp.RetainCount = %lu",_objc_rootRetainCount(temp));
        NSLog(@"temp = %@", temp);
    }
    NSLog(@"target = %@", target);
}

//自定义类方法研究-8-崩溃
- (void)customizeClassMethodStudyEight
{
    id __unsafe_unretained target = nil;
    {
        id temp = [[self class] copyObjectsss];
        [temp addObject:@"obj"];

        target = temp;
        NSLog(@"temp.RetainCount = %lu",_objc_rootRetainCount(temp));
        NSLog(@"temp = %@", temp);
    }
    NSLog(@"target = %@", target);
}

@end


