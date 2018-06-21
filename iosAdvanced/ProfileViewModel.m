//
//  ProfileViewModel.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/16.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "ProfileViewModel.h"
#import "ProfileViewModelNamePictureItem.h"
#import "ProfileViewModelAboutItem.h"
#import "ProfileViewModelEmailItem.h"
#import "ProfileViewModeFriendsItem.h"
#import "ProfileViewModeAttributeItem.h"
#import "ProfileModel.h"

#pragma mark - ProfileViewModel
@interface ProfileViewModel ()
//数据源
@property (nonatomic,strong) NSMutableArray *dataSource;
//本地json数据
@property (nonatomic,strong) NSMutableDictionary *jsonData;
//profileModel
@property (nonatomic,strong) ProfileModel *profileModel;
@end

@implementation ProfileViewModel
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        //读取文件
        [self readDataFromJson];
        //处理模型和item
        [self dealModel];
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ProfileViewModelItem *item = self.dataSource[section];
    return item.rowCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    ProfileViewModelItem *item = self.dataSource[section];
    return item.sectionTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取类型
    ProfileViewModelItem *item = self.dataSource[indexPath.section];
    switch (item.type)
    {//Object-C在case块中声明变量需要用大括号包围，如果没有变量声明就不需要了
        case nameAndPicture:
        {//姓名和图片
            NamePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:[NamePictureCell identifier]];
            cell.item = (ProfileViewModelNamePictureItem *)self.dataSource[indexPath.section];
            return cell;
        }
        break;
        case about:
        {//about
            AboutCell *about = [tableView dequeueReusableCellWithIdentifier:[AboutCell identifier]];
            about.item = (ProfileViewModelAboutItem *)self.dataSource[indexPath.section];
            return about;
        }
        break;
        case email:
        {//email
            EmailCell *email = [tableView dequeueReusableCellWithIdentifier:[EmailCell identifier]];
            email.item = (ProfileViewModelEmailItem *)self.dataSource[indexPath.section];
            return email;
        }
        break;
        case friend:
        {//friend
            FriendCell *friendCell = [tableView dequeueReusableCellWithIdentifier:[FriendCell identifier]];
            ProfileViewModeFriendsItem *friendItem = self.dataSource[indexPath.section];
            NSArray *friends = friendItem.friends;
            friendCell.item = friends[indexPath.row];
            return friendCell;
        }
        break;
        case attribute:
        {//attribute
            AttributeCell *attributeCell = [tableView dequeueReusableCellWithIdentifier:[AttributeCell identifier]];
            ProfileViewModeAttributeItem *attributeItem = self.dataSource[indexPath.section];
            NSArray *attributes = attributeItem.attribute;
            attributeCell.item = attributes[indexPath.row];
            return attributeCell;
        }
        break;
        default:
            break;
    }

    return nil;
}

#pragma mark - Private Methods
#pragma mark - 读取数据
- (void)readDataFromJson
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ServerData.json" ofType:nil];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSMutableDictionary *temp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    //拼接字典
    [self.jsonData addEntriesFromDictionary:temp];
}

#pragma mark - 处理模型
- (void)dealModel
{
    ProfileModel *profileModel = [ProfileModel jsonToModelWithDict:self.jsonData];
    self.profileModel = profileModel;
    //1、名字和图片
    ProfileViewModelNamePictureItem *nameAndPicture = [[ProfileViewModelNamePictureItem alloc] initWithModel:profileModel];
    [self.dataSource addObject:nameAndPicture];
    //2、About
    ProfileViewModelAboutItem *about = [[ProfileViewModelAboutItem alloc] initWithModel:profileModel];
    [self.dataSource addObject:about];
    //3、Email
    ProfileViewModelEmailItem *email = [[ProfileViewModelEmailItem alloc] initWithModel:profileModel];
    [self.dataSource addObject:email];
    //4、Attribute
    ProfileViewModeAttributeItem *attribute = [[ProfileViewModeAttributeItem alloc] initWithModel:profileModel];
    [self.dataSource addObject:attribute];
    //5、Friends
    ProfileViewModeFriendsItem *friends = [[ProfileViewModeFriendsItem alloc] initWithModel:profileModel];
    [self.dataSource addObject:friends];
}

#pragma mark - 代理方法
#pragma mark - 名字代理


#pragma mark - 其它代理







#pragma mark - Getter And Setter
- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableDictionary *)jsonData
{
    if (!_jsonData)
    {
        _jsonData = [[NSMutableDictionary alloc] init];
    }
    return _jsonData;
}

- (ProfileModel *)profileModel
{
    if (!_profileModel)
    {
        _profileModel = [[ProfileModel alloc] init];
    }
    return _profileModel;
}

@end
