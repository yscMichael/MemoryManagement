//
//  PracticeFactoryController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/18.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "PracticeFactoryController.h"
#import "PatientViewModel.h"
#import "MJExtension.h"

#import "NameCell.h"
#import "SelectYesOrNoCell.h"
#import "AgeInputCell.h"
#import "NumberInputCell.h"
#import "ChoosePopViewCell.h"
#import "SelectRelationshipCell.h"
#import "StringInputCell.h"

#import "PatientBaseItem.h"
#import "NameItem.h"
#import "SelectYesOrNoItem.h"
#import "AgeInputItem.h"
#import "NumberInputItem.h"
#import "ChoosePopViewItem.h"
#import "SelectRelationshipItem.h"
#import "StringInputItem.h"

@interface PracticeFactoryController ()<UITableViewDelegate,UITableViewDataSource>
//列表
@property (nonatomic,strong) UITableView *tableView;
//数据源
@property (nonatomic,strong) NSMutableArray *dataSource;
//模型
@property (nonatomic,strong) PatientModel *patientModel;
//item
@property (nonatomic,strong) PatientBaseItem *patientBaseItem;
@property (nonatomic,strong) PatientViewModel *patientViewModel;
@end

@implementation PracticeFactoryController

#pragma mark - Cycle Life
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    [self initData];
}

- (void)initViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    //姓名
    [self.tableView registerNib:[NameCell nib] forCellReuseIdentifier:[NameCell identifier]];
    //性别、孕妇、监护人
    [self.tableView registerNib:[SelectYesOrNoCell nib] forCellReuseIdentifier:[SelectYesOrNoCell identifier]];
    //年龄
    [self.tableView registerNib:[AgeInputCell nib] forCellReuseIdentifier:[AgeInputCell identifier]];
    //联系方式、体重
    [self.tableView registerNib:[NumberInputCell nib] forCellReuseIdentifier:[NumberInputCell identifier]];
    //过敏史、血型、所在地区
    [self.tableView registerNib:[ChoosePopViewCell nib] forCellReuseIdentifier:[ChoosePopViewCell identifier]];
    //与患者关系
    [self.tableView registerNib:[SelectRelationshipCell nib] forCellReuseIdentifier:[SelectRelationshipCell identifier]];
    //所在地区、详细地址
    [self.tableView registerNib:[StringInputCell nib] forCellReuseIdentifier:[StringInputCell identifier]];
}

- (void)initData
{//备注:真实项目中传过来的数据已经转换为模型了,不需要再次处理数据
    //1、读取数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Patient.json" ofType:nil];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSMutableDictionary *temp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    //2、转化模型
    [PatientModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"patientId":@"id"};
    }];
    self.patientModel = [PatientModel mj_objectWithKeyValues:temp];
}

#pragma mark - 处理Item
- (void)dealItemWithPatientModel:(PatientModel *)patientModel
{
    [self.patientViewModel dealItemWithPatientModel:self.patientModel Success:^(NSArray<PatientBaseItem *> *result) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:result];
    }];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatientBaseItem *item = self.dataSource[indexPath.section];
    if ([item.titleString isEqualToString:@"过敏史"])
    {//过敏史

    }
    else if([item.titleString isEqualToString:@"血型"])
    {//血型

    }
    else
    {//所在地区

    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PatientBaseItem *item = self.dataSource[section];
    return item.rowCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    PatientBaseItem *item = self.dataSource[section];
    return item.sectionTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取类型
    PatientBaseItem *item = self.dataSource[indexPath.section];
    switch (item.type)
    {
        case PatientItemTypeName:
        {//姓名
            NameCell *cell = [tableView dequeueReusableCellWithIdentifier:[NameCell identifier]];
            cell.item = (NameItem *)self.dataSource[indexPath.section];
            return cell;
        }
            break;
        case PatientItemTypeSelectYesOrNo:
        {//性别、孕妇、陪护人
            SelectYesOrNoCell *cell = [tableView dequeueReusableCellWithIdentifier:[SelectYesOrNoCell identifier]];
            cell.item = (SelectYesOrNoItem *)self.dataSource[indexPath.section];
            return cell;
        }
            break;
        case PatientItemTypeAge:
        {//年龄
            AgeInputCell *cell = [tableView dequeueReusableCellWithIdentifier:[AgeInputCell identifier]];
            cell.item = (AgeInputItem *)self.dataSource[indexPath.section];
            return cell;
        }
            break;
        case PatientItemTypeNumber:
        {//联系方式、体重
            NumberInputCell *cell = [tableView dequeueReusableCellWithIdentifier:[NumberInputCell identifier]];
            cell.item = (NumberInputItem *)self.dataSource[indexPath.section];
            return cell;
        }
            break;
        case PatientItemTypeChoosePopView:
        {//过敏史、血型、所在地区
            ChoosePopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ChoosePopViewCell identifier]];
            //这里要设置block
            cell.item = (ChoosePopViewItem *)self.dataSource[indexPath.section];;
            return cell;
        }
            break;
        case PatientItemTypeSelectRelationship:
        {//与患者关系
            SelectRelationshipCell *cell = [tableView dequeueReusableCellWithIdentifier:[ChoosePopViewCell identifier]];
            cell.item = (SelectRelationshipItem *)self.dataSource[indexPath.section];;
            return cell;
        }
            break;
        case PatientItemTypeStringInput:
        {//所在地区、详细地址
            StringInputCell *cell = [tableView dequeueReusableCellWithIdentifier:[ChoosePopViewCell identifier]];
            cell.item = (StringInputItem *)self.dataSource[indexPath.section];;
            return cell;
        }
            break;
        default:
            break;
    }

    return nil;
}

#pragma mark - Getters And Setters
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, BarHeight, ScreenWidth, ScreenHeight - BarHeight)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //iOS11.0需要设置
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
    }
    return _tableView;
}

- (PatientBaseItem *)patientBaseItem
{
    if (!_patientBaseItem)
    {
        _patientBaseItem = [[PatientBaseItem alloc] init];
    }
    return _patientBaseItem;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (PatientModel *)patientModel
{
    if (!_patientModel)
    {
        _patientModel = [[PatientModel alloc] init];
    }
    return _patientModel;
}

- (PatientViewModel *)patientViewModel
{
    if (!_patientViewModel)
    {
        _patientViewModel = [[PatientViewModel alloc] init];
    }
    return _patientViewModel;
}

@end


