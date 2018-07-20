//
//  TestXibViewController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/7/20.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "TestXibViewController.h"
#import "XibCollectionViewCell.h"

//cell宽度
static float WWCellWidth = 100.0;
//cell高度
static float WWCellHeight = 50;

@interface TestXibViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

//列表
@property (nonatomic ,strong) UICollectionView *collectionView;
//布局
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
//数据源
@property (nonatomic ,strong) NSMutableArray *dataSource;

@end

@implementation TestXibViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)
collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XibCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XibCollectionViewCell" forIndexPath:indexPath];
    //赋值
    cell.titleLabel.text = self.dataSource[indexPath.row];
    cell.layer.borderColor = [UIColor redColor].CGColor;
    cell.layer.borderWidth = 1.0;

    return cell;
}

#pragma mark - Getter And Setter
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"XibCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"XibCollectionViewCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout)
    {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //设置UICollectionView中各单元格的大小
        _flowLayout.itemSize = CGSizeMake(WWCellWidth, WWCellHeight);
        //设置该UICollectionView只支持垂直方向
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置各分区上、下、左、右空白的大小
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //设置两行单元格之间的行距，即垂直方向的距离
        _flowLayout.minimumLineSpacing = 10;
        //设置两个单元格之间的间距
        _flowLayout.minimumInteritemSpacing = 10;
        //预估高度
        _flowLayout.estimatedItemSize = CGSizeMake(WWCellWidth, WWCellHeight);
    }
    return _flowLayout;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [[NSMutableArray alloc] initWithObjects:
                       @"1111111111",nil];
    }
    return _dataSource;
}


//- (NSMutableArray *)dataSource
//{
//    if (!_dataSource)
//    {
//        _dataSource = [[NSMutableArray alloc] initWithObjects:
//                       @"1111111111",
//                       @"22222222222222",
//                       @"3333333333",
//                       @"444444444444444444444444444444444444444444444444444444",
//                       @"555555555555555",
//                       @"6666666666",
//                       @"77777777777",
//                       @"8888888",
//                       @"999999",
//                       @"1010100101010",nil];
//    }
//    return _dataSource;
//}


@end
