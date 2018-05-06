//
//  NavBarGradientController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/6.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "NavBarGradientController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define BarHeight 20

@interface NavBarGradientController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dataSource;

@end

@implementation NavBarGradientController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];

    //self.navigationController.edgesForExtendedLayout = UIRectEdgeNone;
    //rself.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor orangeColor]];

    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.dataSource[indexPath.row];

    return cell;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    CGFloat offset = self.tableView.contentOffset.y;
    //越来越大想要实现效果:一开始全显示,后来颜色变浅
    NSLog(@"offset:%f",offset);
    CGFloat delta = 1 - offset / 100.f;
    delta = MIN(1,delta);
    NSLog(@"%f",delta);
    self.navigationController.navigationBar.alpha = MIN(1,delta);
}

- (void)dealloc
{
    NSLog(@"dealloc");
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - setter and getter
- (UITableView *)tableView
{
    if (!_tableView)
    {
        //64和0查看效果
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5", @"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",nil];
    }
    return _dataSource;
}

//总结:
//1、ScrollView自动偏移64的解决办法
//   vc.automaticallyadjustsScrollviewInsets ＝ NO;
//
//参考文章:
//1、ScrollView自动偏移64的解决办法
//   https://blog.csdn.net/nb_coder/article/details/77249444



@end
