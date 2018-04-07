//
//  ViewController.m
//  引用计数
//
//  Created by 杨世川 on 18/3/24.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "ViewController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define BarHeight 20

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataSoure;
@property (nonatomic,strong) NSMutableArray *sectionSource;
@property (nonatomic,strong) NSMutableArray *controllerSoure;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArray = self.controllerSoure[indexPath.section];
    Class viewControl = NSClassFromString(sectionArray[indexPath.row]);
    UIViewController *viewcontroller = [[viewControl alloc]init];
    [self.navigationController pushViewController:viewcontroller animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section
{
    NSArray *sectionArray = self.dataSoure[section];
    return sectionArray.count;
}

//设置每组的标题头
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionSource[section];
}

//设置每个cell的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    NSArray *sectionArray = self.dataSoure[indexPath.section];
    cell.textLabel.text = sectionArray[indexPath.row];

    return cell;
}

#pragma mark - Getters And Setters
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)sectionSource
{
    if (!_sectionSource)
    {
        _sectionSource = [[NSMutableArray alloc]initWithObjects:
                          @"引用计数",
                          @"Block",
                          @"GCD",
                          @"运行时",nil];
    }
    return _sectionSource;
}

- (NSMutableArray *)dataSoure
{
    if (!_dataSoure)
    {

        _dataSoure = [[NSMutableArray alloc]initWithObjects:
                      @[@"内存管理规则探究",
                        @"自动释放池内存探究",
                        @"MRC下研究autorelease",
                        @"ARC下研究autorelease",
                        @"ARC所有权修饰符研究",
                        @"引用计数数值例题",
                        @"属性关键字比较"],
                      @[@"Block基本语法",
                        @"截取变量",
                        @"截取对象",
                        @"Block内部实现",
                        @"Block存储区域",
                        @"block变量存储区域"],
                      @[@""],
                      @[@"isa指针详解",
                        @"objc_msgSend详解",],nil];
    }
    return _dataSoure;
}

- (NSMutableArray *)controllerSoure
{
    if (!_controllerSoure)
    {
        _controllerSoure = [[NSMutableArray alloc]initWithObjects:
                            @[@"RuleStudyViewController",
                              @"AutoReleaseMemoryViewController",
                              @"AutoReleaseMRCViewController",
                              @"AutoReleaseARCViewController",
                              @"ARCOwnershipViewListController",
                              @"ReferenceCountViewController",
                              @"AttributesCompareViewController"],
                            @[@"BlockSyntaxViewController",
                              @"InterceptedVariableController",
                              @"InterceptedObjectsController",
                              @"BlockAchieveViewController",
                              @"BlockStorageController",
                              @"blockVariableController"],
                            @[],
                            @[@"ISAViewController",
                              @"msgSendViewController",
                              @"MessageForwardingController"],nil];
    }
    return _controllerSoure;
}

@end



