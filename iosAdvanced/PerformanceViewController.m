//
//  PerformanceViewController.m
//  iosAdvanced
//
//  Created by 杨世川 on 2018/4/30.
//  Copyright © 2018年 杨世川. All rights reserved.
//

#import "PerformanceViewController.h"
#import "YYAdvancedCell.h"

typedef void(^RunloopBlock)(void);
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define BarHeight 20

@interface PerformanceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dataSource;

//任务
@property(nonatomic,strong)NSMutableArray *tasks;
//最大任务数
@property(assign,nonatomic)NSUInteger maxQueueLenght;

@property (nonatomic ,strong) NSTimer *timer;

@end

@implementation PerformanceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self initView];
    [self addObserver];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.timer = nil;
}

- (void)initView
{
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)addObserver
{
    self.maxQueueLenght = 15;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    [self addRunloopObserver];
}

#pragma mark - 定时器(激发runloop)
- (void)timerMethod
{
}

#pragma mark - 监听runloop
//添加Runloop观察者!!  CoreFoundtion 里面 Ref (引用)指针!!
-(void)addRunloopObserver
{
    //拿到当前的runloop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    //定义一个context
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)(self),
        &CFRetain,
        &CFRelease,
        NULL,
    };

    //定义观察
    static CFRunLoopObserverRef defaultModeObserver;
    //创建观察者
    defaultModeObserver = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &Callback, &context);
    //添加当前runloop的观察者!!
    CFRunLoopAddObserver(runloop, defaultModeObserver, kCFRunLoopDefaultMode);
    //C 语言里面Create相关的函数!创建出来的指针!需要释放
    CFRelease(defaultModeObserver);
}

#pragma mark - 回调函数
static void Callback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    //拿到控制器
    PerformanceViewController * vc = (__bridge PerformanceViewController *)info;
    if (vc.tasks.count == 0)
    {
        return;
    }
    RunloopBlock task = vc.tasks.firstObject;
    task();
    //干掉第一个任务
    [vc.tasks removeObjectAtIndex:0];
}

#pragma mark - 添加任务
- (void)addTask:(RunloopBlock)task
{
    //添加任务到数组!!
    [self.tasks addObject:task];
    if (self.tasks.count > self.maxQueueLenght)
    {
        [self.tasks removeObjectAtIndex:0];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:  (NSInteger)section
{
    return 399;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定cell的重用标识符
    static NSString *reuseIdentifier = @"CELL";
    //去缓存池找名叫reuseIdentifier的cell
    //这里换成自己定义的cell
    YYAdvancedCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //如果缓存池中没有,那么创建一个新的cell
     if (!cell)
     {
        //这里换成自己定义的cell,并调用类方法加载xib文件
        cell = [YYAdvancedCell xibTableViewCell];
     }

    [self addTask:^{
        cell.firstIView.image = [UIImage imageNamed:@"spaceship.jpg"];
    }];

    [self addTask:^{
        cell.secondIView.image = [UIImage imageNamed:@"spaceship.jpg"];
    }];

    [self addTask:^{
        cell.threeIView.image = [UIImage imageNamed:@"spaceship.jpg"];
    }];

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

- (NSMutableArray *)tasks
{
    if (!_tasks)
    {
        _tasks = [[NSMutableArray alloc] init];
    }
    return _tasks;
}


@end

//总结:
//1、刚开始卡顿
//  原因:runloop中既要处理滑动事件,还要处理图片(处理的事情太多了)
//
//2、[imageView performSelector:@selector(setImage:) withObject:image afterDelay:0 inModes:@[NSDefaultRunLoopMode]];
//  备注:可以保证在滑动起来顺畅,可是停下来之后,渲染还未完成时,继续滑动就会变的卡顿
//     :因为还是渲染了好多图片(虽然不用处理滑动事件了)
//
//3、不处理滑动事件,只处理渲染图片(但不是所有的图片,只处理当前屏幕的图片)
//   备注:上面例题就是这种方式
//
//参考文章
//1、RunLoop总结：RunLoop的应用场景（三）
//   https://blog.csdn.net/u011619283/article/details/53483965
//
//
//


