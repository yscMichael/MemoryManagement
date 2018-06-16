//
//  ProfileViewModel.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/6/16.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "ProfileViewModel.h"
#import "ProfileModel.h"

typedef NS_ENUM (NSInteger , ProfileViewModelItemType){
    nameAndPicture,
    about,
    email,
    friend,
    attribute
};

#pragma mark - Item的基类
@interface ProfileViewModelItem : NSObject
//类型
@property (nonatomic,assign) ProfileViewModelItemType type;
//每组标题
@property (nonatomic,strong) NSString *sectionTitle;
//每组多少行
@property (nonatomic,assign) int rowCount;
@end

#pragma mark - Item<姓名和图片>
@interface ProfileViewModelNamePictureItem : ProfileViewModelItem
//姓名
@property (nonatomic ,copy) NSString *name;
//图片
@property (nonatomic ,copy) NSString *pictureUrl;
- (instancetype)initWithModel:(ProfileModel *)model;
@end

@implementation ProfileViewModelNamePictureItem
- (instancetype)initWithModel:(ProfileModel *)model
{
    if (self = [super init])
    {
        self.type = nameAndPicture;
        self.sectionTitle = @"Main Info";
        self.rowCount = 1;
        self.name = model.fullName;
        self.pictureUrl = model.pictureUrl;
    }
    return self;
}
@end

#pragma mark - Item<about>
@interface ProfileViewModelAboutItem : ProfileViewModelItem
//about
@property (nonatomic ,copy) NSString *about;
- (instancetype)initWithModel:(ProfileModel *)model;
@end

@implementation ProfileViewModelAboutItem
- (instancetype)initWithModel:(ProfileModel *)model
{
    if (self = [super init])
    {
        self.type = about;
        self.sectionTitle = @"About";
        self.rowCount = 1;
        self.about = model.about;
    }
    return self;
}
@end

#pragma mark - Itme<email>
@interface ProfileViewModelEmailItem : ProfileViewModelItem
//email
@property (nonatomic ,copy) NSString *email;
- (instancetype)initWithModel:(ProfileModel *)model;
@end

@implementation ProfileViewModelEmailItem
- (instancetype)initWithModel:(ProfileModel *)model
{
    if (self = [super init])
    {
        self.type = email;
        self.sectionTitle = @"Email";
        self.rowCount = 1;
        self.email = model.email;
    }
    return self;
}

@end

#pragma mark - Item<Attribute>
@interface ProfileViewModeAttributeItem : ProfileViewModelItem
//attribute
@property (nonatomic,strong) NSArray *attribute;
- (instancetype)initWithModel:(ProfileModel *)model;
@end

@implementation ProfileViewModeAttributeItem
- (instancetype)initWithModel:(ProfileModel *)model
{
    if (self = [super init])
    {
        self.type = attribute;
        self.sectionTitle = @"Attributes";
        self.rowCount = (int)model.profileAttributes.count;
        self.attribute = model.profileAttributes;
    }
    return self;
}
@end

#pragma mark - Item<Friends>
@interface ProfileViewModeFriendsItem : ProfileViewModelItem
//friends
@property (nonatomic,strong) NSArray *friends;
- (instancetype)initWithModel:(ProfileModel *)model;
@end

@implementation ProfileViewModeFriendsItem
- (instancetype)initWithModel:(ProfileModel *)model
{
    if (self = [super init])
    {
        self.type = friend;
        self.sectionTitle = @"Friends";
        self.rowCount = (int)model.friends.count;
        self.friends = model.friends;
    }
    return self;
}

@end

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取类型
    ProfileViewModelItem *item = self.dataSource[indexPath.section];
    switch (item.type)
    {
        case nameAndPicture:
            //
            break;
        case about:
            //
            break;
        case email:
            //
            break;
        case friend:
            //
            break;
        case attribute:
            //
            break;
        default:
            break;
    }

    UITableViewCell *cell;

    return cell;
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
