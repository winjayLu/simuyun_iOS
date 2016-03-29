//
//  YTCloudListController.m
//  simuyun
//
//  Created by Luwinjay on 16/3/29.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

// 聊天列表界面

#import "YTCloudListController.h"
#import "YTCloudListCell.h"
#import "MJRefresh.h"
#import <RongIMLib/RongIMLib.h>

@interface YTCloudListController ()
/**
 *  待办事项数据
 */
@property (nonatomic, strong) NSMutableArray *todos;
@end

@implementation YTCloudListController


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.conversationListTableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    self.conversationListTableView.backgroundColor = YTGrayBackground;
    // 去掉下划线
    self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[RCIM sharedRCIM] setGlobalConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
}
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource
{
    self.todos = dataSource;
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.conversationListTableView reloadData];
    });
    return dataSource;
}

/*!
 在会话列表中，收到新消息的回调
 
 @param notification    收到新消息的notification
 
 @discussion SDK在此方法中有针对消息接收有默认的处理（如刷新等），如果您重写此方法，请注意调用super。
 
 notification的object为RCMessage消息对象，userInfo为NSDictionary对象，其中key值为@"left"，value为还剩余未接收的消息数的NSNumber对象。
 */
- (void)didReceiveMessageNotification:(NSNotification *)notification
{
    [self refreshConversationTableViewIfNeeded];
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"hotProductCell";
    YTCloudListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell =[[YTCloudListCell alloc] init];
        cell.layer.cornerRadius = 5;
        cell.layer.masksToBounds = YES;
        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor = YTColor(208, 208, 208).CGColor;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.isShowNotificationNumber = YES;
    [cell setDataModel:self.todos[indexPath.section]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 65;
}

// 设置section的数目，即是你有多少个cell
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.todos.count;
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
    RCConversationModel *model = self.todos[indexPath.section];
    //新建一个聊天会话View Controller对象
    RCConversationViewController *chat = [[RCConversationViewController alloc]init];
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chat.conversationType = ConversationType_PRIVATE;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chat.targetId = model.targetId;
    //设置聊天会话界面要显示的标题
    chat.title = model.conversationTitle;
    // 显示发送方的名字
    chat.displayUserNameInCell = NO;
    // 头像形状
    [chat setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    // 隐藏tabBar
    chat.hidesBottomBarWhenPushed = YES;
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (NSMutableArray *)todos
{
    if (!_todos) {
        _todos = [[NSMutableArray alloc] init];

    }
    return _todos;
}



@end
