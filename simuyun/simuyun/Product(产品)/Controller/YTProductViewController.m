//
//  YTProductViewController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/15.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTProductViewController.h"
#import "YTProductCell.h"
#import "YTProductModel.h"
#import "MJRefresh.h"
#import "YTBuyProductController.h"
#import "DXPopover.h"
#import "YTProductdetailController.h"
#import "UIBarButtonItem+Extension.h"
#import "NSDate+Extension.h"
#import "MJExtension.h"
#import "YTAccountTool.h"
#import "YTDataHintView.h"
#import "YTLiquidationCell.h"
#import "YTTabBarController.h"
#import "YTNavigationController.h"
#import "YTUserInfoTool.h"
#import "YTSearchViewController.h"
#import "NSString+JsonCategory.h"
#import "NSObject+JsonCategory.h"
#import "CoreArchive.h"


@interface YTProductViewController () <UISearchBarDelegate>


@property (nonatomic, strong) NSMutableArray *products;


/**
 *  搜索框
 */
@property (nonatomic, weak) UISearchBar *search;

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
    // 上拉加载
    self.tableView.footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreProduct)];
    
    
    UISearchBar *search = [[UISearchBar alloc] init];
    search.frame = CGRectMake(0, 0, DeviceWidth, 44);
    search.placeholder = @"产品搜索";
    search.delegate = self;
    self.tableView.tableHeaderView = search;
    self.search = search;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 获取数据
    [self loadProduct];
}

#pragma mark - SearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
//    // 隐藏悬浮按钮
//    UIWindow *keyWindow = nil;
//    for (UIWindow *window in [UIApplication sharedApplication].windows) {
//        if (window.windowLevel == 0) {
//            keyWindow = window;
//            break;
//        }
//    }
//    UIViewController *appRootVC = keyWindow.rootViewController;
//    if ([appRootVC isKindOfClass:[YTTabBarController class]]) {
//        YTTabBarController *tabBar = ((YTTabBarController *)appRootVC);
//        tabBar.floatView.boardWindow.hidden = YES;
//    }
    YTSearchViewController *searchVc = [[YTSearchViewController alloc] init];
    searchVc.navigationItem.hidesBackButton = YES;
    searchVc.hidesBottomBarWhenPushed = YES;
//    YTNavigationController *nav = [[YTNavigationController alloc] initWithRootViewController:searchVc];
//    [self presentViewController:nav animated:NO completion:nil];
    [self.navigationController pushViewController:searchVc animated:NO];
    [MobClick event:@"proSearch_click" attributes:@{@"按钮" : @"搜索框", @"机构" : [YTUserInfoTool userInfo].organizationName}];
    return NO;
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
        [MobClick event:@"productList_click" attributes:@{@"类型" : @"浮收产品", @"机构" : [YTUserInfoTool userInfo].organizationName}];
    } else {
        // fixed.html
        url = [NSString stringWithFormat:@"%@/product/fixed.html%@&id=%@", YTH5Server , [NSDate stringDate],product.pro_id];
        [MobClick event:@"productList_click" attributes:@{@"类型" : @"固收产品", @"机构" : [YTUserInfoTool userInfo].organizationName}];
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
    param[@"offset"] = @"0";
    param[@"limit"] = @"20";
    [YTHttpTool get:YTProductList params:param
    success:^(NSDictionary *responseObject) {
        [self.tableView.footer resetNoMoreData];
        self.products = [YTProductModel objectArrayWithKeyValuesArray:responseObject];
        if([ self.products count] < 20)
        {
            [self.tableView.footer noticeNoMoreData];
        }
        // 存储获取到的数据
        NSString *oldProducts = [responseObject JsonToString];
        [CoreArchive setStr:oldProducts key:@"oldProducts"];
        // 刷新表格
        [self.tableView reloadData];
        // 结束刷新状态
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error) {
        // 结束刷新状态
        [self.tableView.header endRefreshing];
    }];
}

/**
 *  加载更多产品
 */
- (void)loadMoreProduct
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = [YTAccountTool account].userId;
    param[@"offset"] = [NSString stringWithFormat:@"%zd", self.products.count];
    param[@"limit"] = @"20";
    [YTHttpTool get:YTProductList params:param success:^(id responseObject) {
        [self.tableView.footer endRefreshing];
        if([(NSArray *)responseObject count] == 0)
        {
            [self.tableView.footer noticeNoMoreData];
            return;
        } 
        [self.products addObjectsFromArray:[YTProductModel objectArrayWithKeyValuesArray:responseObject]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.footer endRefreshing];
    }];
}

#pragma mark - 懒加载
- (NSMutableArray *)products
{
    if (!_products) {
        // 获取历史数据
        NSString *oldProducts = [CoreArchive strForKey:@"oldProducts"];
        if (oldProducts != nil) {
            _products = [YTProductModel objectArrayWithKeyValuesArray:[oldProducts JsonToValue]];
        } else {
            _products = [[NSMutableArray alloc] init];
        }
    }
    return _products;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
