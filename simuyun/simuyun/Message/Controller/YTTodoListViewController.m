//
//  YTTodoListViewController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/31.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTTodoListViewController.h"
#import "MJRefresh.h"
#import "YTTodoViewCell.h"
#import "YTAccountTool.h"
#import "YTMessageModel.h"
#import "YTNormalWebController.h"
#import "NSDate+Extension.h"
#import "YTUserInfoTool.h"
#import "NSString+Extend.h"
#import "YTDataHintView.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "YTMessageNumTool.h"

@interface YTTodoListViewController () <SWTableViewCellDelegate>
// 起始页
@property (nonatomic, assign) int pageNo;

@property (nonatomic, strong) NSMutableArray *messages;
/**
 *  数据状态提示
 */
@property (nonatomic, weak) YTDataHintView *hintView;

/**
 *  保存上次侧滑的Cell
 */
@property (nonatomic, weak) SWTableViewCell *selectedCell;

@end

@implementation YTTodoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.backgroundColor = YTGrayBackground;
    self.title = @"待办事项";

    // 去掉下划线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -34, 0);
    // 设置下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewChat)];
    
    // 下拉刷新
    self.tableView.footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreChat)];
   
    // 初始化提醒视图
    [self setupHintView];
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
    
}

/**
 *  初始化提醒视图
 */
- (void)setupHintView
{
    YTDataHintView *hintView =[[YTDataHintView alloc] init];
    CGPoint center = CGPointMake(self.tableView.centerX, self.tableView.centerY - 100);
    [hintView showLoadingWithInView:self.tableView center:center];
    self.hintView = hintView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"msgPanel_click" attributes:@{@"按钮" : @"待办事项", @"机构" : [YTUserInfoTool userInfo].organizationName}];
}


// 加载新数据
- (void)loadNewChat
{
    [self.hintView switchContentTypeWIthType:contentTypeLoading];
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    param[@"adviserId"] = [YTAccountTool account].userId;
    param[@"category"] = @1;
    param[@"pagesize"] = @10;
    self.pageNo = 1;
    param[@"pageNo"] = @(self.pageNo);
    [YTHttpTool get:YTChatContent params:param success:^(id responseObject) {
        self.messages = [YTMessageModel objectArrayWithKeyValuesArray:responseObject[@"messageList"]];
        [self.tableView.footer resetNoMoreData];
        if([self.messages count] < 10)
        {
            [self.tableView.footer noticeNoMoreData];
        }
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.hintView changeContentTypeWith:self.messages];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.hintView ContentFailure];
    }];
}


// 加载更多数据
- (void)loadMoreChat
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    param[@"adviserId"] = [YTAccountTool account].userId;
    param[@"category"] = @1;
    param[@"pagesize"] = @10;
    param[@"pageNo"] = @(++self.pageNo);
    [YTHttpTool get:YTChatContent params:param success:^(id responseObject) {
        NSArray *temp = [YTMessageModel objectArrayWithKeyValuesArray:responseObject[@"messageList"]];
        if(temp.count == 0)
        {
            [self.tableView.footer noticeNoMoreData];
            return;
        }
        [self.messages addObjectsFromArray:temp];
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
    } failure:^(NSError *error) {
        YTLog(@"%@", error);
        [self.tableView.footer endRefreshing];
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"todoCell";
    YTTodoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell =[YTTodoViewCell todoCell];
        cell.rightUtilityButtons = [self rightButtons];
        cell.layer.cornerRadius = 5;
        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor = YTColor(208, 208, 208).CGColor;
        cell.layer.masksToBounds = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.delegate = self;
    }
    cell.message = self.messages[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 99;
}

// 设置section的数目，即是你有多少个cell
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.messages.count;
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
    if (self.selectedCell.isShow) {
        [self.selectedCell hideUtilityButtonsAnimated:YES];
        self.selectedCell.isShow = NO;
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YTMessageModel *message = self.messages[indexPath.section];
    YTNormalWebController *normal = [YTNormalWebController webWithTitle:message.category2Text url:[NSString stringWithFormat:@"%@/notice%@&id=%@",YTH5Server, [NSDate stringDate], message.messageId]];
    normal.isDate = YES;
    normal.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:normal animated:YES];
    [MobClick event:@"msg_click" attributes:@{@"类型" : @"待办", @"机构" : [YTUserInfoTool userInfo].organizationName}];
    [self.tableView reloadData];
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:YTNavBackground icon:[UIImage imageNamed:@"deletetodo"] title:@"删除"];
    
    return rightUtilityButtons;
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

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    // 要删除的行
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    YTLog(@"%zd", cellIndexPath.row);
    // 获取消息id
    YTMessageModel *message =  self.messages[cellIndexPath.section];
    NSString *messageId = message.messageId;
    [_messages removeObjectAtIndex:cellIndexPath.section];
    NSIndexSet *s = [NSIndexSet indexSetWithIndex:cellIndexPath.section];
    [self.tableView deleteSections:s withRowAnimation:UITableViewRowAnimationAutomatic];
    self.selectedCell = nil;
    // 删除服务器数据
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送一个POST请求
    NSString *newUrl = [NSString stringWithFormat:@"%@%@",YTServer, YTMessageContent];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"adviserId"] = [YTAccountTool account].userId;
    param[@"messageId"] = messageId;
    [mgr DELETE:newUrl parameters:[NSDictionary httpWithDictionary:param] success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (self.messages.count < 8)
        {
            [self.tableView.footer beginRefreshing];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if(error.userInfo[@"NSLocalizedDescription"] != nil)
        {
            [SVProgressHUD showInfoWithStatus:@"网络链接失败\n请稍候再试"];
        }
    }];
    // 修改todo数量
    YTMessageNum *messageNum = [YTMessageNumTool messageNum];
    messageNum.unreadTodoNum -= 1;
    [YTMessageNumTool save:messageNum];
}




- (void)dealloc
{
    [YTCenter removeObserver:self];
}

#pragma mark - lazy
- (NSMutableArray *)messages
{
    if (!_messages) {
        _messages = [[NSMutableArray alloc] init];
    }
    return _messages;
}

@end
