//
//  YTBottomView.m
//  simuyun
//
//  Created by Luwinjay on 15/10/10.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTBottomView.h"
#import "YTGroupCell.h"

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
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title = self.titles[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 42;
}

- (NSArray *)titles
{
    if (!_titles) {
        _titles = @[@"全部订单", @"我的奖品", @"云豆银行"];
    }
    return _titles;
}


@end
