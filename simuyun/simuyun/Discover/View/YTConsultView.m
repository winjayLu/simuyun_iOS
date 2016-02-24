//
//  YTConsultView.m
//  simuyun
//
//  Created by Luwinjay on 15/10/19.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTConsultView.h"
#import "YTNewest.h"
#import "YTInformationTableViewCell.h"

@interface YTConsultView() <UITableViewDelegate, UITableViewDataSource>



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

- (void)setNewests:(NSArray *)newests
{
    _newests = newests;
    [self reloadData];
}



#pragma mark - Table view data source

// 设置section的数目，即是你有多少个cell
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newests.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Information";
    YTInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YTInformationTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.isShowLine = NO;
    }
    cell.information = self.newests[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 93;
}


// 设置cell之间headerview的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 33; // you can have your own choice, of course
}
// 设置headerview的颜色
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    // 红点
    UIImageView *hong1 = [[UIImageView alloc] init];
    hong1.image = [UIImage imageNamed:@"weidu"];
    hong1.size = CGSizeMake(6, 6);
    hong1.center = view.center;
    hong1.x = 15;
    [view addSubview:hong1];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"资讯";
    title.font = [UIFont systemFontOfSize:17];
    title.textColor = YTColor(51, 51, 51);
    [title sizeToFit];
    title.center = view.center;
    title.x = CGRectGetMaxX(hong1.frame) + 15;
    [view addSubview:title];
    
    UIImageView *black = [[UIImageView alloc] init];
    black.image = [UIImage imageNamed:@"xiangyou"];
    black.size = black.image.size;
    black.center = view.center;
    black.x = self.width - black.image.size.width - 15;
    [view addSubview:black];
    
    [view addTarget:self action:@selector(titleClcik) forControlEvents:UIControlEventTouchUpInside];
    return view;
}

- (void)titleClcik
{
    if ([self.consultDelegate respondsToSelector:@selector(selectedCellWithRow:)]) {
        [self.consultDelegate selectedCellWithRow:nil];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YTInformation *newe = self.newests[indexPath.row];
    if ([self.consultDelegate respondsToSelector:@selector(selectedCellWithRow:)]) {
        [self.consultDelegate selectedCellWithRow:newe];
    }
}




@end
