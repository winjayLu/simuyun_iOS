//
//  YTOperationCenterController.m
//  simuyun
//
//  Created by Luwinjay on 15/11/30.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTOperationCenterController.h"
#import "MJRefresh.h"
#import "YTTodoViewCell.h"
#import "YTAccountTool.h"
#import "YTMessageModel.h"
#import "CoreArchive.h"
#import "YTMessageDetailController.h"
#import "NSDate+Extension.h"
#import "YTUserInfoTool.h"
#import "NSString+Extend.h"
#import "YTDataHintView.h"
#import "NSString+JsonCategory.h"
#import "NSObject+JsonCategory.h"



// 运营公告

@interface YTOperationCenterController ()

// 起始页
@property (nonatomic, assign) int pageNo;

@property (nonatomic, strong) NSMutableArray *messages;

/**
 *  数据状态提示
 */
@property (nonatomic, weak) YTDataHintView *hintView;


@end

@implementation YTOperationCenterController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = YTGrayBackground;
    self.tableView.contentInset = UIEdgeInsetsMake(-34, 0, 55, 0);
    
    // 去掉下划线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewChat)];
    
    // 刷新表格
    [self.tableView reloadData];
    
    
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
    
    // 下拉刷新
    self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreChat)];
    
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
    
    [MobClick event:@"msgPanel_click" attributes:@{@"按钮" : @"运营公告", @"机构" : [YTUserInfoTool userInfo].organizationName}];
}

// 加载新数据
- (void)loadNewChat
{
    [self.hintView switchContentTypeWIthType:contentTypeLoading];
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    param[@"adviserId"] = [YTAccountTool account].userId;
    param[@"category"] = @4;
    param[@"pagesize"] = @8;
    self.pageNo = 1;
    param[@"pageNo"] = @(self.pageNo);
    [YTHttpTool get:YTChatContent params:param success:^(id responseObject) {
        self.messages = [YTMessageModel objectArrayWithKeyValuesArray:responseObject[@"messageList"]];
        // 存储时间
        [CoreArchive setStr:responseObject[@"lastTimestamp"] key:@"timestampCategory4"];
        // 存储获取到的数据
        if (self.messages.count >0) {
            NSString *oldOperation = [responseObject JsonToString];
            [CoreArchive setStr:oldOperation key:@"oldOperation"];
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
    param[@"category"] = @4;
    param[@"pagesize"] = @8;
    param[@"pageNo"] = @(++self.pageNo);
    [YTHttpTool get:YTChatContent params:param success:^(id responseObject) {
        [self.messages addObjectsFromArray:[YTMessageModel objectArrayWithKeyValuesArray:responseObject[@"messageList"]]];
        [CoreArchive setStr:responseObject[@"lastTimestamp"] key:@"lastTimestamp"];
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
    
    static NSString *identifier = @"todoCell";
    YTTodoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell =[YTTodoViewCell todoCell];
        cell.layer.cornerRadius = 5;
        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor = YTColor(208, 208, 208).CGColor;
        cell.layer.masksToBounds = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YTMessageModel *message = self.messages[indexPath.section];
    YTMessageDetailController *detail = [YTMessageDetailController webWithTitle:[NSString titleWithCategoryCode:message.category2Code] url:[NSString stringWithFormat:@"%@/notice%@&id=%@",YTH5Server, [NSDate stringDate], message.messageId]];
    detail.isDate = YES;
    detail.shareImageName = @"shareYunyinGonggao";
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    [MobClick event:@"msg_click" attributes:@{@"类型" : @"运营公告详情", @"机构" : [YTUserInfoTool userInfo].organizationName}];
}


#pragma mark - lazy
- (NSMutableArray *)messages
{
    if (!_messages) {
        // 获取历史数据
        NSString *oldOperation = [CoreArchive strForKey:@"oldOperation"];
        if (oldOperation != nil) {
            ;
            _messages = [YTMessageModel objectArrayWithKeyValuesArray:[oldOperation JsonToValue][@"messageList"]];
        } else {
            _messages = [[NSMutableArray alloc] init];
            // 初始化提醒视图
            [self setupHintView];
        }
    }
    return _messages;
}

@end
