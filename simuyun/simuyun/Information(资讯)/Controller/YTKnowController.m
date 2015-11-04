//
//  YTKnowController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/26.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// 早知道

#import "YTKnowController.h"
#import "YTInformationTableViewCell.h"
#import "MJRefresh.h"
#import "YTInformation.h"
#import "YTInformationWebViewController.h"
#import "NSDate+Extension.h"



@interface YTKnowController ()
/**
 *  咨询列表
 */
@property (nonatomic, strong) NSMutableArray *informations;
@end

@implementation YTKnowController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = YTGrayBackground;
    self.tableView.contentInset = UIEdgeInsetsMake(-32, 0, 0, 0);
    // 去掉下划线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadInformations)];
    [self.tableView.header beginRefreshing];
    
    self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreInformations)];
}


/**
 *  加载最新的资讯数据
 */
- (void)loadInformations
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"category"] = @"4";
    params[@"offset"] = @"0";
    params[@"limit"] = @"20";
    
    [YTHttpTool get:YTInformations params:params success:^(id responseObject) {
        self.informations = [YTInformation objectArrayWithKeyValuesArray:responseObject];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}

- (void)loadMoreInformations
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"category"] = @"4";
    params[@"offset"] = @(self.informations.count);
    params[@"limit"] = @"20";
    
    [YTHttpTool get:YTInformations params:params success:^(id responseObject) {
        [self.informations addObjectsFromArray: [YTInformation objectArrayWithKeyValuesArray:responseObject]];
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.footer endRefreshing];
    }];
}




#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Information";
    YTInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YTInformationTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.information = self.informations[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 93;
}

// 设置section的数目，即是你有多少个cell
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.informations.count;
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
    YTInformation *iformation = self.informations[indexPath.section];
    YTInformationWebViewController *normal = [YTInformationWebViewController webWithTitle:@"资讯详情" url:[NSString stringWithFormat:@"%@/information%@&id=%@",YTH5Server, [NSDate stringDate], iformation.infoId]];
    normal.isDate = YES;
    normal.information = self.informations[indexPath.section];
    [self.navigationController pushViewController:normal animated:YES];
}


#pragma mark - lazy
- (NSMutableArray *)informations
{
    if (!_informations) {
        _informations = [[NSMutableArray alloc] init];
    }
    return _informations;
}

@end
