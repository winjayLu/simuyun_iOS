//
//  YTSearchViewController.m
//  simuyun
//
//  Created by Luwinjay on 15/12/21.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTSearchViewController.h"
#import "UIBarButtonItem+Extension.h"
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
#import "YTLiquidationCell.h"
//#import "UIView+Extension.h"

@interface YTSearchViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UISearchBar *search;

/**
 *  搜索到的产品列表
 */
@property (nonatomic, strong) NSArray *searchProducts;


@property (nonatomic, weak) UITableView *tableView;


@end

@implementation YTSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = YTGrayBackground;
    
    // 初始化tableview
    [self setupTableView];
    
    // 设置NavgationBar
    [self setupNavgationBar];
    [self.tableView reloadData];
}


- (void)setupNavgationBar
{
    // 搜索框
    UISearchBar *search = [[UISearchBar alloc] init];
    search.frame = CGRectMake(0, 0, DeviceWidth, 44);
    search.placeholder = @"请输入产品名称";
    self.navigationItem.titleView = search;
    self.search = search;
    
    // 取消按钮
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, 44, 44);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(blackClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] init];
    barItem.customView = button;
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)blackClick
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.searchProducts.count == 0) {
        [self.search becomeFirstResponder];
    } else {
        [self updateTableViewFrame];
    }
}
/**
 *  初始化tableview
 */
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHight - 310)];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    // 设置颜色
    self.tableView.backgroundColor = YTGrayBackground;
    // 去掉下划线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    
    UIView *hotSearch = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 40)];
    hotSearch.backgroundColor = [UIColor clearColor];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, DeviceWidth, 40)];
    lable.text = @"热门搜索";
    lable.textColor = YTColor(102, 102, 102);
    lable.font = [UIFont systemFontOfSize:13];
    [hotSearch addSubview:lable];
    self.tableView.tableHeaderView = hotSearch;
}

/**
 *  更新tableviewFrame
 */
- (void)updateTableViewFrame
{
    self.tableView.frame = CGRectMake(0, 0, DeviceWidth, DeviceHight);
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YTProductModel *product = self.products[indexPath.section];
    UITableViewCell *cell;
    if (self.searchProducts.count == 0)
    {
        
    }
    
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
    if (section == 0 && self.searchProducts.count == 0) {
        return 0;
    }
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
    // 退出键盘
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
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



#pragma mark - 懒加载
- (NSArray *)products
{
    if (!_products) {
        _products = [[NSArray alloc] init];
    }
    return _products;
}

- (NSArray *)searchProducts
{
    if (!_searchProducts) {
        _searchProducts = [[NSArray alloc] init];
    }
    return _searchProducts;
}

@end
