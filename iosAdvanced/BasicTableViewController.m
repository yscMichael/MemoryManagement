//
//  BasicTableViewController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/1.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "BasicTableViewController.h"
#import "YYCell.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define BarHeight 20

@interface BasicTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dataSource;

@end

@implementation BasicTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self initView];
}

- (void)initView
{
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:  (NSInteger)section
{
    return 399;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定cell的重用标识符
    static NSString *reuseIdentifier = @"YYCell";
    //去缓存池找名叫reuseIdentifier的cell
    //这里换成自己定义的cell
    YYCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //如果缓存池中没有,那么创建一个新的cell
    if (!cell)
    {
        //这里换成自己定义的cell,并调用类方法加载xib文件
        cell = [YYCell xibTableViewCell];
    }

    cell.firstImage = [UIImage imageNamed:@"spaceship.jpg"];
    cell.secondImage = [UIImage imageNamed:@"spaceship.jpg"];
    cell.threeImage = [UIImage imageNamed:@"spaceship.jpg"];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180.0;
}

#pragma mark - Setter And Getter
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, BarHeight, ScreenWidth, ScreenHeight - BarHeight)];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

//总结:
//实际结果,并不卡顿,后续找一个更好的例子

@end


