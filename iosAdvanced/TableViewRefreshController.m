//
//  TableViewRefreshController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/5/6.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "TableViewRefreshController.h"
#import "tableViewModel.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define BarHeight 20

static int count = 10;

@interface TableViewRefreshController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) tableViewModel *model;
@property (nonatomic , strong) UITableView *tableView;

@end

@implementation TableViewRefreshController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.tableView];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.model addObserver:self forKeyPath:@"modelArray" options:NSKeyValueObservingOptionNew context:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.model.modelArray[indexPath.row];

    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSString *string = [NSString stringWithFormat:@"%d",count];
    [[self.model mutableArrayValueForKeyPath:@"modelArray"] addObject:string];
    count ++;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"modelArray"])
    {
        [self.tableView reloadData];
    }
}

#pragma mark - setter and getter
- (tableViewModel *)model
{
    if (!_model)
    {
        _model = [[tableViewModel alloc] init];
    }
    return _model;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 150, ScreenWidth, ScreenHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end
