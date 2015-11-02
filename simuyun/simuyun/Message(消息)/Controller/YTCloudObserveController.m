//
//  YTCloudObserveController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/19.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// 消息

#import "YTCloudObserveController.h"
#import "YTCustomerServiceCell.h"
#import "MJRefresh.h"
#import "YTAccountTool.h"
#import "YTServiceModel.h"


@interface YTCloudObserveController ()


// 客服消息
@property (nonatomic, strong) NSMutableArray *services;


@end

@implementation YTCloudObserveController

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
    
}
// 加载新数据
- (void)loadNewChat
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
//    param[@"adviserId"] = [YTAccountTool account].userId;
    param[@"adviserId"] = @"001e4ef1d3344057a995376d2ee623d4";
    param[@"category"] = @0;
    [YTHttpTool get:YTCustomerService params:param success:^(id responseObject) {
        self.services = [YTServiceModel objectArrayWithKeyValuesArray:responseObject[@"chatContentList"]];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        YTLog(@"%@", error);
        [self.tableView.header endRefreshing];
    }];
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"ServiceCell";
    YTCustomerServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell =[YTCustomerServiceCell CustomerServiceCell];
    }
    cell.layer.cornerRadius = 5;
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = YTColor(208, 208, 208).CGColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.service = self.services[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

// 设置section的数目，即是你有多少个cell
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.services.count;
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
    self.tabBarItem.badgeValue = nil;
}



#pragma mark - lazy

- (NSMutableArray *)services
{
    if (!_services) {
        _services = [[NSMutableArray alloc] init];
    }
    return _services;
}

@end
