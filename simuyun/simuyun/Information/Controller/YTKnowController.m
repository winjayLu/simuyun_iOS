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
#import "YTUserInfoTool.h"
#import "YTDataHintView.h"

@interface YTKnowController ()
/**
 *  咨询列表
 */
@property (nonatomic, strong) NSMutableArray *informations;

/**
 *  数据状态提示
 */
@property (nonatomic, weak) YTDataHintView *hintView;
@end

@implementation YTKnowController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = YTGrayBackground;
    self.tableView.contentInset = UIEdgeInsetsMake(-32, 0, 35, 0);
    // 去掉下划线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadInformations)];
    [self.tableView.header beginRefreshing];
    
    self.tableView.footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreInformations)];
    // 初始化提醒视图
    [self setupHintView];
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
    
    [MobClick event:@"artPanel_click" attributes:@{@"按钮" : @"早知道", @"机构" : [YTUserInfoTool userInfo].organizationName}];
}


/**
 *  加载最新的资讯数据
 */
- (void)loadInformations
{
    [self.hintView switchContentTypeWIthType:contentTypeLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"category"] = @"4";
    params[@"offset"] = @"0";
    params[@"limit"] = @"8";
    
    [YTHttpTool get:YTInformations params:params success:^(id responseObject) {
        self.informations = [YTInformation objectArrayWithKeyValuesArray:responseObject];
        [self.tableView.footer resetNoMoreData];
        if([self.informations count] < 8)
        {
            [self.tableView.footer noticeNoMoreData];
        }
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.hintView changeContentTypeWith:self.informations];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.hintView ContentFailure];
    }];
}

- (void)loadMoreInformations
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"category"] = @"4";
    params[@"offset"] = @(self.informations.count);
    params[@"limit"] = @"8";
    
    [YTHttpTool get:YTInformations params:params success:^(id responseObject) {
        NSArray *temp = [YTInformation objectArrayWithKeyValuesArray:responseObject];
        if(temp.count == 0)
        {
            [self.tableView.footer noticeNoMoreData];
            return;
        }
        [self.informations addObjectsFromArray: temp];
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
        cell.layer.cornerRadius = 5;
        cell.layer.masksToBounds = YES;
        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor = YTColor(208, 208, 208).CGColor;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.isShowLine = YES;
    }
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YTInformation *iformation = self.informations[indexPath.section];
    YTInformationWebViewController *normal = [YTInformationWebViewController webWithTitle:@"早知道" url:[NSString stringWithFormat:@"%@/information%@&id=%@",YTH5Server, [NSDate stringDate], iformation.infoId]];
    normal.isDate = YES;
    normal.information = self.informations[indexPath.section];
    [self.navigationController pushViewController:normal animated:YES];
    [MobClick event:@"msg_click" attributes:@{@"类型" : @"早知道", @"机构" : [YTUserInfoTool userInfo].organizationName}];
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
