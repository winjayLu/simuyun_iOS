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

@interface YTBottomView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *titles;

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
        self.scrollEnabled =NO;
    }
    return self;
}




#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"groupCell";
    YTGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YTGroupCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.title = self.titles[indexPath.row];
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


- (NSArray *)titles
{
    if (!_titles) {
        _titles = @[@"全部订单", @"我的奖品", @"云豆银行"];
        if([YTResourcesTool isVersionFlag] == NO)
        {
            
            _titles = @[@"全部订单"];
        }
    }
    return _titles;
}


- (void)isShow
{
    if([YTResourcesTool isVersionFlag] == NO)
    {
        _titles = @[@"全部订单", @"我的奖品", @"云豆银行"];
    }
}

@end
