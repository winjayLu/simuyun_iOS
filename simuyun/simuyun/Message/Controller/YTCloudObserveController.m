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
#import <RongIMKit/RongIMKit.h>


@interface YTCloudObserveController ()<RCIMUserInfoDataSource>


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
    
    
    
#warning test RongCloud
    [[RCIM sharedRCIM] initWithAppKey:@"tdrvipksrbgn5"];
    
    [[RCIM sharedRCIM] connectWithToken:@"UO+YUszUvQiMmL1gfgTNR2iFZ82izPgGx/14T5ZrkrWPLqd87z1pDlKO9bw7WSlwR2P6hz6vxWe0H/UuHBgqOR0r57XbNOLOuDswa5xDazQZD5pfNhAW5Aj5ZYrWYvDs93zvldjQG7g=" success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%zd", status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];
    
    
}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{
    if ([userId isEqualToString:@"c9a7b3925b2f43fe8b818b76af3b489a"]) {
        RCUserInfo *userInfo = [[RCUserInfo alloc] init];
        userInfo.userId = userId;
        userInfo.name = @"winjay";
        userInfo.portraitUri = @"http://www.simuyun.com/peyunupload//userHeadImage/c9a7b3925b2f43fe8b818b76af3b489a_1458700733228.jpg";
        return completion(userInfo);
    } else if([userId isEqualToString:@"f787e670f5ef4d24943242fa03420be1"])
    {
        RCUserInfo *userInfo = [[RCUserInfo alloc] init];
        userInfo.userId = userId;
        userInfo.name = @"亚洲";
        userInfo.portraitUri = @"http://www.simuyun.com/peyunupload//userHeadImage/f787e670f5ef4d24943242fa03420be1_1458279332430.png";
        return completion(userInfo);
    }
    return completion(nil);
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
//    // 消息数字
//    self.superVc.tabBarItem.badgeValue = nil;
//
//    YTNormalWebController *normal = [YTNormalWebController webWithTitle:@"平台客服" url:[NSString stringWithFormat:@"%@/livehelp%@",YTH5Server, [NSDate stringDate]]];
//    normal.isProgress = YES;
//    normal.isDate = YES;
//    normal.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:normal animated:YES];
//    
//    
//    YTMessageNum *num = [YTMessageNumTool messageNum];
//    num.unreadTalkNum = 0;
//    [YTMessageNumTool save:num];
//    [self.tableView reloadData];
    
    //新建一个聊天会话View Controller对象
    RCConversationViewController *chat = [[RCConversationViewController alloc]init];
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chat.conversationType = ConversationType_PRIVATE;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chat.targetId = @"c9a7b3925b2f43fe8b818b76af3b489a";
    //设置聊天会话界面要显示的标题
    chat.title = @"winjay";
    // 显示发送方的名字
    chat.displayUserNameInCell = NO;
    // 头像大小
    [chat setMessagePortraitSize:CGSizeMake(35, 35)];
    // 头像形状
    [chat setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    // 隐藏tabBar
    chat.hidesBottomBarWhenPushed = YES;
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
    
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
