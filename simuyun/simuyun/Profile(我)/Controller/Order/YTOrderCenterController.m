//
//  YTOrderCenterController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/23.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTOrderCenterController.h"
#import "YTOrderCenterCell.h"
#import "YTAccountTool.h"
#import "YTOrderCenterModel.h"
#import "UIBarButtonItem+Extension.h"
#import "BFNavigationBarDrawer.h"
#import "MJRefresh.h"


@interface YTOrderCenterController () <UITableViewDataSource, UITableViewDelegate, BarDrawerDelegate>

/**
 *  记录当前页码
 */
@property (nonatomic, assign) int pageno;

/**
 *  订单数据
 */
@property (nonatomic, strong) NSMutableArray *orders;

/**
 *  下拉菜单
 */
@property (nonatomic, strong) BFNavigationBarDrawer *drawerMenu;

/**
 *  已选则分类status
 */
@property (nonatomic, copy) NSString *status;


@end

@implementation YTOrderCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化tableView
    [self setupTableView];
    
    // 初始化Item
    [self setupItem];
    
    
}
/**
 *  初始化tableView
 */
- (void)setupTableView
{
    self.title = @"订单中心";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // 设置颜色
    self.tableView.backgroundColor = YTGrayBackground;
    // 去掉下划线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // 设置下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewOrder)];
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreOrder)];
}

/**
 *  初始化Item
 */
- (void)setupItem
{
    BFNavigationBarDrawer *drawerMenu = [[BFNavigationBarDrawer alloc] init];
    drawerMenu.scrollView = self.tableView;
    drawerMenu.delegate = self;
    self.drawerMenu = drawerMenu;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithBg:@"saixuan" highBg:@"saixuananxia" target:self action:@selector(rightClick)];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithBg:@"fanhui" target:self action:@selector(blackVc)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 修正tableView的大小
    self.tableView.size = CGSizeMake(self.tableView.width, self.tableView.height + 44);
}
/**
 *  返回按钮
 */
- (void)blackVc
{
    [self.drawerMenu hideAnimated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  右侧菜单
 */
- (void)rightClick
{
    self.tableView.header = nil;
    [self.drawerMenu showFromNavigationBar:self.navigationController.navigationBar animated:YES];
    
}
/**
 *  选中的按钮
 *
 */
- (void)selectedBtnWithType:(btnType)btnType
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewOrder)];
    switch (btnType) {
        case btnTypeQuanBu:
            self.status = nil;
            break;
        case btnTypeDaiBaoBei:
            self.status = @"[20, 50]";
            break;
        case btnTypeQueRenZhong:
            self.status = @"[40]";
            break;
        case btnTypeYiQueRen:
            self.status = @"[80]";
            break;
        case btnTypeYiShiXiao:
            self.status = @"[60, 90]";
            break;
    }
    [self.tableView.header beginRefreshing];
}

#pragma mark - 加载数据
/**
 *  加载新的订单数据
 */
- (void)loadNewOrder
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"advisers_id"] = [YTAccountTool account].userId;
    if (self.status == nil) {
        dict[@"status"] = @"[20, 50, 40, 60, 80, 90]";
    } else {
        dict[@"status"] = self.status;
    }
    dict[@"pagesize"] = @20;
    self.pageno = 1;
    dict[@"pageno"] = @(self.pageno);
    [YTHttpTool get:YTOrders params:dict success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        self.orders = [YTOrderCenterModel objectArrayWithKeyValuesArray:responseObject];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}

/**
 *  加载更多订单数据
 */
- (void)loadMoreOrder
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"advisers_id"] = [YTAccountTool account].userId;
    if (self.status == nil) {
        dict[@"status"] = @"[20, 50, 40, 60, 80, 90]";
    } else {
        dict[@"status"] = self.status;
    }
    dict[@"pagesize"] = @20;
    dict[@"pageno"] = @(self.pageno++);
    [YTHttpTool get:YTOrders params:dict success:^(id responseObject) {
        [self.orders addObjectsFromArray:[YTOrderCenterModel objectArrayWithKeyValuesArray:responseObject]];
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.footer endRefreshing];
    }];
}


#pragma mark - tableViewDatasoruce & tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"OrderCenterCell";
    YTOrderCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell =[YTOrderCenterCell orderCenterCell];
    }
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = YES;
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = YTColor(208, 208, 208).CGColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.order = self.orders[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YTOrderCenterModel *orderModel = self.orders[indexPath.section];
    if (orderModel.buy_net == 0 || orderModel.buy_shares.length > 0) {
        return 125;
    }
    return 145;
}

// 设置section的数目，即是你有多少个cell
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.orders.count;
}
// 设置cell之间headerview的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8.0; // you can have your own choice, of course
}
// 设置headerview的颜色
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    YTBuyProductController *buy = [[YTBuyProductController alloc] init];
//    buy.hidesBottomBarWhenPushed = YES;
//    buy.product = self.products[indexPath.section];
//    [self.navigationController pushViewController:buy animated:YES];
}

#pragma mark - lazy
- (NSArray *)orders
{
    if (!_orders) {
        _orders = [[NSMutableArray alloc] init];
    }
    return _orders;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
