//
//  TableViewCellFactoryController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/16.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "TableViewCellFactoryController.h"
#import "ProfileViewModel.h"
#import "NamePictureCell.h"
#import "AboutCell.h"
#import "FriendCell.h"
#import "AttributeCell.h"
#import "EmailCell.h"

@interface TableViewCellFactoryController ()

@property (nonatomic ,strong) ProfileViewModel *profileViewModel;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation TableViewCellFactoryController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.tableView.dataSource = self.profileViewModel;
    self.tableView.delegate = self.profileViewModel;
//    self.tableView.estimatedRowHeight = 200;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[NamePictureCell nib] forCellReuseIdentifier:[NamePictureCell identifier]];
    [self.tableView registerNib:[AboutCell nib] forCellReuseIdentifier:[AboutCell identifier]];
    [self.tableView registerNib:[FriendCell nib] forCellReuseIdentifier:[FriendCell identifier]];
    [self.tableView registerNib:[AttributeCell nib] forCellReuseIdentifier:[AttributeCell identifier]];
    [self.tableView registerNib:[EmailCell nib] forCellReuseIdentifier:[EmailCell identifier]];
    [self.view addSubview:self.tableView];
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

- (ProfileViewModel *)profileViewModel
{
    if (!_profileViewModel)
    {
        _profileViewModel = [[ProfileViewModel alloc] init];
    }
    return _profileViewModel;
}

@end


