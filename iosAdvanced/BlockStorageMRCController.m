//
//  BlockStorageMRCController.m
//  引用计数
//
//  Created by 杨世川 on 2018/4/9.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "BlockStorageMRCController.h"

//Stack
void(^blockStackOne)(id);
void(^blockStackTwo)(id);

typedef void(^blockStackThree)(id);
blockStackThree blockThree;

//Global
void(^blockGlobalOne)(void) = ^{ NSLog(@"Global Block");};

//Malloc
void(^blockMallocOne)(id);
void(^blockMallocTwo)(void);

typedef void (^blockMallocThree)(void);
typedef int (^blockMallocFour)(int);
blockMallocFour blockFour;

//test
void(^blockTest)(void);

@interface BlockStorageMRCController ()
{
   blockMallocThree blockThreeTest;
}

@end

@implementation BlockStorageMRCController

//当前是MRC环境!!!

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //Stack
    //[self testBlockMRCOne];
    //[self testBlockMRCFive];
    //[self testBlockMRCSeven];

    //Global
    //[self testBlockMRCThree];
    //[self testBlockMRCFour];
    //[self testBlockMRCTen];

    //Malloc
    //[self testBlockMRCTwo];
    //[self testBlockMRCSix];
    //[self testBlockMRCEight];
    //[self testBlockMRCNine];

    //system
    //[self testBlockMRCEleven];

    //test
    [self testBlockMRCTwelve];
}

#pragma mark - test1-Stack
- (void)testBlockMRCOne
{
    NSInteger i = 10;
    //打断点可以发现,这里是NSStackBlock;在touchesBegan里,会❌
    blockStackOne = ^(id obj){
        NSLog(@"%ld", i);
    };
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //blockStackOne([[NSObject alloc]init]);

    //blockMallocOne([[NSObject alloc]init]);
    //[blockMallocOne release];
}

#pragma mark - test2-Malloc
- (void)testBlockMRCTwo
{
    NSInteger i = 10;
    //打断点可以发现,这里是NSMallocBlock
    blockMallocOne = [^(id obj){
        NSLog(@"%ld", i);
    } copy];
    //copy和release成对使用
}

#pragma mark - test3-Global
- (void)testBlockMRCThree
{
    //这里是NSGlobalBlock
    blockGlobalOne();
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
    //在代码截获自动变量时，生成的block也是在栈区
    //这里是NSStackBlock

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
    blockMallocTwo = [^{
        ++i;
    } copy];

    //11
    ++i;//++(i->__forwarding->i);

    //12
    blockMallocTwo();

    NSLog(@"i = %ld", i);
}

#pragma mark - test7-Stack
- (void)testBlockMRCSeven
{
    [self funBlock];
    //这里会崩溃,因为block在栈上
    blockThree([[NSObject alloc] init]);
    blockThree([[NSObject alloc] init]);
    blockThree([[NSObject alloc] init]);
}

- (void)funBlock
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    blockThree = ^(id obj){
        //block中引用了自动变量;否则,可以是全局block
        [array addObject:obj];
        NSLog(@"array.count-1 = %lu",(unsigned long)array.count);
    };
}

#pragma mark - test8-Malloc
- (void)testBlockMRCEight
{
    [self funBlockCopy];
    //这里block在堆上,block在堆上,它所持有的变量也在堆上
    blockStackTwo([[NSObject alloc] init]);
    blockStackTwo([[NSObject alloc] init]);
    blockStackTwo([[NSObject alloc] init]);
}

- (void)funBlockCopy
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    blockStackTwo = [^(id obj){
        [array addObject:obj];
        NSLog(@"array.count-1 = %lu",(unsigned long)array.count);
    } copy];
}

#pragma mark - test9-Malloc
- (void)testBlockMRCNine
{
    //这里是Malloc
    blockFour = fun(10);
    NSLog(@"blockFour = %d",blockFour(10));
}

blockMallocFour fun(int rate)
{
    //不加copy会提示出错
    return [^(int count){
        return count + rate;
    } copy];
}

#pragma mark - test10-Global
- (void)testBlockMRCTen
{
    //这里相当于是全局Block
    //成员变量属性
    blockThreeTest = ^{
        NSLog(@"Block");
    };

    blockThreeTest();
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

#pragma mark - test12-system
- (void)testBlockMRCTwelve
{
    NSArray *array = [self getBlockArray];
    blockTest = array[0];
    blockTest();
}

- (id)getBlockArray
{
    int val = 10;
    //这样返回会崩溃
    //    return [NSArray arrayWithObjects:
    //            ^{NSLog(@"MRC-blk0:%d",val);},
    //            ^{NSLog(@"MRC-blk1:%d",val);},nil];

    //这样不会崩溃
    //return [NSArray arrayWithObjects:
    //        [^{NSLog(@"MRC-blk0:%d",val);} copy],
    //        [^{NSLog(@"MRC-blk1:%d",val);} copy],nil];

    //这样也没事
    NSArray *arr = [[NSArray alloc] initWithObjects:
                    ^{NSLog(@"MRC-blk0:%d",val);},
                    ^{NSLog(@"MRC-blk1:%d",val);},
                    ^{NSLog(@"MRC-blk2:%d",val);},nil];
    return arr;
}

//基本语法:
//1、NSGlobalBlock是位于全局区的block,它是设置在程序的数据区域（.data区）中
//2、NSStackBlock是位于栈区,超出变量作用域,栈上的Block以及__block变量都被销毁
//3、NSMallocBlock是位于堆区,在变量作用域结束时不受影响。
//4、注意:在 ARC 开启的情况下,将只会有 NSConcreteGlobalBlock 和 NSConcreteMallocBlock类型的block

//当前是MRC环境!!!
//总结:
//1、什么是全局Block
//   a、定义全局变量的地方有block语法时
//   b、block语法的表达式中没有使用应截获的自动变量时
//   c、block语法赋值给成语变量

//2、什么是栈Block
//   a、block语法的表达式在函数内局部定义,类似于局部变量
//   b、block语法的表达式中使用截获的自动变量时

//3、什么时候栈Block会复制到堆上
//   a、调用Block的copy实例方法时---手动复制
//   b、Block作为函数返回值返回时---手动复制
//   c、将Block赋值给附有__strong修饰符id类型的类或Block类型成员变量时<这里貌似是Global的Block>---不用手动复制
//   d、将方法名中含有usingBlock的Cocoa框架方法或GCD的API中传递Block时---不用手动复制
//   注意:上面只对Block进行了说明,其实在使用__block变量的Block从栈上复制到堆上时,__block变量也被从栈复制到堆上并被Block所持有

//4、__block变量被复制到堆
//   a、__block变为__Block_byref_i_0结构体
//   b、__Block_byref_i_0结构体里面有__forwarding指针
//   c、栈上的__block变量复制到堆上时,会将成员变量__forwarding的值替换为复制到堆上的__block变量用结构体实例的地址.所以"不管__block变量配置在栈上还是堆上,都能够正确的访问该变量",这也是成员变量__forwarding存在的理由
//   d、++i等价于 ++(i->__forwarding->i);
//      如果__block没有被复制到堆上,则__forwarding指向自己;否则指向堆上变量


//5、Block的copy
//   _NSConcretStackBlock    copy      从栈复制到堆
//   _NSConcretGlobalBlock   copy      什么也不做
//   _NSConcretMallocBlock   copy      引用计数增加

@end


