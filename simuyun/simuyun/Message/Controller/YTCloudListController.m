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
#import "YTConversationController.h"
#import "YTAccountTool.h"
#import "SVProgressHUD.h"
#import "CoreArchive.h"
#import "YTUserInfoTool.h"


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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 更新未读消息数量
    [YTCenter postNotificationName:YTUpdateUnreadCount object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.todos.count == 0) {
        [self refreshConversationTableViewIfNeeded];
    }
}

//- (void)updateList
//{
//    [self refreshConversationTableViewIfNeeded];
////    [self.conversationListTableView reloadData];
//}

- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource
{
    // 去除全部会话对象
    [self.todos removeAllObjects];
    
    // 机构经理id
    NSString *managerUid = [CoreArchive strForKey:@"managerUid"];
    
    // 平台客服id
    NSString *customerId = nil;
    
    // 临时数组
    NSMutableArray *temps = [[NSMutableArray alloc] init];
    for (RCConversationModel *model in dataSource) {
        if ([model.targetId isEqualToString:CustomerService]) {
            [temps insertObject:model atIndex:0];
            customerId = model.targetId;
        } else if([model.targetId isEqualToString:managerUid]){
            [temps addObject:model];
        } else {
            [self.todos addObject:model];
        }
    }
    
    // 组合数据列表
    NSRange range = NSMakeRange(0, [temps count]);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.todos insertObjects:temps atIndexes:indexSet];
    
    // 判断是否有平台客服
    if (customerId == nil) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"uid"] = [YTAccountTool account].userId;
        [YTHttpTool get:YTGreetingmessage params:param success:^(id responseObject) {
        } failure:^(NSError *error) {
        }];
    }
    
    // 判断是否有机构经理
    if (managerUid == nil && [YTUserInfoTool userInfo].adviserStatus == 0) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"uid"] = [YTAccountTool account].userId;
        [YTHttpTool get:YTRcManagerInfo params:param success:^(id responseObject) {
            // 机构经理id
            NSString *managerUid = responseObject[@"managerUid"];
            if (managerUid.length > 0) {
                [CoreArchive setStr:responseObject[@"managerUid"] key:@"managerUid"];
            }
            // 机构经理phone
            NSString *managerMobile = responseObject[@"managerMobile"];
            if (managerMobile.length > 0) {
                [CoreArchive setStr:responseObject[@"managerMobile"] key:@"managerMobile"];
            }
        } failure:^(NSError *error) {
        }];
    }
    
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
    
    RCMessage *message = notification.object;
    for (RCConversationModel *model in self.todos) {
        if ([message.targetId isEqualToString:model.targetId]) {
            [self refreshConversationTableViewIfNeeded];
            [self notifyUpdateUnreadMessageCount];
            return;
        }
    }
    [self updateTableCellWithReceivedMessage:message];
}


- (void)updateTableCellWithReceivedMessage:(RCMessage *)receivedMessage {
    
    RCConversationModel *newReceivedConversationModel_ = nil;
    //获取接受到会话
    RCConversation *receivedConversation_ =
    [[RCIMClient sharedRCIMClient] getConversation:receivedMessage.conversationType targetId:receivedMessage.targetId];
    
    if (!receivedConversation_) {
        return;
    }
    RCConversationModelType modelType = RC_CONVERSATION_MODEL_TYPE_NORMAL;
    if (receivedConversation_.conversationType == ConversationType_APPSERVICE ||
        receivedConversation_.conversationType == ConversationType_PUBLICSERVICE) {
        modelType = RC_CONVERSATION_MODEL_TYPE_PUBLIC_SERVICE;
        RCPublicServiceProfile *serviceProfile = [[RCIMClient sharedRCIMClient] getPublicServiceProfile:(RCPublicServiceType)receivedMessage.conversationType publicServiceId:receivedMessage.targetId];
        if ([serviceProfile.publicServiceId isEqualToString:@""] && serviceProfile.publicServiceType == 0) {
            return;
        }
    }
    
    //转换新会话为新会话模型
    newReceivedConversationModel_ =
    [[RCConversationModel alloc] init:modelType conversation:receivedConversation_ extend:nil];
    [self.todos insertObject:newReceivedConversationModel_ atIndex:0];
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.conversationListTableView reloadData];
    });
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
    YTConversationController *chat = [[YTConversationController alloc]init];
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chat.conversationType = ConversationType_PRIVATE;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chat.targetId = model.targetId;
//    chat.targetId = @"e3ffcc0a37c0463e9636bf997e606a70";
    //设置聊天会话界面要显示的标题
    chat.title = model.conversationTitle;
    // 显示发送方的名字
    chat.displayUserNameInCell = NO;
    // 头像形状
    [chat setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    [chat setMessagePortraitSize:CGSizeMake(37, 37)];
    // 隐藏tabBar
    chat.hidesBottomBarWhenPushed = YES;
    chat.userId = [YTAccountTool account].userId;
    
    if ([model.targetId isEqualToString:CustomerService] || [model.targetId isEqualToString:[CoreArchive strForKey:@"managerUid"]]) {
        chat.isMobile = YES;
    }
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除会话
    RCConversationModel *model = self.todos[indexPath.section];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
    if ([model.conversationTitle hasPrefix:@"平台客服"] || [model.conversationTitle hasPrefix:@"机构经理"]) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@\n不可以删除", model.conversationTitle]];
        [self.conversationListTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    
    RCIMClient *client = [RCIMClient sharedRCIMClient];
    [client removeConversation:ConversationType_PRIVATE targetId:model.targetId];
    [client clearMessages:ConversationType_PRIVATE targetId:model.targetId];
    [self.todos removeObjectAtIndex:indexPath.section];
    
    [self.conversationListTableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [YTCenter postNotificationName:YTUpdateUnreadCount object:nil];

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
