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
#import "MJRefresh.h"
#import "YTTabBarController.h"
#import "YTOrderdetailController.h"
#import "NSDate+Extension.h"
#import "YTDataHintView.h"
#import "YTUserInfoTool.h"
#import "SVProgressHUD.h"
#import "YTRedeemptionController.h"


@interface YTOrderCenterController () <UITableViewDataSource, UITableViewDelegate, BarDrawerDelegate, SWTableViewCellDelegate, UIAlertViewDelegate>

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
 *  数据状态提示
 */
@property (nonatomic, weak) YTDataHintView *hintView;


/**
 *  选中的订单索引
 */
@property (nonatomic, strong) NSIndexPath *selectedIndex;

/**
 *  保存上次侧滑的Cell
 */
@property (nonatomic, weak) SWTableViewCell *selectedCell;

@end

@implementation YTOrderCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化提醒视图
    [self setupHintView];
    
    // 初始化tableView
    [self setupTableView];
    
    // 初始化Item
    [self setupItem];
}

/**
 *  初始化提醒视图
 */
- (void)setupHintView
{
    YTDataHintView *hintView =[[YTDataHintView alloc] init];
    CGPoint center = CGPointMake(self.tableView.centerX, self.tableView.centerY - 55);
    [hintView showLoadingWithInView:self.view tableView:self.tableView center:center];
    hintView.isRemove = YES;
    self.hintView = hintView;
}

/**
 *  提醒报备状态
 *
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isOrder)
    {
        [SVProgressHUD showSuccessWithStatus:@"报备成功"];
        self.isOrder = NO;
    }
    [MobClick event:@"orderList_click" attributes:@{@"按钮" : @"订单列表", @"机构" : [YTUserInfoTool userInfo].organizationName}];
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
    self.tableView.footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreOrder)];
}

/**
 *  初始化Item
 */
- (void)setupItem
{
    BFNavigationBarDrawer *drawerMenu = [[BFNavigationBarDrawer alloc] initWithisYiQueRen:self.isYiQueRen];
    drawerMenu.scrollView = self.tableView;
    drawerMenu.delegate = self;
    self.drawerMenu = drawerMenu;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithBg:@"saixuan" target:self action:@selector(rightClick)];
    // 初始化左侧返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithBg:@"fanhui" target:self action:@selector(blackClick)];
}

- (void)blackClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


/**
 *  右侧菜单
 */
- (void)rightClick
{
    self.tableView.header.hidden = YES;
    
    [self.drawerMenu showFromNavigationBar:self.navigationController.navigationBar animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.drawerMenu hideAnimated:NO];
}
/**
 *  选中的按钮
 *
 */
- (void)selectedBtnWithType:(btnType)btnType
{

    self.tableView.header.hidden = NO;
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
    [self.orders removeAllObjects];
    [self.tableView reloadData];
    [self.hintView switchContentTypeWIthType:contentTypeLoading];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"advisers_id"] = [YTAccountTool account].userId;
    if (self.status == nil) {
        dict[@"status"] = @"[20, 50, 40, 60, 80, 90]";
    } else {
        dict[@"status"] = self.status;
    }
    dict[@"pagesize"] = @10;
    self.pageno = 1;
    dict[@"pageno"] = @(self.pageno);
    [YTHttpTool get:YTOrders params:dict success:^(id responseObject) {
        [self.tableView.footer resetNoMoreData];
        self.orders = [YTOrderCenterModel objectArrayWithKeyValuesArray:responseObject];
        if([ self.orders count] < 10)
        {
            [self.tableView.footer noticeNoMoreData];
        }
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.hintView changeContentTypeWith:self.orders];
    } failure:^(NSError *error) {
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.hintView ContentFailure];
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
    dict[@"pagesize"] = @10;
    dict[@"pageno"] = @(++self.pageno);
    [YTHttpTool get:YTOrders params:dict success:^(id responseObject) {
        [self.tableView.footer endRefreshing];
        if([(NSArray *)responseObject count] == 0)
        {
            [self.tableView.footer noticeNoMoreData];
        }
        [self.orders addObjectsFromArray:[YTOrderCenterModel objectArrayWithKeyValuesArray:responseObject]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.footer endRefreshing];
    }];
}


#pragma mark - tableViewDatasoruce & tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YTOrderCenterCell *cell = nil;
    YTOrderCenterModel *order = self.orders[indexPath.section];
    if (order.status == 20 || order.status == 60 || order.status == 90) {
        static NSString *deleteCell = @"deleteOrderCell";
        cell = [tableView dequeueReusableCellWithIdentifier:deleteCell];
        if (cell==nil) {
            cell =[YTOrderCenterCell orderCenterCell];
            cell.layer.cornerRadius = 5;
            cell.layer.masksToBounds = YES;
            cell.layer.borderWidth = 1.0f;
            cell.layer.borderColor = YTColor(208, 208, 208).CGColor;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.rightUtilityButtons = [self deleteButton];
            cell.delegate = self;
        }
    } else {    // 不可删除的Cell
        static NSString *detailCell = @"detailOrderCell";
        cell = [tableView dequeueReusableCellWithIdentifier:detailCell];
        if (cell==nil) {
            cell =[YTOrderCenterCell orderCenterCell];
            cell.layer.cornerRadius = 5;
            cell.layer.masksToBounds = YES;
            cell.layer.borderWidth = 1.0f;
            cell.layer.borderColor = YTColor(208, 208, 208).CGColor;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.rightUtilityButtons = [self detailButton];
            cell.delegate = self;
        }
    }
    
    cell.order = order;
    return cell;
}
/**
 *  删除按钮
 */
- (NSArray *)deleteButton
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:YTNavBackground icon:[UIImage imageNamed:@"deletetodo"] title:@"删除"];
    
    return rightUtilityButtons;
}
/**
 *  删除按钮
 */
- (NSArray *)detailButton
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:YTColor(208, 208, 208) icon:nil title:@"查看详情"];
    
    return rightUtilityButtons;
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    // 要删除的行
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    // 获订单模型
    YTOrderCenterModel *order = self.orders[cellIndexPath.section];
    if (order.status == 20 || order.status == 60 || order.status == 90) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除此订单么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        self.selectedIndex = cellIndexPath;
    } else {
        [self.selectedCell hideUtilityButtonsAnimated:YES];
        self.selectedCell.isShow = NO;
        [self.tableView deselectRowAtIndexPath:cellIndexPath animated:YES];
        YTOrderCenterModel *order = self.orders[cellIndexPath.section];
        YTOrderdetailController *detail = [[YTOrderdetailController alloc] init];
        detail.url = [NSString stringWithFormat:@"%@/order%@&id=%@", YTH5Server, [NSDate stringDate], order.order_id];
        detail.order = self.orders[cellIndexPath.section];
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
        [MobClick event:@"orderDetail_click" attributes:@{ @"按钮" : @"查看订单详情", @"机构" : [YTUserInfoTool userInfo].organizationName}];
    }
}
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{

    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    if (!self.selectedCell.isShow && self.selectedCell != cell) {
        self.selectedCell = cell;
        self.selectedCell.isShow = YES;
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 删除订单
    if (buttonIndex == 1) {
        [self deleteOrder];
    }
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
//    if (self.selectedCell.isShow) {
//        [self.selectedCell hideUtilityButtonsAnimated:YES];
//        self.selectedCell.isShow = NO;
//        return;
//    }
//    self.selectedCell = nil;
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    YTOrderCenterModel *order = self.orders[indexPath.section];
//    YTOrderdetailController *detail = [[YTOrderdetailController alloc] init];
//    detail.url = [NSString stringWithFormat:@"%@/order%@&id=%@", YTH5Server, [NSDate stringDate], order.order_id];
//    detail.order = self.orders[indexPath.section];
//    detail.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detail animated:YES];
//    [MobClick event:@"orderDetail_click" attributes:@{ @"按钮" : @"查看订单详情", @"机构" : [YTUserInfoTool userInfo].organizationName}];
    
#warning 测试
    YTRedeemptionController *VC = [[YTRedeemptionController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

// 发送请求删除订单
- (void)deleteOrder
{
    YTOrderCenterModel *order = self.orders[self.selectedIndex.section];
    [self.orders removeObjectAtIndex:self.selectedIndex.section];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:self.selectedIndex.section];
    [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    self.selectedCell = nil;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"adviser_id"] = [YTAccountTool account].userId;
    param[@"order_id"] = order.order_id;
    [YTHttpTool post:YTdeleteOrder params:param success:^(id responseObject) {
        if (self.orders.count < 8)
        {
            [self.tableView.footer beginRefreshing];
        }
    } failure:^(NSError *error) {
    }];
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
