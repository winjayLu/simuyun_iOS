//
//  YTDiscoverViewController.m
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//

#import "YTDiscoverViewController.h"
#import "CorePPTVC.h"
#import "CoreStatus.h"
#import "YTWebViewController.h"
#import "YTStockView.h"
#import "YTConsultView.h"
#import "YTNewest.h"
#import "YTInformationController.h"
#import "MJRefresh.h"
#import "YTStockModel.h"
#import "YTInformationWebViewController.h"
#import "NSDate+Extension.h"
#import "YTInformationTableViewCell.h"
#import "YTInformation.h"

// 左右间距
#define maginWidth 7
// 滚动视图的高度偏移量
#define pptvcY 64


@interface YTDiscoverViewController () <ConsultViewDelegate>

/**
 *  轮播滚动控制器
 */
@property (nonatomic, weak) CorePPTVC *pptVC;

/**
 *  股指视图
 */
@property (nonatomic, weak) YTStockView *stock;

/**
 *  滚动视图数据
 */
@property (nonatomic, strong) NSArray *ppts;

/**
 *  股指数据
 */
@property (nonatomic, strong) NSArray *stocks;

/**
 *  banner轮播图
 */
@property (nonatomic, strong) NSArray *banners;

/**
 *  资讯视图
 */
@property (nonatomic, weak) YTConsultView *consult;

/**
 *  咨询列表
 */
@property (nonatomic, strong) NSArray *newests;

@end

@implementation YTDiscoverViewController

- (void)loadView
{
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:DeviceBounds];
//    mainView.bounces = NO;
    mainView.showsVerticalScrollIndicator = NO;
    mainView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.view = mainView;
    self.view.backgroundColor = YTGrayBackground;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:@"nav_click" attributes:@{@"按钮" : @"发现"}];
    // 初始化轮播图片
    [self setupPPTVC];
    // 初始化股指视图
    [self setupStock];
    // 初始化咨讯
    [self setupConsult];
    
    // 获取轮播图片
    [self getAdvertise];
    
    // 获取股指数据
    [self loadStock];
    
    // 获取最新资讯列表
    [self loadNewes];
}


#pragma mark - 初始化方法
/**
 *  初始化轮播图片
 */
- (void)setupPPTVC
{
    CorePPTVC *pptvc = [[CorePPTVC alloc] init];
    pptvc.view.frame = CGRectMake(maginWidth, maginWidth, DeviceWidth - 2 * maginWidth, 134 + pptvcY);
    pptvc.view.layer.cornerRadius = 5;
    pptvc.view.layer.masksToBounds = YES;
    [self addChildViewController:pptvc];
    [self.view addSubview:pptvc.view];
    self.pptVC = pptvc;
    pptvc.pptItemClickBlock = ^(PPTModel *pptModel){
        [self pptVcClick:pptModel];
    };
    
}
/**
 *  初始化股指视图
 */
- (void)setupStock
{
    YTStockView *stock = [[YTStockView alloc] init];
    stock.frame = CGRectMake(maginWidth, CGRectGetMaxY(self.pptVC.view.frame) + maginWidth - pptvcY, self.pptVC.view.width, 89);
    stock.layer.cornerRadius = 5;
    stock.layer.masksToBounds = YES;
    [self.view addSubview:stock];
    self.stock = stock;
}
/**
 *  初始化资讯视图
 *
 */
- (void)setupConsult
{
    // 标题高度
    CGFloat headerH = 30;
    // cell高度
    CGFloat cellH = 93;
    CGFloat consultY = CGRectGetMaxY(self.stock.frame) + maginWidth;
    CGFloat consultH = headerH + cellH * self.newests.count;
    YTConsultView *consult = [[YTConsultView alloc] initWithFrame:CGRectMake(maginWidth, consultY, self.stock.width, consultH)];
    consult.layer.cornerRadius = 5;
    consult.layer.masksToBounds = YES;
    consult.layer.borderWidth = 1.0f;
    consult.layer.borderColor = YTColor(208, 208, 208).CGColor;
    consult.consultDelegate = self;
    [self.view addSubview:consult];
    self.consult = consult;
    
    [(UIScrollView *)self.view setContentSize:CGSizeMake(DeviceWidth, CGRectGetMaxY(consult.frame))];
}


#pragma mark - getServer
/**
 *  获取轮播图片地址
 */
- (void)getAdvertise
{
    NSDictionary *params = @{@"os" : @"ios-appstore"};
    [YTHttpTool get:YTBanner params:params success:^(id responseObject) {
        self.banners = [PPTModel objectArrayWithKeyValuesArray:responseObject];
        // 给banner设置图片
        self.pptVC.pptModels = self.banners;
    } failure:^(NSError *error) {
    }];
    
}

/**
 *  获取股指数据
 *
 */
- (void)loadStock
{
    [YTHttpTool get:YTStockindex params:nil success:^(id responseObject) {
        self.stocks = [YTStockModel objectArrayWithKeyValuesArray:responseObject];
        self.stock.stocks = self.stocks;
    } failure:^(NSError *error) {
        
    }];
    

}
/**
 *  获取资讯列表
 */
- (void)loadNewes
{
    [YTHttpTool get:YTNewes params:nil success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        self.newests = [YTInformation objectArrayWithKeyValuesArray:responseObject];
        // 设置数据
        self.consult.newests = self.newests;
        // 调整高度
        CGFloat headerH = 30;
        CGFloat cellH = 93;
        CGFloat consultH = headerH + cellH * self.newests.count - 1;
        self.consult.height = consultH;
        [(UIScrollView *)self.view setContentSize:CGSizeMake(DeviceWidth, CGRectGetMaxY(self.consult.frame) + maginWidth * 2 )];
    } failure:^(NSError *error) {
        
    }];
}
/**
 *  刷新数据
 */
- (void)loadNewData
{
    [self getAdvertise];
    [self loadStock];
    [YTHttpTool get:YTNewes params:nil success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        self.newests = [YTNewest objectArrayWithKeyValuesArray:responseObject];
        // 设置数据
        self.consult.newests = self.newests;
        // 调整高度
        CGFloat headerH = 30;
        CGFloat cellH = 93;
        CGFloat consultH = headerH + cellH * self.newests.count;
        self.consult.height = consultH;
        [(UIScrollView *)self.view setContentSize:CGSizeMake(DeviceWidth, CGRectGetMaxY(self.consult.frame) + maginWidth * 2)];
        [((UIScrollView *)self.view).header endRefreshing];
    } failure:^(NSError *error) {
        [((UIScrollView *)self.view).header endRefreshing];
    }];
}

/**
 *  轮播图片的点击事件
 *
 *  @param toUrl 跳转的地址
 */
- (void)pptVcClick:(PPTModel *)pptModel
{
    if (pptModel.extension_url != nil && pptModel.extension_url.length > 0) {
        
        YTWebViewController *webView = [[YTWebViewController alloc] init];
        webView.url = pptModel.extension_url;
        webView.toTitle = pptModel.title;
        webView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webView animated:YES];
    }
}

/**
 *  资讯视图代理方法
 *
 */
- (void)selectedCellWithRow:(YTInformation *)newest
{
    UIViewController *vc = nil;
    if(newest == nil)
    {
        vc = [[YTInformationController alloc] init];
    } else {
        vc = [YTInformationWebViewController webWithTitle:@"资讯详情" url:[NSString stringWithFormat:@"%@/information/%@&id=%@",YTH5Server, [NSDate stringDate], newest.infoId]];
        ((YTInformationWebViewController *)vc).isDate = YES;
        ((YTInformationWebViewController *)vc).information = newest;
    }
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 懒加载

- (NSArray *)ppts
{
    if (!_ppts) {
        _ppts = [[NSArray alloc] init];
    }
    return _ppts;
}

- (NSArray *)stocks
{
    if (!_stocks) {
        _stocks = [[NSArray alloc] init];
    }
    return _stocks;
}

- (NSArray *)newests
{
    if (!_newests) {
        _newests = [[NSArray alloc] init];
    }
    return _newests;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
