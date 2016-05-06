//
//  YTTeamListController.m
//  simuyun
//
//  Created by Luwinjay on 16/5/5.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTTeamListController.h"
#import "DXPopover.h"
#import "YTGroupModel.h"
#import "YTMemberModel.h"
#import "CoreArchive.h"
#import "NSObject+JsonCategory.h"
#import "NSString+JsonCategory.h"
#import "MJRefresh.h"
#import "YTAccountTool.h"
#import "YTTeamMemberCell.h"
#import "YTTeamGroupCell.h"
#import "YTMemberDetailController.h"


@interface YTTeamListController ()

// 弹出菜单
@property (nonatomic, strong) DXPopover *popover;

// 菜单内容
@property (nonatomic, strong) UIView *innerView;

// 团队成员数组
@property (nonatomic, strong) NSArray *members;

// 团队组数组
@property (nonatomic, strong) NSMutableArray *groups;

// 选择控件
@property (nonatomic, weak) UISegmentedControl *segmented;

@end

@implementation YTTeamListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    // 1.初始化navgationBar
    [self setupNavgationBar];
    
    // 2.获取数据
    [self.tableView.header beginRefreshing];
}


/**
 *  初始化navgationBar
 */
- (void)setupNavgationBar
{
    // 标题切换
    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:@[@"个人", @"小组"]];
    segmented.size = CGSizeMake(140, 30);
    segmented.tintColor = [UIColor whiteColor];
    segmented.selectedSegmentIndex = 0;
    UIFont *font = [UIFont boldSystemFontOfSize:17];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [segmented setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [segmented addTarget:self.tableView.header action:@selector(beginRefreshing) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmented;
    self.segmented = segmented;

    // 右上角加号
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, 22, 22);
    [button addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
}


/**
 *  加载数据
 */
- (void)loadData
{
    if (self.segmented.selectedSegmentIndex == 0) {
        if (self.members.count > 0) {
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
        } else {
            [self loadMembers];
        }
    } else {
        if (self.groups.count > 0) {
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
        } else {
            [self loadGroups];
        }
    }
}

/**
 *  加载团队成员
 */
- (void)loadMembers
{
//    [YTHttpTool get:YTGetAllMembers params:@{@"adviserId" : [YTAccountTool account].userId} success:^(id responseObject) {
//        self.members = [YTMemberModel objectArrayWithKeyValuesArray:responseObject];
//        [self.tableView.header endRefreshing];
//        [self.tableView reloadData];
//    } failure:^(NSError *error) {
//    }];
#warning Test
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        YTMemberModel *member = [[YTMemberModel alloc] init];
        if (i == 0) {
            member.isFather = 1;
        } else {
            member.isFather = 0;
        }
        member.headImgUrl = @"http://wx.qlogo.cn/mmopen/ajNVdqHZLLDjDuGfZzBJ9ZVItVialdtwkGgZoFYicfoE3LBj54R7IkovtNagstSBmx9ZJpbzaARRQsoibwnuOMrFA/0";
        member.lastLoginTime = @"2015-01-01";
        member.phoneNum = @"13830712876";
        member.memo = @"";
        member.joinTeamTime = @"2015-01-01";
        member.nickName = [NSString stringWithFormat:@"test%d", i];
        member.adviserId = [NSString stringWithFormat:@"testUserid%d", i];
        [temp addObject:member];
    }
    self.members = [NSArray arrayWithArray:temp];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
    });
}

/**
 *  加载团队组列表
 */
- (void)loadGroups
{
//    [YTHttpTool get:YTGetAllGroups params:@{@"adviserId" : [YTAccountTool account].userId} success:^(id responseObject) {
//        self.groups = [YTGroupModel objectArrayWithKeyValuesArray:responseObject];
//        [self.tableView.header endRefreshing];
//        [self.tableView reloadData];
//    } failure:^(NSError *error) {
//    }];
#warning Test
    for (int i = 0; i < 5; i++) {
        YTGroupModel *group = [[YTGroupModel alloc] init];
        group.groupId = [NSString stringWithFormat:@"000%d", i];
        group.groupName = [NSString stringWithFormat:@"test%d", i];
        NSMutableArray *temp = [NSMutableArray array];
        for (int i = 0; i < 5; i++) {
            YTMemberModel *member = [[YTMemberModel alloc] init];
            if (i == 0) {
                member.isFather = 1;
            } else {
                member.isFather = 0;
            }
            member.headImgUrl = @"http://wx.qlogo.cn/mmopen/ajNVdqHZLLDjDuGfZzBJ9ZVItVialdtwkGgZoFYicfoE3LBj54R7IkovtNagstSBmx9ZJpbzaARRQsoibwnuOMrFA/0";
            member.lastLoginTime = @"2015-01-01";
            member.phoneNum = @"13830712876";
            member.memo = @"";
            member.joinTeamTime = @"2015-01-01";
            member.nickName = [NSString stringWithFormat:@"test%d", i];
            member.adviserId = [NSString stringWithFormat:@"testUserid%d", i];
            [temp addObject:member];
        }
        group.members = [NSArray arrayWithArray:temp];
        [self.groups addObject:group];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
    });
    
}

/**
 *  创建分组
 */
- (void)creatGroup
{
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segmented.selectedSegmentIndex == 0) {
        return self.members.count;
    } else {
        return self.groups.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (self.segmented.selectedSegmentIndex == 0) {
        static NSString *memberCell = @"teamMember";
        cell = [tableView dequeueReusableCellWithIdentifier:memberCell];
        YTMemberModel *member = self.members[indexPath.row];
        if (cell==nil) {
            cell = [YTTeamMemberCell memberCell];
            ((YTTeamMemberCell *)cell).member = member;
        }
    } else {
        static NSString *groupCell = @"teamGroup";
        cell = [tableView dequeueReusableCellWithIdentifier:groupCell];
        YTGroupModel *group = self.groups[indexPath.row];
        if (cell==nil) {
            cell =[YTTeamGroupCell groupCell];
            ((YTTeamGroupCell *)cell).group = group;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmented.selectedSegmentIndex == 0) { // 成员点击
        YTMemberDetailController *detail = [[YTMemberDetailController alloc] init];
        detail.member = self.members[indexPath.row];
        [self.navigationController pushViewController:detail animated:YES];
    } else {    // 组点击
        
    }
}


/**
 *  右侧菜单点击
 */
- (void)rightClick:(UIButton *)button
{
    if (self.popover != nil ){
        [self.popover dismiss];
        return;
    }
    [button setBackgroundImage:[UIImage imageNamed:@"jihaoguanbi"] forState:UIControlStateNormal];
    DXPopover *popover = [DXPopover popover];
    self.popover = popover;
    // 修正位置
    UIView *view = [[UIView alloc] init];
    view.frame = button.frame;
    view.y = view.y - 33;
    [popover showAtView:view withContentView:self.innerView inView:self.view];
    popover.didDismissHandler = ^{
        [button setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
        self.innerView.layer.cornerRadius = 0.0;
        self.popover = nil;
    };
}


#pragma mark - lazy
// 菜单内容
- (UIView *)innerView
{
    if (!_innerView) {
        UIView *view = [[UIView alloc] init];
        view.size = CGSizeMake(137, 42);
        // 间距
        CGFloat magin = 1;
        // 分享
        UIButton *share = [[UIButton alloc] init];
        share.frame = CGRectMake(magin, magin, view.width - 2 * magin, view.height -  magin * 2);
        [share setBackgroundImage:[UIImage imageNamed:@"fenxianghongkuang"] forState:UIControlStateHighlighted];
        [share setImage:[UIImage imageNamed:@"fenzu_nor"] forState:UIControlStateNormal];
        [share setImage:[UIImage imageNamed:@"qunfa_down"] forState:UIControlStateHighlighted];
        [share setTitle:@"新建分组" forState:UIControlStateNormal];
        share.titleLabel.textColor = [UIColor blackColor];
        share.titleLabel.font = [UIFont systemFontOfSize:14];
        [share setTitleColor:YTColor(51, 51, 51) forState:UIControlStateNormal];
        [share setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        share.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        share.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        share.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [share addTarget:self action:@selector(creatGroup) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:share];
        _innerView = view;
    }
    return _innerView;
}

- (NSMutableArray *)groups
{
    if (!_groups) {
        // 获取历史数据
        NSString *lastGrpous = [CoreArchive strForKey:@"lastGrpous"];
        if (lastGrpous != nil) {
            _groups = [YTGroupModel objectArrayWithKeyValuesArray:[lastGrpous JsonToValue]];
        } else {
            _groups = [[NSMutableArray alloc] init];
        }
    }
    return _groups;
}

- (NSArray *)members
{
    if (!_members) {
        // 获取历史数据
        NSString *lastMembers = [CoreArchive strForKey:@"lastMembers"];
        if (lastMembers != nil) {
            _members = [YTMemberModel objectArrayWithKeyValuesArray:[lastMembers JsonToValue]];
        } else {
            _members = [[NSArray alloc] init];
        }
    }
    return _members;
}



@end
