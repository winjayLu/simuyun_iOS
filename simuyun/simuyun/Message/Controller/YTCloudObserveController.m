//
//  YTCloudObserveController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/19.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// 客服消息

#import "YTCloudObserveController.h"
#import "YTCustomerServiceCell.h"
#import "YTAccountTool.h"
#import "YTServiceModel.h"
#import "YTMessageNumTool.h"
#import "YTNormalWebController.h"
#import "NSDate+Extension.h"
#import "CoreArchive.h"
#import "YTUserInfoTool.h"
#import "YTDataHintView.h"
#import "MJRefresh.h"
#import "NSString+JsonCategory.h"
#import "NSObject+JsonCategory.h"


@interface YTCloudObserveController ()


// 客服消息
@property (nonatomic, strong) NSMutableArray *services;

/**
 *  数据状态提示
 */
@property (nonatomic, weak) YTDataHintView *hintView;
@end

@implementation YTCloudObserveController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = YTGrayBackground;
    self.tableView.contentInset = UIEdgeInsetsMake(-34, 0, 91, 0);
    
    // 去掉下划线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 禁用tableView滚动
    self.tableView.scrollEnabled =NO;
    
    // 刷新表格
    [self.tableView reloadData];
    
    [self loadNewChat];
    
    // 监听客服消息数字变化
    [YTCenter addObserver:self selector:@selector(loadNewChat) name:YTUpdateChatContent object:nil];

    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewChat)];
    
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


// 加载新数据
- (void)loadNewChat
{
    [self.hintView switchContentTypeWIthType:contentTypeLoading];
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    param[@"adviserId"] = [YTAccountTool account].userId;
    param[@"category"] = @0;

    [YTHttpTool get:YTChatContent params:param success:^(id responseObject) {
        YTServiceModel * service =[YTServiceModel objectWithKeyValues:responseObject];
        [self.services removeAllObjects];
        [self.services addObject:service];
        // 存储获取到的数据
        NSString *oldServices = [responseObject JsonToString];
        [CoreArchive setStr:oldServices key:@"oldServices"];
        // 存储时间
        [CoreArchive setStr:responseObject[@"lastTimestamp"] key:@"timestampCategory0"];
        [self.tableView reloadData];
        [self.hintView changeContentTypeWith:self.services];
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
        [self.hintView ContentFailure];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [MobClick event:@"msgPanel_click" attributes:@{@"按钮" : @"消息", @"机构" : [YTUserInfoTool userInfo].organizationName}];
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
        cell.layer.cornerRadius = 5;
        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor = YTColor(208, 208, 208).CGColor;
        cell.layer.masksToBounds = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 消息数字
    self.superVc.tabBarItem.badgeValue = nil;

    YTNormalWebController *normal = [YTNormalWebController webWithTitle:@"平台客服" url:[NSString stringWithFormat:@"%@/livehelp%@",YTH5Server, [NSDate stringDate]]];
    normal.isProgress = YES;
    normal.isDate = YES;
    normal.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:normal animated:YES];
    
    
    YTMessageNum *num = [YTMessageNumTool messageNum];
    num.CHAT_CONTENT = 0;
    [self.tableView reloadData];
    
}


- (void)dealloc
{
    [YTCenter removeObserver:self];
}


#pragma mark - lazy

- (NSMutableArray *)services
{
    if (!_services) {
        // 获取历史数据
        NSString *oldServices = [CoreArchive strForKey:@"oldServices"];
        if (oldServices != nil) {
            _services = [[NSMutableArray alloc] init];
            [_services addObject:[YTServiceModel objectWithKeyValues:[oldServices JsonToValue]]];
        } else {
            _services = [[NSMutableArray alloc] init];
            // 初始化提醒视图
            [self setupHintView];
        }
    }
    return _services;
}


@end
