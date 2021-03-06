//
//  YTContentView.m
//  simuyun
//
//  Created by Luwinjay on 15/10/10.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// Profile中间的待办事项

#import "YTContentView.h"
#import "YTGroupCell.h"
#import "YTContentCell.h"
#import "YTMessageModel.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "YTAccountTool.h"
#import "YTMessageNumTool.h"


@interface YTContentView() <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>

// 待办事项数量
@property (nonatomic, weak) UIButton *todoNumBtn;

/**
 *  待办事项标题
 */
@property (nonatomic, weak) YTGroupCell *groupCell;


/**
 *  保存上次侧滑的Cell
 */
@property (nonatomic, weak) SWTableViewCell *selectedCell;

@end

@implementation YTContentView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.showsVerticalScrollIndicator = NO;
        // 去掉下划线
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 禁用tableView滚动
        self.scrollEnabled =NO;
    }
    return self;
}

- (void)setTodos:(NSMutableArray *)todos
{
    _todos = todos;
    [self reloadData];
    // 设置消息数量
    [self setTodoNum];
}


// 设置消息数量
- (void)setTodoNum{
    // 消息数量
    YTMessageNum *messageNum = [YTMessageNumTool messageNum];
    int todoNum = messageNum.unreadTodoNum;
    if (todoNum > 0) {
        self.todoNumBtn.hidden = NO;
        if (todoNum > 99) {
            [self.todoNumBtn setTitle:@"99+" forState:UIControlStateNormal];
        } else {
            [self.todoNumBtn setTitle:[NSString stringWithFormat:@"%d",todoNum] forState:UIControlStateNormal];
        }
    } else {
        self.todoNumBtn.hidden = YES;
    }
}




#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.todos.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"contentCell";
    YTContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    YTMessageModel *message =  self.todos[indexPath.row];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YTContentCell" owner:nil options:nil] lastObject];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    if (message.messageId.length >0) {
        cell.rightUtilityButtons = [self rightButtons];
    } else {
        cell.rightUtilityButtons = nil;
    }
    
    cell.summary = message.summary;
    
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:YTNavBackground icon:[UIImage imageNamed:@"deletetodo"] title:@"删除"];
    
    return rightUtilityButtons;
}


// 设置cell之间headerview的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 42;
}
// 设置headerview的颜色
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    YTGroupCell *groupCell = [[[NSBundle mainBundle] loadNibNamed:@"YTGroupCell" owner:nil options:nil] lastObject];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(todoTitleClick)];
    [groupCell addGestureRecognizer:tap];
    self.groupCell = groupCell;
    // 待办事项数量
    UIButton *todoNum = [[UIButton alloc] init];
    todoNum.center = groupCell.center;
    todoNum.x = 100;
    todoNum.size = CGSizeMake(25, 13);
    todoNum.y -= 13 * 0.5 - 1;
    [todoNum setBackgroundImage:[UIImage imageNamed:@"shuziditu"] forState:UIControlStateNormal];
    todoNum.hidden = YES;
    todoNum.titleLabel.font = [UIFont systemFontOfSize:10];
    todoNum.enabled = NO;
    [groupCell addSubview:todoNum];
    self.todoNumBtn = todoNum;
    todoNum.adjustsImageWhenDisabled = NO;
    [self setTodoNum];
    return groupCell;
}

- (void)todoTitleClick
{
    if ([self.daili respondsToSelector:@selector(selectedTodo:)]) {
        [self.daili selectedTodo:-1];
    }
}


#pragma mark - tableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#warning 测试待办事项侧滑删除
    if (self.selectedCell.isShow) {
        [self.selectedCell hideUtilityButtonsAnimated:YES];
        self.selectedCell.isShow = NO;
        return;
    }
    self.selectedCell = nil;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.daili respondsToSelector:@selector(selectedTodo:)]) {
        [self.daili selectedTodo:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 52;
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    if (!self.selectedCell.isShow && self.selectedCell != cell) {
        self.selectedCell = cell;
        self.selectedCell.isShow = YES;
    }
    return YES;
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    // 要删除的行
    NSIndexPath *cellIndexPath = [self indexPathForCell:cell];
    YTLog(@"%zd", cellIndexPath.row);
    // 获取消息id
    YTMessageModel *message =  self.todos[cellIndexPath.row];
    NSString *messageId = message.messageId;
    [_todos removeObjectAtIndex:cellIndexPath.row];
    [self deleteRowsAtIndexPaths:@[cellIndexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // 删除服务器数据
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送一个POST请求
    NSString *newUrl = [NSString stringWithFormat:@"%@%@",YTServer, YTMessageContent];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"adviserId"] = [YTAccountTool account].userId;
    param[@"messageId"] = messageId;
    [mgr DELETE:newUrl parameters:[NSDictionary httpWithDictionary:param] success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        // 剩余数量小于4，获取新数据
        if (_todos.count < 4)
        {
            [YTCenter postNotificationName:YTUpdateTodoData object:nil];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if(error.userInfo[@"NSLocalizedDescription"] != nil)
        {
            [SVProgressHUD showInfoWithStatus:@"网络链接失败\n请稍候再试"];
        }
    }];
    // 剩余数量小于4，调整界面
    if (_todos.count < 4)
    {
        [YTCenter postNotificationName:YTUpdateTodoFrame object:nil];
    }
    
    // 修改todo数量
    YTMessageNum *messageNum = [YTMessageNumTool messageNum];
    messageNum.unreadTodoNum -= 1;
    [YTMessageNumTool save:messageNum];
    [self setTodoNum];
}


@end
