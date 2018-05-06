//
//  KVOObserverArrayController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/5.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "KVOObserverArrayController.h"
static int count = 0;

@interface KVOObserverArrayController ()

@property(nonatomic, strong) NSMutableArray *testArray;

@end

@implementation KVOObserverArrayController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    //这里KeyPath为什么一定是testArray,一定要一样嘛
    [self addObserver:self forKeyPath:@"testArray" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

#pragma mark - button点击事件
//增加元素
//会触发
- (IBAction)firstButtonClick:(id)sender
{
   count ++;
   NSString *tempString = [NSString stringWithFormat:@"%d",count];
   [[self mutableArrayValueForKey:@"testArray"] addObject:tempString];
}

//删除元素
//会触发
- (IBAction)secondButtonClick:(id)sender
{
    if(self.testArray.count > 0)
    {
        [[self mutableArrayValueForKey:@"testArray"] removeLastObject];
    }
}

//替换元素
//会触发
- (IBAction)threeButtonClick:(id)sender
{
    NSInteger length = self.testArray.count;
    [[self mutableArrayValueForKey:@"testArray"] replaceObjectAtIndex:(length - 1) withObject:@"aaa"];
}

//修改元素
//不会触发
- (IBAction)fourButtonClick:(id)sender
{
    NSLog(@"修改元素");
    NSString *tempString = self.testArray[0];
    tempString = @"AAA";
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"keyPath=%@",keyPath);
    NSLog(@"object=%@",object);
    NSLog(@"change=%@",change);
    NSLog(@"context=%@",context);
    
    if ([keyPath isEqualToString:@"testArray"])
    {
        NSLog(@"监听到了 = %@", self.testArray);
    }
}

- (void)dealloc
{
    NSLog(@"dealloc");
    if (self.testArray != nil)
    {
        //当前是self addObserver
        //自己监听自己,不可以
        [self removeObserver:self forKeyPath:@"testArray"];
    }
}

#pragma mark - Setter And Getter
- (NSMutableArray *)testArray
{
    if (!_testArray)
    {
        _testArray = [[NSMutableArray alloc] initWithObjects:@"A",@"B",@"C",@"D", nil];
    }
    return _testArray;
}

//总结
//1、只有你的操作触发了set方法才会引起KVO监听
//
//参考文章:
//1、ios - KVO观察的是对象指针的变化，还是对象内容的变化
//   http://www.itkeyword.com/doc/8002268458452236x635/ios-kvo



@end
