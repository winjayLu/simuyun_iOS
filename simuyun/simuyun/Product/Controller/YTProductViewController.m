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
#import "CorePagesView.h"
#import "CorePageModel.h"
#import "AFNetworking.h"
#import "CAAnimation+PagesViewBarShake.h"
#import "YTHotProductCell.h"
#import "SVProgressHUD.h"


@interface YTProductViewController () <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) NSMutableArray *products;

/**
 *  所有产品类型
 */
@property (nonatomic, strong) NSArray *proTypes;


/**
 *  选中的按钮
 */
@property (nonatomic, weak) UIButton *selectedButton;

/**
 *  滚动视图
 */
@property (nonatomic, weak) UIScrollView *scroll;

/**
 *  滚动线条
 */
@property (nonatomic, weak) UIView *lineView;

/**
 *  类型
 */
@property (nonatomic, assign) NSInteger series;

/**
 *  列表
 */
@property (nonatomic, weak) UITableView *tableView;


@end

@implementation YTProductViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:DeviceBounds];
    self.view = view;
    // 初始化顶部菜单
    [self setupTopView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 35, DeviceWidth, DeviceHight - 145)];
    tableView.backgroundColor = YTGrayBackground;
    // 去掉下划线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    // 设置下拉刷新
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadProduct)];
    // 上拉加载
    tableView.footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreProduct)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}
static UIWindow *_window;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载产品分类
    [self loadProductTypes];
    
    // 初始化顶部菜单
    [self setupTopView];
    // 获取数据
    [self.tableView.header beginRefreshing];
    
    // 新手指引
    if ([CoreArchive strForKey:@"firstProduct"] == nil && [CoreArchive strForKey:@"firstProduct"].length == 0) {
        _window = [[UIWindow alloc] initWithFrame:DeviceBounds];
        _window.backgroundColor = [UIColor clearColor];
        [_window makeKeyAndVisible];
        
        [CoreArchive setStr:@"firstProduct" key:@"firstProduct"];
        UIButton *newGuidelines = [[UIButton alloc] initWithFrame:_window.bounds];
        newGuidelines.backgroundColor = [UIColor clearColor];
        [newGuidelines setBackgroundImage:[UIImage imageNamed:@"chanpinzhiyin"] forState:UIControlStateNormal];
        [newGuidelines addTarget:self action:@selector(newGuidelinesClick:) forControlEvents:UIControlEventTouchUpInside];
        [_window addSubview:newGuidelines];
    }

}
/**
 *  新特性指引
 *
 */
- (void)newGuidelinesClick:(UIButton *)newGuidelines
{
    [newGuidelines removeFromSuperview];
    _window.hidden = YES;
    _window = nil;
}
/**
 *  初始化顶部菜单
 *
 */
- (void)setupTopView
{
    CGFloat topH = 35;
    // 顶部视图
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, 0, DeviceWidth, topH);
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    // 滑动产品分类
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.frame = CGRectMake(0, 0, DeviceWidth - 41, topH);
    scroll.backgroundColor = [UIColor clearColor];
    [scroll setShowsHorizontalScrollIndicator:NO];
    [topView addSubview:scroll];
    self.scroll = scroll;
    
    // 产品分类按钮
    CGFloat btnW = 51;
    for (int i = 0; i < self.proTypes.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        button.backgroundColor = [UIColor clearColor];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [button setTitleColor:YTColor(102, 102, 102) forState:UIControlStateNormal];
        [button setTitleColor:YTNavBackground forState:UIControlStateSelected];
        button.frame = CGRectMake(btnW * i, 0, btnW, topH);
        [button addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:self.proTypes[i] forState:UIControlStateNormal];
        if (i == 0) {
            button.selected = YES;
            self.selectedButton = button;
        }
        [scroll addSubview:button];
    }
    scroll.contentSize = CGSizeMake(btnW * self.proTypes.count, topH);
    
    // 滚动线条
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = YTNavBackground;
    lineView.frame = CGRectMake(0, topH - 2, btnW, 2);
    [scroll addSubview:lineView];
    self.lineView = lineView;
    
    // 分割线
    CGFloat lineH = 25;
    UIImageView *line = [[UIImageView alloc] init];
    line.image = [UIImage imageNamed:@"proshuxian"];
    line.frame = CGRectMake(CGRectGetMaxX(scroll.frame), (topH - lineH) * 0.5, 1, lineH);
    [topView addSubview:line];
    
    // 搜索按钮
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(CGRectGetMaxX(line.frame), 0, 40, topH);
    [button setBackgroundImage:[UIImage imageNamed:@"prosearch1"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:button];
}

- (void)typeClick:(UIButton *)button
{
    if (self.selectedButton == button) return;
    // 改变按钮状态
    self.selectedButton.selected = NO;
    [self.selectedButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    button.selected = YES;
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    self.selectedButton = button;
    // 调整按钮位置
    [self scrollViewFitContentOffsetWithBtnSelected:button];
    
    // 获取新数据
    [self loadNewDataWithType:button.titleLabel.text];
}

/**
 *  调整选中按钮的位置
 */
-(void)scrollViewFitContentOffsetWithBtnSelected:(UIButton *)button{
    //取出当前btn的中点
    CGFloat centerX = button.center.x;
    
    //计算最左侧的x值
    CGFloat leftX=centerX - self.scroll.width * 0.5f;
    
    //最左侧处理
    if(leftX<0) leftX=0;
    
    //最右侧处理
    CGFloat maxOffsetX=self.scroll.contentSize.width - self.scroll.width;
    if(leftX>=maxOffsetX) leftX=maxOffsetX;
    //构建contentOffset
    CGPoint offset=CGPointMake(leftX, 0);
    
    // 调整滚动条位置
    
    [UIView animateWithDuration:0.25 animations:^{
        self.scroll.contentOffset=offset;
        self.lineView.x = 51 * button.tag;
    } completion:^(BOOL finished) {
        [self.lineView.layer addAnimation:[CAAnimation shake] forKey:@"shake"];
    }];
}


- (void)loadProductTypes
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送一个GET请求
    
    [mgr GET:@"http://www.simuyun.com/peyunupload/label/productTypes.json" parameters:nil
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         self.proTypes = [NSString objectArrayWithKeyValuesArray:responseObject];
         // 存储获取到的数据
         NSString *oldSearchProduct = [responseObject JsonToString];
         [CoreArchive setStr:oldSearchProduct key:@"proTypes"];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     }];
}


#pragma mark - Search

- (void)searchClick
{
    YTSearchViewController *searchVc = [[YTSearchViewController alloc] init];
    searchVc.navigationItem.hidesBackButton = YES;
    searchVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVc animated:NO];
    [MobClick event:@"proSearch_click" attributes:@{@"按钮" : @"搜索框", @"机构" : [YTUserInfoTool userInfo].organizationName}];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YTProductModel *product = self.products[indexPath.section];
    UITableViewCell *cell;
    if (product.isHotProduct == YES) {  // 热推产品
        static NSString *identifier = @"hotProductCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell =[YTHotProductCell hotProductCell];
            cell.layer.cornerRadius = 10;
            cell.layer.masksToBounds = YES;
            cell.layer.borderWidth = 1.0f;
            cell.layer.borderColor = YTColor(208, 208, 208).CGColor;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        ((YTHotProductCell *)cell).product = product;
    } else {
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
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YTProductModel *product = self.products[indexPath.section];
    if (product.isHotProduct == YES) {
        return 193;
    }
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
- (void)loadNewDataWithType:(NSString *)type
{
    if ([type isEqualToString:@"泰山"]) {
        self.series = 1;
    } else if ([type isEqualToString:@"恒山"]){
        self.series = 3;
    } else if ([type isEqualToString:@"嵩山"]){
        self.series = 4;
    } else if ([type isEqualToString:@"昆仑山"]){
        self.series = 9;
    } else if ([type isEqualToString:@"黄河"]){
        self.series = 6;
    } else if ([type isEqualToString:@"长江"]){
        self.series = 5;
    } else if ([type isEqualToString:@"澜沧江"]){
        self.series = 7;
    } else if ([type isEqualToString:@"亚马逊"]){
        self.series = 8;
    } else if ([type isEqualToString:@"全部"]){
        self.series = 0;
    }
    [self loadProduct];
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeClear];
}

- (void)loadProduct
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = [YTAccountTool account].userId;
    param[@"offset"] = @"0";
    param[@"limit"] = @"8";
    if (self.series != 0) {
        param[@"series"] = @(self.series);
    }
    [YTHttpTool get:YTProductList params:param
            success:^(NSDictionary *responseObject) {
                [SVProgressHUD dismiss];
                [self.tableView.footer resetNoMoreData];
                self.products = [YTProductModel objectArrayWithKeyValuesArray:responseObject];
                if([ self.products count] < 8)
                {
                    [self.tableView.footer noticeNoMoreData];
                }
                // 存储获取到的数据
                if (self.series == 0)
                {
                    NSString *oldProducts = [responseObject JsonToString];
                    [CoreArchive setStr:oldProducts key:@"oldProducts"];
                }
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
    param[@"limit"] = @"8";
    if (self.series != 0) {
        param[@"series"] = @(self.series);
    }
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


- (NSArray *)proTypes
{
    if (!_proTypes) {
        // 获取历史数据
        NSString *oldProducts = [CoreArchive strForKey:@"proTypes"];
        if (oldProducts != nil) {
            _proTypes = [NSString objectArrayWithKeyValuesArray:[oldProducts JsonToValue]];
        } else {
            _proTypes = [NSArray arrayWithObjects:@"全部", @"黄河", @"嵩山", @"泰山", @"恒山", @"长江", @"亚马逊", @"昆仑山", @"澜沧江", nil];
        }
    }
    return _proTypes;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
