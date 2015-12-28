//
//  YTProductViewController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/15.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTProductViewController.h"
#import "YTProductCell.h"
#import "MJRefresh.h"
#import "YTProductModel.h"
#import "MJExtension.h"
#import "YTBuyProductController.h"
#import "YTAccountTool.h"
#import "DXPopover.h"
#import "YTProductdetailController.h"
#import "UIBarButtonItem+Extension.h"
#import "NSDate+Extension.h"
#import "YTDataHintView.h"
#import "YTLiquidationCell.h"

@interface YTProductViewController ()


@property (nonatomic, strong) NSArray *products;

@end

@implementation YTProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置颜色
    self.tableView.backgroundColor = YTGrayBackground;
    // 去掉下划线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    
    
    // 设置下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadProduct)];
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YTProductModel *product = self.products[indexPath.section];
    UITableViewCell *cell;
    if (product.state == 30)
    {
        static NSString *identifier = @"liquidation";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell =[YTLiquidationCell productCell];
            cell.layer.cornerRadius = 5;
            cell.layer.masksToBounds = YES;
            cell.layer.borderWidth = 1.0f;
            cell.layer.borderColor = YTColor(208, 208, 208).CGColor;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        ((YTLiquidationCell *)cell).product = product;
    } else {
        static NSString *identifier = @"productCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell =[YTProductCell productCell];
            cell.layer.cornerRadius = 5;
            cell.layer.masksToBounds = YES;
            cell.layer.borderWidth = 1.0f;
            cell.layer.borderColor = YTColor(208, 208, 208).CGColor;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        ((YTProductCell *)cell).product = product;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 122;
}

// 设置section的数目，即是你有多少个cell
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.products.count;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YTProductModel *product = self.products[indexPath.section];
    NSString *url = nil;

    if (product.type_code == 1) {
        url = [NSString stringWithFormat:@"%@/product/floating.html%@&id=%@", YTH5Server , [NSDate stringDate],product.pro_id];
    } else {
        // fixed.html
        url = [NSString stringWithFormat:@"%@/product/fixed.html%@&id=%@", YTH5Server , [NSDate stringDate],product.pro_id];
    }
    YTProductdetailController *web = [[YTProductdetailController alloc] init];
    web.url = url;
    web.hidesBottomBarWhenPushed = YES;
    web.product = self.products[indexPath.section];
    [self.navigationController pushViewController:web animated:YES];
}



#pragma mark - 获取数据
- (void)loadProduct
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = [YTAccountTool account].userId;
    if (self.series < 9) {
        param[@"series"] = @(self.series);
    }
    [YTHttpTool get:YTProductList params:param
    success:^(NSDictionary *responseObject) {
        self.products = [YTProductModel objectArrayWithKeyValuesArray:responseObject];
        // 刷新表格
        [self.tableView reloadData];
        // 结束刷新状态
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        // 结束刷新状态
        [self.tableView.header endRefreshing];
    }];
}

#pragma mark - 懒加载
- (NSArray *)products
{
    if (!_products) {
        _products = [[NSArray alloc] init];
    }
    return _products;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
