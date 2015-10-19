//
//  YTCloudObserveController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/19.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// 云观察

#import "YTCloudObserveController.h"
#import "YTGroupCell.h"

#import "MJRefresh.h"


@interface YTCloudObserveController ()

@property (nonatomic, strong) NSArray *titles;


@end

@implementation YTCloudObserveController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = YTColor(246, 246, 246);
    self.tableView.contentInset = UIEdgeInsetsMake(-34, 0, 0, 0);
    
//    self.showsVerticalScrollIndicator = NO;
//    // 去掉下划线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    // 禁用tableView滚动
//    self.scrollEnabled =NO;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    
    [self.tableView.header beginRefreshing];
}

- (void)refresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.header endRefreshing];
    });
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"groupCell";
    YTGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YTGroupCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title = self.titles[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 42;
}

- (NSArray *)titles
{
    if (!_titles) {
        _titles = @[@"全部订单", @"我的奖品", @"云豆银行"];
    }
    return _titles;
}

@end
