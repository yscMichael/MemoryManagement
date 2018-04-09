//
//  BlockStorageARCController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/7.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "BlockStorageARCController.h"

//Stack
void(^blockStackOne_ARC)(id);
void(^blockStackTwo_ARC)(id);

typedef void(^blockStackThree_ARC)(id);
blockStackThree_ARC blockThreeARC;

//Global
void(^blockGlobalOne_ARC)(void) = ^{ NSLog(@"Global Block");};

//Malloc
void(^blockMallocOne_ARC)(id);
void(^blockMallocTwo_ARC)(void);

typedef void (^blockMallocThree_ARC)(void);
typedef int (^blockMallocFour_ARC)(int);
blockMallocFour_ARC blockFourARC;

@interface BlockStorageARCController ()
{
    blockMallocThree_ARC blockThreeTestARC;
}

@end

@implementation BlockStorageARCController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //Stack
    //[self testBlockMRCOne];//----ARC变成Malloc
    //[self testBlockMRCFive];//----ARC变成Malloc
    //[self testBlockMRCSeven];//----ARC变成Malloc

    //Global
    //[self testBlockMRCThree];
    //[self testBlockMRCFour];
    [self testBlockMRCTen];

    //Malloc
    //[self testBlockMRCTwo];
    //[self testBlockMRCSix];
    //[self testBlockMRCEight];
    //[self testBlockMRCNine];

    //system
    [self testBlockMRCEleven];
}

#pragma mark - test1-Stack
- (void)testBlockMRCOne
{
    NSInteger i = 10;
    //打断点可以发现,这里是NSMallocBlock,不会❌;
    //这里变量虽然在堆上,但是仍然不能赋值
    blockStackOne_ARC = ^(id obj){
        NSLog(@"%ld", i);
        //i = 0;
    };
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //这里不用copy,block在堆上

    //blockStackOne_ARC([[NSObject alloc]init]);
    //blockMallocOne_ARC([[NSObject alloc]init]);
}

#pragma mark - test2-Malloc
- (void)testBlockMRCTwo
{
    NSInteger i = 10;
    //打断点可以发现,这里是NSMallocBlock
    blockMallocOne_ARC = ^(id obj){
        NSLog(@"%ld", i);
    };
}

#pragma mark - test3-Global
- (void)testBlockMRCThree
{
    //这里是NSGlobalBlock
    blockGlobalOne_ARC();
}

#pragma mark - test4-Global
- (void)testBlockMRCFour
{
    //在代码不截获自动变量时，生成的block也是在全局区
    //这里是NSGlobalBlock

    int(^block)(int count) = ^(int count) {
        return count;
    };

    NSLog(@"block(2) = %d",block(2));
}

#pragma mark - test5-Stack
- (void)testBlockMRCFive
{
    //在代码不截获自动变量时，生成的block也是在全局区
    //这里虽然截获了自动变量,但是在NSMallocBlock

    int tempValue = 10;

    int(^block)(int count) = ^(int count) {
        return count * tempValue;
    };

    NSLog(@"block(2) = %d",block(2));
}

#pragma mark - test6-Malloc
- (void)testBlockMRCSix
{
    __block NSInteger i = 10;
   //    blockMallocTwo_ARC = [^{
   //        ++i;
   //    } copy];

    //这里即使不用copy,也是放在堆上
    blockMallocTwo_ARC = ^{
        ++i;
    };

    //11
    ++i;//++(i->__forwarding->i);

    //12
    blockMallocTwo_ARC();

    NSLog(@"i = %ld", i);
}

#pragma mark - test7-Stack
- (void)testBlockMRCSeven
{
    [self funBlock];
    //这里不会崩溃,因为block在Malloc上
    blockThreeARC([[NSObject alloc] init]);
    blockThreeARC([[NSObject alloc] init]);
    blockThreeARC([[NSObject alloc] init]);
}

- (void)funBlock
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    blockThreeARC = ^(id obj){
        [array addObject:obj];
        NSLog(@"array.count-1 = %lu",(unsigned long)array.count);
    };
}

#pragma mark - test8-Malloc
- (void)testBlockMRCEight
{
    [self funBlockCopy];
    //虽然没有使用copy
    //这里block在堆上,block在堆上,它所持有的变量也在堆上
    blockStackTwo_ARC([[NSObject alloc] init]);
    blockStackTwo_ARC([[NSObject alloc] init]);
    blockStackTwo_ARC([[NSObject alloc] init]);
}

- (void)funBlockCopy
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    blockStackTwo_ARC = ^(id obj){
        [array addObject:obj];
        NSLog(@"array.count-1 = %lu",(unsigned long)array.count);
    };
}

#pragma mark - test9-Malloc
- (void)testBlockMRCNine
{
    //这里是Malloc
    blockFourARC = funARC(10);
    NSLog(@"blockFour = %d",blockFourARC(10));
}

blockMallocFour_ARC funARC(int rate)
{
    //这里不加Copy,不会出错
    return ^(int count){
        return count + rate;
    };
}

#pragma mark - test10-Global
- (void)testBlockMRCTen
{
    //这里相当于是全局Block
    blockThreeTestARC = ^{
        NSLog(@"Block");
    };

    blockThreeTestARC();
}

#pragma mark - test11-system
- (void)testBlockMRCEleven
{
    //这里面用self,不会引起循环引用
    //因为这个block存在于静态方法中,虽然block对self强引用着;
    //但是self却不持有这个静态方法,所以完全可以在block内部使用self
    [UIView animateWithDuration:0.5 animations:^{
        NSLog(@"%@", self);
    }];

    //当block不是self的属性时,self并不持有这个block,所以也不存在循环引用
    void(^block)(void) = ^() {
        NSLog(@"%@", self);
    };
    block();
}

//基本语法:
//1、NSGlobalBlock是位于全局区的block,它是设置在程序的数据区域（.data区）中
//2、NSStackBlock是位于栈区,超出变量作用域,栈上的Block以及__block变量都被销毁
//3、NSMallocBlock是位于堆区,在变量作用域结束时不受影响。
//4、注意:在 ARC 开启的情况下,将只会有 NSConcreteGlobalBlock 和 NSConcreteMallocBlock类型的block

//当前是ARC环境!!!
//总结:
//1、什么是全局Block
//   a、定义全局变量的地方有block语法时
//   b、block语法的表达式中没有使用应截获的自动变量时
//   c、block语法赋值给成语变量

//2、什么是栈Block <在ARC环境下,不存在栈Block!!!>
//   a、block语法的表达式在函数内局部定义,类似于局部变量
//   b、block语法的表达式中使用截获的自动变量时

//3、什么时候栈Block会复制到堆上<在ARC环境下,除了Global的block,其它都是Malloc的Block>
//   a、调用Block的copy实例方法时
//   b、Block作为函数返回值返回时
//   c、将Block赋值给附有__strong修饰符id类型的类或Block类型成员变量时
//   d、将方法名中含有usingBlock的Cocoa框架方法或GCD的API中传递Block时
//   注意:上面只对Block进行了说明,其实在使用__block变量的Block从栈上复制到堆上时,__block变量也被从栈复制到堆上并被Block所持有

//4、__block变量被复制到堆
//   a、__block变为__Block_byref_i_0结构体
//   b、__Block_byref_i_0结构体里面有__forwarding指针
//   c、栈上的__block变量复制到堆上时,会将成员变量__forwarding的值替换为复制到堆上的__block变量用结构体实例的地址.所以"不管__block变量配置在栈上还是堆上,都能够正确的访问该变量",这也是成员变量__forwarding存在的理由
//   d、++i等价于 ++(i->__forwarding->i);
//      如果__block没有被复制到堆上,则__forwarding指向自己;否则指向堆上变量


@end



