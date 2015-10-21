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

@interface YTProductViewController ()

@property (nonatomic, strong) NSArray *products;

@end

@implementation YTProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置颜色
    self.tableView.backgroundColor = YTViewBackground;
    // 去掉下划线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
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
    
    static NSString *identifier = @"productCell";
    YTProductCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell =[YTProductCell productCell];
    }
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = YES;
    cell.product = self.products[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116;
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
    YTBuyProductController *buy = [[YTBuyProductController alloc] init];
    buy.hidesBottomBarWhenPushed = YES;
    buy.product = self.products[indexPath.section];
    [self.navigationController pushViewController:buy animated:YES];
}




#pragma mark - 获取数据
- (void)loadProduct
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = @"cc0cc61140504258ab474b8f0a26bb56";
    [YTHttpTool get:YTProductList params:param
    success:^(NSDictionary *responseObject) {
        self.products = [YTProductModel objectArrayWithKeyValuesArray:responseObject[@"items"]];
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
