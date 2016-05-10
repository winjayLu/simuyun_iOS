//
//  YTGroupDetailController.m
//  simuyun
//
//  Created by Luwinjay on 16/5/10.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTGroupDetailController.h"
#import "YTGroupModel.h"
#import "YTTeamMemberCell.h"
#import "YTMemberDetailController.h"
#import "DXPopover.h"

@interface YTGroupDetailController ()

// 弹出菜单
@property (nonatomic, strong) DXPopover *popover;

// 菜单内容
@property (nonatomic, strong) UIView *innerView;


@end

@implementation YTGroupDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 右上角加号
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, 22, 22);
    [button addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

/**
 *  编辑
 */
- (void)editClick
{
    [self.popover dismiss];
}

/**
 *  群发
 */
- (void)sendAllClick
{
    [self.popover dismiss];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.group.members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YTTeamMemberCell *cell = nil;
    static NSString *memberCell = @"teamMember";
    cell = [tableView dequeueReusableCellWithIdentifier:memberCell];
    if (cell==nil) {
        cell = [YTTeamMemberCell memberCell];
    }
    cell.member = self.group.members[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTMemberDetailController *detail = [[YTMemberDetailController alloc] init];
    detail.member = self.group.members[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];

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
    self.tableView.scrollEnabled = NO;
    popover.didDismissHandler = ^{
        [button setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
        self.innerView.layer.cornerRadius = 0.0;
        self.popover = nil;
        self.tableView.scrollEnabled = YES;
    };
}


#pragma mark - lazy
// 菜单内容
- (UIView *)innerView
{
    if (!_innerView) {
        CGFloat oneHeight = 42;
        
        UIView *view = [[UIView alloc] init];
        view.size = CGSizeMake(137, oneHeight * 2);
        // 间距
        CGFloat magin = 1;
        // 分享
        UIButton *share = [[UIButton alloc] init];
        share.frame = CGRectMake(magin, magin, view.width - 2 * magin, oneHeight - 2 * magin);
        [share setBackgroundImage:[UIImage imageNamed:@"fenxianghongkuang"] forState:UIControlStateHighlighted];
        [share setImage:[UIImage imageNamed:@"bianji_down"] forState:UIControlStateNormal];
        [share setImage:[UIImage imageNamed:@"bianji_nor"] forState:UIControlStateHighlighted];
        [share setTitle:@"编辑" forState:UIControlStateNormal];
        share.titleLabel.textColor = [UIColor blackColor];
        share.titleLabel.font = [UIFont systemFontOfSize:14];
        [share setTitleColor:YTColor(51, 51, 51) forState:UIControlStateNormal];
        [share setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        share.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        share.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        share.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [share addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:share];
        
        // 分割线
        UIView *line1 = [[UIView alloc] init];
        line1.frame = CGRectMake(0, oneHeight, view.width, 1);
        line1.backgroundColor = YTColor(203, 203, 203);
        [view addSubview:line1];
        
        // 获取详细资料
        UIButton *getDetail = [[UIButton alloc] init];
        getDetail.frame = CGRectMake(magin, CGRectGetMaxY(line1.frame) + magin, share.width, share.height - magin);
        [getDetail setBackgroundImage:[UIImage imageNamed:@"fenxianghongkuang"] forState:UIControlStateHighlighted];
        [getDetail setImage:[UIImage imageNamed:@"fenzu_nor"] forState:UIControlStateNormal];
        [getDetail setImage:[UIImage imageNamed:@"fenzu_down"] forState:UIControlStateHighlighted];
        [getDetail setTitle:@"群发" forState:UIControlStateNormal];
        [getDetail setTitleColor:YTColor(51, 51, 51) forState:UIControlStateNormal];
        [getDetail setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        getDetail.titleLabel.font = [UIFont systemFontOfSize:14];
        getDetail.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        getDetail.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        getDetail.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [getDetail addTarget:self action:@selector(sendAllClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:getDetail];
        
        _innerView = view;
    }
    return _innerView;
}



@end
