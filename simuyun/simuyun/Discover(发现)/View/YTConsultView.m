//
//  YTConsultView.m
//  simuyun
//
//  Created by Luwinjay on 15/10/19.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTConsultView.h"
#import "YTStockCell.h"

@interface YTConsultView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *titles;

@end

@implementation YTConsultView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        // 禁用tableView滚动
        self.scrollEnabled =NO;
    }
    return self;
}


#pragma mark - Table view data source

// 设置section的数目，即是你有多少个cell
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"stockCell";
    YTStockCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YTStockCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 93;
}


// 设置cell之间headerview的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30; // you can have your own choice, of course
}
// 设置headerview的颜色
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *title = [[UILabel alloc] init];
    title.text = @"资讯";
    title.font = [UIFont systemFontOfSize:17];
    title.textColor = YTColor(51, 51, 51);
    [title sizeToFit];
    title.center = view.center;
    [view addSubview:title];
    
    // 红点1
    UIImageView *hong1 = [[UIImageView alloc] init];
    hong1.image = [UIImage imageNamed:@"weidu"];
    hong1.size = hong1.image.size;
    hong1.center = view.center;
    hong1.x = hong1.x - 35;
    [view addSubview:hong1];
    // 红点2
    UIImageView *hong2 = [[UIImageView alloc] init];
    hong2.image = [UIImage imageNamed:@"weidu"];
    hong2.size = hong2.image.size;
    hong2.center = view.center;
    hong2.x = hong2.x + 35;
    [view addSubview:hong2];
    return view;
}


#pragma mark - lazy

- (NSArray *)titles
{
    if (!_titles) {
        _titles = @[@"全部订单", @"我的奖品", @"云豆银行", @"我的奖品", @"云豆银行", @"我的奖品", @"云豆银行", @"我的奖品", @"云豆银行", @"我的奖品", @"云豆银行", @"我的奖品", @"云豆银行", @"我的奖品", @"云豆银行"];
    }
    return _titles;
}


@end
