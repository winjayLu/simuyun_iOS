//
//  YTBottomView.m
//  simuyun
//
//  Created by Luwinjay on 15/10/10.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTBottomView.h"
#import "YTGroupCell.h"
#import "YTResourcesTool.h"
#import "YTUserInfoTool.h"

@interface YTBottomView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *titles;

@end

@implementation YTBottomView

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
        self.scrollEnabled = NO;
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YTUserInfo *userInfo = [YTUserInfoTool userInfo];
    //
    if (userInfo.teamNumber > 0 && self.titles.count == 2) {
        [self.titles insertObject:@"我的团队" atIndex:0];
    }
    return self.titles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"groupCell";
    YTGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YTGroupCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    YTUserInfo *userInfo = [YTUserInfoTool userInfo];
    cell.title = self.titles[indexPath.row];
    if ([cell.title isEqualToString:@"我的团队"]) {
        cell.title = [NSString stringWithFormat:@"我的团队（%d）",userInfo.teamNumber];
    } else if([cell.title isEqualToString:@"全部订单"]) {
        if (userInfo.preparedforNum == 0) {
            cell.detailTitle = @"";
        } else {
            cell.detailTitle = [NSString stringWithFormat:@"（%d笔订单待报备）", userInfo.preparedforNum];
        }
    } else {
        cell.detailTitle = @"";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 42;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.BottomDelegate respondsToSelector:@selector(didSelectedRow:)]) {
        [self.BottomDelegate didSelectedRow:(int)indexPath.row];
    }
}


- (NSMutableArray *)titles
{
    if (!_titles) {
        _titles = [NSMutableArray array];
        if([YTResourcesTool isVersionFlag] == NO)
        {
            [_titles addObject:@"全部订单"];
        } else {
            [_titles addObjectsFromArray:@[@"全部订单", @"云豆银行"]];
        }
    }
    return _titles;
}

@end
