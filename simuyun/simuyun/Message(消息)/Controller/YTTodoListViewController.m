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


@interface YTTodoListViewController ()
// 起始页
@property (nonatomic, assign) int pageNo;

@property (nonatomic, strong) NSMutableArray *messages;

@end

@implementation YTTodoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = YTGrayBackground;
    self.tableView.contentInset = UIEdgeInsetsMake(-34, 0, 91, 0);
    
    // 去掉下划线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewChat)];
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
    
    // 下拉刷新
    self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreChat)];
}

// 加载新数据
- (void)loadNewChat
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
//    param[@"adviserId"] = [YTAccountTool account].userId;
        param[@"adviserId"] = @"001e4ef1d3344057a995376d2ee623d4";
    param[@"category"] = @1;
    param[@"pagesize"] = @20;
    self.pageNo = 0;
    param[@"pageNo"] = @(self.pageNo);
    [YTHttpTool get:YTChatContent params:param success:^(id responseObject) {
        self.messages = [YTMessageModel objectArrayWithKeyValuesArray:responseObject[@"chatContentList"]];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}

// 加载更多数据
- (void)loadMoreChat
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
//    param[@"adviserId"] = [YTAccountTool account].userId;
        param[@"adviserId"] = @"001e4ef1d3344057a995376d2ee623d4";
    param[@"category"] = @1;
    param[@"pagesize"] = @20;
    param[@"pageNo"] = @(++self.pageNo);
    [YTHttpTool get:YTChatContent params:param success:^(id responseObject) {
        YTLog(@"%@", responseObject);
        [self.messages addObjectsFromArray:[YTMessageModel objectArrayWithKeyValuesArray:responseObject]];
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
    }
    cell.layer.cornerRadius = 5;
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = YTColor(208, 208, 208).CGColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;    
    cell.message = self.messages[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
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
#pragma mark - lazy
- (NSMutableArray *)messages
{
    if (!_messages) {
        _messages = [[NSMutableArray alloc] init];
    }
    return _messages;
}

@end
