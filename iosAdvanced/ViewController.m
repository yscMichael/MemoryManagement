//
//  ViewController.m
//  引用计数
//
//  Created by 杨世川 on 18/3/24.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "ViewController.h"
#import "HeaderViewInSection.h"

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

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 120, 64, 100, 40)];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"滚动底部" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(scrollToBottom) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark - 滚动到底部
- (void)scrollToBottom
{
    //第一种方法
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:YES];
    }

    //第二种方法
    //这里一定要设置为NO,动画可能会影响到scrollerView
    //导致增加数据源之后,tableView到处乱跳
    //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSoure.count - 1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *idString = @"SectionViewID";
    HeaderViewInSection *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:idString];
    if (!sectionView)
    {
        sectionView = [[HeaderViewInSection alloc] initWithReuseIdentifier:idString];
    }
    sectionView.title = self.sectionSource[section];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //设置title区域高度
    return 40.f;
}

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
//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return self.sectionSource[section];
//}

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
                          @"NSOperation",
                          @"runtime知识详解",
                          @"runloop知识详解",
                          @"响应链知识补充",
                          @"AFNetworking使用详解",
                          @"布局相关",
                          @"三方框架相关",
                          @"UI控件相关",
                          @"面试题",nil];
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
                        @"Block_Copy对引用计数影响",
                        @"Block内部实现",
                        @"Block存储区域MRC",
                        @"Block存储区域ARC",
                        @"block变量存储区域和对象修饰符",
                        @"block例题MRC",
                        @"block例题ARC"],
                      @[@"GCD基础知识",
                        @"Dispatch Target",
                        @"Dispatch After",
                        @"Dispatch Group",
                        @"Dispatch Barrier",
                        @"Dispatch Sync",
                        @"Dispatch Apply",
                        @"Dispatch Suspend",
                        @"Dispatch Semaphore",
                        @"Dispatch Once"],
                      @[@"NSOperation基础知识",
                        @"Invocation Operation",
                        @"Block Operation",
                        @"Custom Operation",
                        @"OperationQueue Main",
                        @"OperationQueue Custom",
                        @"Operation Depend",
                        @"Operation queuePriority",
                        @"Queue Communication",
                        @"Thread Insecure",
                        @"Operation Attributes",
                        @"Queue Attributes"],
                      @[@"runtime基础知识",
                        @"动态交换方法",
                        @"给分类动态添加属性",
                        @"字典转模型的自动转换",
                        @"动态添加方法",
                        @"实现NSCoding的自动归档和解档",
                        @"objc_msgSend解析",
                        @"消息转发",
                        @"isa指针解析"],
                      @[@"runloop基础知识",
                        @"子线程存活",
                        @"NSTimer正常运转",
                        @"tableView卡顿",
                        @"tableView性能优化"],
                      @[@"响应链知识讲解"],
                      @[@"AFNetworking使用详解"],
                      @[@"Xib自定义View"],
                      @[@"MJExtension使用"],
                      @[@"TableViewCell之工厂模式",
                        @"工厂模式项目实践",
                        @"转场动画View",
                        @"分段控制器",
                        @"UICollectionView--代码",
                        @"UICollectionView--xib"],
                      @[@"load和initialize细节",
                        @"synthesize和dynamic",
                        @"成员变量和实例变量区别",
                        @"SDWebImage源码解析",
                        @"AFNetworking3.0对比",
                        @"Swift混编",
                        @"NSTimer相关",
                        @"KVO相关使用",
                        @"KVC基础知识",
                        @"js与oc交互",
                        @"八种锁"],nil];
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
                              @"InterceptedObjectsMRCController",
                              @"BlockAchieveViewController",
                              @"BlockStorageMRCController",
                              @"BlockStorageARCController",
                              @"blockVariableController",
                              @"ExampleBlockMRCController",
                              @"ExampleBlockARCController"],
                            @[@"CGDBasicViewController",
                              @"DispatchTargetViewController",
                              @"DispatchAfterViewController",
                              @"DispatchGroupViewController",
                              @"DispatchBarrierController",
                              @"DispatchSyncViewController",
                              @"DispatchApplyViewController",
                              @"DispatchSuspendController",
                              @"DispatchSemaphoreController",
                              @"DispatchOnceViewController"],
                            @[@"NSOperationBasicViewController",
                              @"InvocationOperationController",
                              @"BlockOperationViewController",
                              @"CustomOperationController",
                              @"OperationQueueMainController",
                              @"OperationQueueCustomController",
                              @"OperationDependViewController",
                              @"OperationqueuePriorityController",
                              @"QueueCommunicationController",
                              @"ThreadInsecureViewController",
                              @"OperationAttributesController",
                              @"QueueAttributesViewController"],
                            @[@"RunTimeBasicViewController",
                              @"SwizzlingMethodViewController",
                              @"CategoryAttributesController",
                              @"DictionaryToModelController",
                              @"DynamicAddMethodController",
                              @"NSCodingMethodController",
                              @"msgSendViewController",
                              @"MessageForwardingController",
                              @"ISAViewController"],
                            @[@"RunLoopBasicViewController",
                              @"NSThreadViewController",
                              @"NSTimerRunLoopController",
                              @"BasicTableViewController",
                              @"PerformanceViewController"],
                            @[@"ResponseChainViewController"],
                            @[@"AFNetworkingViewController"],
                            @[@"XibViewShowController"],
                            @[@"MJExtensionViewController"],
                            @[@"TableViewCellFactoryController",
                              @"PracticeFactoryController",
                              @"LoadViewController",
                              @"SegmentedViewController",
                              @"TestCollectionViewController",
                              @"TestXibViewController"],
                            @[@"LoadAndInitializeViewController",
                              @"synthesizeAndDynamicController",
                              @"VariablesDifferenceController",
                              @"SDWebImageBasicController",
                              @"AFNetworkingThreeController",
                              @"SwiftMixingViewController",
                              @"NSTimerListViewController",
                              @"KVOMainViewController",
                              @"KVCBasicViewController",
                              @"JsAndOCListViewController",
                              @"LockListViewController"],nil];
    }
    return _controllerSoure;
}

@end



