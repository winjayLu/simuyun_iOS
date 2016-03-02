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
#import "YTSearchProductCell.h"
#import "SVProgressHUD.h"
#import "YTUserInfoTool.h"
#import "YTTabBarController.h"
#import "AFNetworking.h"
#import "NSString+JsonCategory.h"
#import "NSObject+JsonCategory.h"
#import "CoreArchive.h"



@interface YTSearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, weak) UISearchBar *search;

/**
 *  搜索到的产品列表
 */
@property (nonatomic, strong) NSMutableArray *searchProducts;

/**
 *  搜索标题
 */
@property (nonatomic, strong) NSArray *searchTitles;


@property (nonatomic, weak) UITableView *tableView;

/**
 *  类型
 */
@property (nonatomic, assign) NSInteger series;

@end

@implementation YTSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置NavgationBar
    [self setupNavgationBar];
    
    self.view.backgroundColor = YTGrayBackground;
    
    // 初始化tableview
    [self setupTableView];
    

    // 获取数据
    [self loadProduct];
}


- (void)setupNavgationBar
{
    // 左侧占位符
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    view.frame = CGRectMake(0, 0, 0, 44);
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] init];
    leftItem.customView = view;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -5;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftItem, nil];

    
    // 搜索框
    UISearchBar *search = [[UISearchBar alloc] init];
    search.frame = CGRectMake(100, 0, DeviceWidth, 44);
    search.placeholder = @"请输入产品名称";
    search.delegate = self;
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.searchProducts.count == 0) {
        [self.search becomeFirstResponder];
        self.tableView.footer = nil;
    } else {
        [self updateTableViewFrame];
    }
}

/**
 *  搜索按钮
 *
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // 退出键盘
     [searchBar resignFirstResponder];
    
    // 开始搜索
    [self searchProductWithProductName:searchBar.text];
    [MobClick event:@"proSearch_click" attributes:@{@"搜索内容" : searchBar.text, @"机构" : [YTUserInfoTool userInfo].organizationName}];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (searchBar.text.length == 0) {
        self.searchProducts = nil;
        [self createHotTitle];
        self.tableView.footer = nil;
        [self.tableView reloadData];
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length == 0) {
        self.searchProducts = nil;
        [self createHotTitle];
        self.tableView.footer = nil;
        [self.tableView reloadData];
    }
    return YES;
}

/**
 *  按照产品名称搜索
 *
 */
- (void)searchProductWithProductName:(NSString *)productName
{
    [SVProgressHUD showWithStatus:@"正在搜索" maskType:SVProgressHUDMaskTypeClear];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = [YTAccountTool account].userId;
    param[@"proName"] = productName;
    param[@"offset"] = @"0";
    param[@"limit"] = @"8";
    [YTHttpTool get:YTProductList params:param
            success:^(NSDictionary *responseObject) {
                NSArray *products = [YTProductModel objectArrayWithKeyValuesArray:responseObject];
                if (products.count == 0) {
                    [SVProgressHUD showInfoWithStatus:@"没有相关的产品"];
                    return;
                }
                [SVProgressHUD dismiss];
                // 上拉加载
                if (products.count == 8) {
                    self.tableView.footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreProduct)];
                }
                self.searchProducts = [NSMutableArray arrayWithArray:products];
                self.tableView.tableHeaderView = nil;
                [self updateTableViewFrame];
                // 刷新表格
                [self.tableView reloadData];
            } failure:^(NSError *error) {

                if(error.userInfo[@"NSLocalizedDescription"] != nil)
                {
                    [SVProgressHUD showInfoWithStatus:@"网络链接失败\n请稍候再试"];
                } else {
                    [SVProgressHUD dismiss];
                }
            }];
}

/**
 *  加载更多产品
 */
- (void)loadMoreProduct
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = [YTAccountTool account].userId;
    param[@"offset"] = [NSString stringWithFormat:@"%zd", self.searchProducts.count];
    param[@"limit"] = @"20";
    if (self.search.text.length == 0) {
        param[@"series"] = @(self.series);
    } else {
        param[@"proName"] = self.search.text;
    }
    [YTHttpTool get:YTProductList params:param success:^(id responseObject) {
        [self.tableView.footer endRefreshing];
        if([(NSArray *)responseObject count] == 0)
        {
            self.tableView.footer = nil;
        }
        [self.searchProducts addObjectsFromArray:[YTProductModel objectArrayWithKeyValuesArray:responseObject]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.footer endRefreshing];
    }];
}


/**
 *  返回
 */
- (void)blackClick
{
    // 退出键盘
    [self.search resignFirstResponder];
    [self.navigationController popToRootViewControllerAnimated:NO];
    self.search.text = nil;
    self.searchProducts = nil;
    self.tableView.footer = nil;
    [self createHotTitle];
    [self.tableView reloadData];
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
    [self createHotTitle];
}

/**
 *  创建热门搜索标题
 */
- (void)createHotTitle
{
    // 容器
    UIView *continer = [[UIView alloc] init];
    continer.frame = CGRectMake(0, 0, DeviceWidth, 145);
    CGFloat magin = 15;
    CGFloat maginY = 10;
    CGFloat btnW = (DeviceWidth - magin * 5) * 0.25;
    CGFloat btnH = 33;
    // 分类按钮
    for (int i = 0; i < 8; i++) {
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundImage:[UIImage imageNamed:@"searchanniuzc"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"searchanniuax"] forState:UIControlStateHighlighted];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setTitleColor:YTColor(102, 102, 102) forState:UIControlStateNormal];
        [button setTitleColor:YTNavBackground forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(categoryClick:) forControlEvents:UIControlEventTouchUpInside];
        switch (i) {
            case 0:
                button.frame = CGRectMake(magin, maginY, btnW, btnH);
                [button setTitle:@"泰山" forState:UIControlStateNormal];
                button.tag = 1;
                break;
            case 1:
                button.frame = CGRectMake(btnW + magin * 2, maginY, btnW, btnH);
                [button setTitle:@"恒山" forState:UIControlStateNormal];
                button.tag = 3;
                break;
            case 2:
                button.frame = CGRectMake(btnW * 2 + magin * 3, maginY, btnW, btnH);
                [button setTitle:@"嵩山" forState:UIControlStateNormal];
                button.tag = 4;
                break;
            case 3:
                button.frame = CGRectMake(btnW * 3 + magin * 4, maginY, btnW, btnH);
                [button setTitle:@"昆仑山" forState:UIControlStateNormal];
                button.tag = 9;
                break;
            case 4:
                button.frame = CGRectMake(magin, maginY * 2 + btnH, btnW, btnH);
                [button setTitle:@"黄河" forState:UIControlStateNormal];
                button.tag = 6;
                break;
            case 5:
                button.frame = CGRectMake(btnW + magin * 2, maginY * 2 + btnH, btnW, btnH);
                [button setTitle:@"长江" forState:UIControlStateNormal];
                button.tag = 5;
                break;
            case 6:
                button.frame = CGRectMake(btnW * 2 + magin * 3, maginY * 2 + btnH, btnW, btnH);
                [button setTitle:@"澜沧江" forState:UIControlStateNormal];
                button.tag = 7;
                break;
            case 7:
                button.frame = CGRectMake(btnW * 3 + magin * 4, maginY * 2 + btnH, btnW, btnH);
                [button setTitle:@"亚马逊" forState:UIControlStateNormal];
                button.tag = 8;
                break;
        }
        [continer addSubview:button];
        
    }
    // 分割区域
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = YTColor(223, 223, 223);
    lineView.frame = CGRectMake(0, maginY * 3 + btnH * 2, DeviceWidth, 10);
    [continer addSubview:lineView];
    
    // 热门搜索
    UIView *hotSearch = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), DeviceWidth, 30)];
    hotSearch.backgroundColor = [UIColor clearColor];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, DeviceWidth, 40)];
    lable.text = @"热门搜索";
    lable.textColor = YTColor(102, 102, 102);
    lable.font = [UIFont systemFontOfSize:13];
    [hotSearch addSubview:lable];
    // 分割线
    UIView *shortLine = [[UIView alloc] init];
    shortLine.backgroundColor = YTColor(208, 208, 208);
    shortLine.frame = CGRectMake(20, 39, DeviceWidth - 40, 1);
    [hotSearch addSubview:shortLine];
    [continer addSubview:hotSearch];
    
    
    self.tableView.tableHeaderView = continer;
}

/**
 *  分类按钮点击
 *
 */
- (void)categoryClick:(UIButton *)btn
{
    // 退出键盘
    [self.search resignFirstResponder];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeClear];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = [YTAccountTool account].userId;
    param[@"series"] = @(btn.tag);
    self.series = btn.tag;
    param[@"offset"] = @"0";
    param[@"limit"] = @"8";
    [YTHttpTool get:YTProductList params:param
            success:^(NSDictionary *responseObject) {
                [SVProgressHUD dismiss];
                NSArray *products = [YTProductModel objectArrayWithKeyValuesArray:responseObject];
                // 上拉加载
                if (products.count == 8) {
                    self.tableView.footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreProduct)];
                }
                self.searchProducts = [NSMutableArray arrayWithArray:products];
                self.tableView.tableHeaderView = nil;
                [self updateTableViewFrame];
                // 刷新表格
                [self.tableView reloadData];
            } failure:^(NSError *error) {
                
                if(error.userInfo[@"NSLocalizedDescription"] != nil)
                {
                    [SVProgressHUD showInfoWithStatus:@"网络链接失败\n请稍候再试"];
                } else {
                    [SVProgressHUD dismiss];
                }
            }];
}

/**
 *  更新tableviewFrame
 */
- (void)updateTableViewFrame
{
    self.tableView.frame = CGRectMake(0, 0, DeviceWidth, DeviceHight - 64);
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    YTProductModel *product = nil;
    UITableViewCell *cell;
    if (self.searchProducts.count > 0) {
        product = self.searchProducts[indexPath.section];
    } else {    // 热门搜索
        static NSString *identifier = @"searchCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell =[YTSearchProductCell productCell];
        }
        ((YTSearchProductCell *)cell).searchTitle = self.searchTitles[indexPath.section];
        return cell;
    }
    
    // 搜索出来的产品
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
    if (self.searchProducts.count == 0)
    {
        return 40;
    } else {
        return 122;
    }
}

// 设置section的数目，即是你有多少个cell
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchProducts.count > 0) {
        return self.searchProducts.count;
    } else {
        return self.searchTitles.count;
    }
}
// 设置cell之间headerview的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if ((section == 0 && self.searchProducts.count == 0) || self.searchProducts.count == 0) {
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
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            [window endEditing:YES];
            break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YTProductModel *product = nil;
    if (self.searchProducts.count == 0) {
        NSString *searchProName = self.searchTitles[indexPath.section];
        [self searchProductWithProductName:searchProName];
        [MobClick event:@"proSearch_click" attributes:@{@"搜索内容" : [NSString stringWithFormat:@"位置:%zd;快捷内容:%@",indexPath.section, searchProName], @"机构" : [YTUserInfoTool userInfo].organizationName}];
        return;
    }
    product = self.searchProducts[indexPath.section];
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
    web.product = product;
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark - 获取热门搜索标题
- (void)loadProduct
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送一个GET请求
    
    [mgr GET:@"http://www.simuyun.com/peyunupload/label/hotproducttitle.json" parameters:nil
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         self.searchTitles = [NSString objectArrayWithKeyValuesArray:responseObject];
         [self.tableView reloadData];
         // 存储获取到的数据
         NSString *oldSearchProduct = [responseObject JsonToString];
         [CoreArchive setStr:oldSearchProduct key:@"oldSearchProduct"];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     }];
}


#pragma mark - 懒加载

- (NSMutableArray *)searchProducts
{
    if (!_searchProducts) {
        _searchProducts = [[NSMutableArray alloc] init];
    }
    return _searchProducts;
}


- (NSArray *)searchTitles
{
    if (!_searchTitles) {
        // 获取历史数据
        NSString *oldProducts = [CoreArchive strForKey:@"oldSearchProduct"];
        if (oldProducts != nil) {
            _searchTitles = [NSString objectArrayWithKeyValuesArray:[oldProducts JsonToValue]];
        } else {
            _searchTitles = [[NSMutableArray alloc] init];
        }
    }
    return _searchTitles;
}

@end
