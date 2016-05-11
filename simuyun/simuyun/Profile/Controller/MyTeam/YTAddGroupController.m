//
//  YTAddGroupController.m
//  simuyun
//
//  Created by Luwinjay on 16/5/9.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTAddGroupController.h"
#import "YTAddMemberController.h"
#import "YTNomalMemberCell.h"
#import "YTMemberModel.h"
#import "UIImage+Extend.h"
#import "YTGroupModel.h"
#import "YTTeamListController.h"


@interface YTAddGroupController ()<UITableViewDelegate, UITableViewDataSource, addMemberDelegate>

// 组名
@property (weak, nonatomic) IBOutlet UITextField *groupName;

// 添加组员视图
@property (weak, nonatomic) IBOutlet UIView *addView;

// 组员数量Lable
@property (weak, nonatomic) IBOutlet UILabel *teamNumLable;

// 选中的成员列表
@property (nonatomic, weak) UITableView *tableView;


// 团队数量Lable
@property (weak, nonatomic) IBOutlet UILabel *teamCountLable;

- (IBAction)addMemberClick:(UIButton *)sender;

// 新增的成员
@property (nonatomic, strong) NSMutableArray *addMembers;

// 删除的成员
@property (nonatomic, strong) NSMutableArray *deleteMembers;

@end

@implementation YTAddGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置标题
    if (self.isEdit) {
        self.title = @"编辑分组";
        self.teamNumLable.text = [NSString stringWithFormat:@"小组成员(%zd)", self.groupModel.members.count];
    } else {
        self.title = @"新建分组";
    }
    
    // 初始化右侧按钮
    [self setupRightItem];
    
    // 初始化成员列表
    [self setupTableView];

}


/**
 *  保存分组信息
 */
- (void)save
{
    
}

/**
 *  删除分组
 */
- (void)deleteGroup
{
#warning 发送请求
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[YTTeamListController class]]) {
            // 发送通知刷新列表
            [YTCenter postNotificationName:YTUpdateTeamList object:nil];
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}


/**
 *  添加成员点击事件
 *
 */
- (IBAction)addMemberClick:(UIButton *)sender {
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",self.selectedMembers];
    NSArray * filter = [self.members filteredArrayUsingPredicate:filterPredicate];

    [self.groupName endEditing:YES];
    YTAddMemberController *add = [[YTAddMemberController alloc] init];
    add.addDelegate = self;
    add.members = [NSMutableArray arrayWithArray:filter];
    [self.navigationController pushViewController:add animated:YES];
}

- (void)didSelectedMembers:(NSArray *)members
{
    // 添加到增量数组
    [self.addMembers addObjectsFromArray:members];
    
#pragma mark - 添加到最前面
    // 添加到已选中数组
    NSRange range = NSMakeRange(0, members.count);
    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.selectedMembers insertObjects:members atIndexes:set];
    self.teamNumLable.text = [NSString stringWithFormat:@"小组成员(%zd)", self.groupModel.members.count];
    [self.tableView reloadData];
}


/**
 *  初始化右侧按钮
 */
- (void)setupRightItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
}

/**
 *  初始化成员列表
 */
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    CGFloat addViewMaxY = CGRectGetMaxY(self.addView.frame);
    // 设置frame
    tableView.frame = CGRectMake(0, addViewMaxY, self.view.width, self.view.height - addViewMaxY - 64);
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    tableView.dataSource = self;
    tableView.delegate = self;
    // 设置颜色
    tableView.backgroundColor = YTGrayBackground;
    // 去掉下划线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    // 去除弹簧效果
    tableView.bounces = NO;
    
    // 删除该组 Footer
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    view.frame = CGRectMake(0, 0, self.view.width, 100);
    
    UIButton *redeemBtn = [[UIButton alloc] init];
    [redeemBtn setBackgroundImage:[UIImage imageWithColor:YTNavBackground] forState:UIControlStateNormal];
    [redeemBtn setBackgroundImage:[UIImage imageWithColor:YTColor(210, 36, 20)] forState:UIControlStateHighlighted];
    [redeemBtn setBackgroundImage:[UIImage imageWithColor:YTColor(208, 208, 208)] forState:UIControlStateDisabled];
    [redeemBtn setTitle:@"删除该组" forState:UIControlStateNormal];
    [redeemBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [redeemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    redeemBtn.layer.cornerRadius = 5;
    redeemBtn.layer.masksToBounds = YES;
    redeemBtn.frame = CGRectMake(10, 56, view.width - 20, 44);
    [redeemBtn addTarget:self action:@selector(deleteGroup) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:redeemBtn];
    tableView.tableFooterView = view;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.groupName endEditing:YES];
}


#pragma mark - TableVIewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectedMembers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTNomalMemberCell *cell = nil;
    static NSString *memberCell = @"NomalMember";
    cell = [tableView dequeueReusableCellWithIdentifier:memberCell];
    YTMemberModel *member = self.selectedMembers[indexPath.row];
    if (cell==nil) {
        cell = [YTNomalMemberCell nomalMemberCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.member = member;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YTMemberModel *member = self.selectedMembers[indexPath.row];
    // 判断是否在增量数据中
    BOOL isAdd = NO;
    for (YTMemberModel *addMember in self.addMembers) {
        if ([member isEqual:addMember]) {
            isAdd = YES;
            break;
        }
    }
    // 在增量中
    if (isAdd == YES) {
        [self.addMembers removeObject:member];
    } else {  // 服务端已存在，保存后发请求删除
        [self.deleteMembers addObject:member];
    }
    
    member.isSelected = NO;
    [self.selectedMembers removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    self.teamNumLable.text = [NSString stringWithFormat:@"小组成员(%zd)", self.groupModel.members.count];
}

#pragma mark - lazy

- (NSMutableArray *)selectedMembers
{
    if (!_selectedMembers) {
        _selectedMembers = [[NSMutableArray alloc] init];
    }
    return _selectedMembers;
}

- (NSMutableArray *)deleteMembers
{
    if (!_deleteMembers) {
        _deleteMembers = [[NSMutableArray alloc] init];
    }
    return _deleteMembers;
}

- (NSMutableArray *)addMembers
{
    if (!_addMembers) {
        _addMembers = [[NSMutableArray alloc] init];
    }
    return _addMembers;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
