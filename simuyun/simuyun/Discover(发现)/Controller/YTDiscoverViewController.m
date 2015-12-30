//
//  YTDiscoverViewController.m
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//

#import "YTDiscoverViewController.h"
#import "CorePPTVC.h"
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
#import "YTNormalWebController.h"
#import "YTUserInfoTool.h"



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
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 获取轮播图片
    // 获取股指数据
    // 获取最新资讯列表
    [self loadNewData];
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
    self.pptVC.pptModels = self.ppts;
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
    stock.frame = CGRectMake(maginWidth, CGRectGetMaxY(self.pptVC.view.frame) - pptvcY + 1, self.pptVC.view.width, 89 - maginWidth);
    stock.layer.cornerRadius = 5;
    stock.layer.masksToBounds = YES;
    [self.view addSubview:stock];
    self.stock = stock;
    self.stock.stocks = self.stocks;
}
/**
 *  初始化资讯视图
 *
 */
- (void)setupConsult
{
    // 标题高度
    CGFloat headerH = 33;
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
    consult.newests = self.newests;
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
        self.newests = [YTInformation objectArrayWithKeyValuesArray:responseObject];
        // 设置数据
        self.consult.newests = self.newests;
        // 调整高度
        CGFloat headerH = 33;
        CGFloat cellH = 93;
        CGFloat consultH = headerH + cellH * self.newests.count;
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
        self.newests = [YTInformation objectArrayWithKeyValuesArray:responseObject];
        // 设置数据
        self.consult.newests = self.newests;
        // 调整高度
        CGFloat headerH = 33;
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
        
        YTNormalWebController *webView = [[YTNormalWebController alloc] init];
        webView.url = pptModel.extension_url;
        webView.toTitle = pptModel.title;
        webView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webView animated:YES];
    }
    if (pptModel.title == nil) {
        pptModel.title = @"bannner没有名称";
    }
    
    [MobClick event:@"banner_click" attributes:@{@"名称" : pptModel.title, @"机构" : [YTUserInfoTool userInfo].organizationName}];
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
        if (newest.infoId == nil || newest.infoId.length == 0) {
            return;
        }
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
        // 初始化假数据
        PPTModel *ppt = [[PPTModel alloc] init];
        ppt.image = [UIImage imageNamed:@"tuxiangzhanwei"];
        _ppts = [NSArray arrayWithObjects:ppt, nil];
    }
    return _ppts;
}

- (NSArray *)stocks
{
    if (!_stocks) {
        // 初始化假数据
        NSMutableArray *temp = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            YTStockModel *stock = [[YTStockModel alloc] init];
            switch (i) {
                case 0:
                    stock.name = @"上证指数";
                    break;
                case 1:
                    stock.name = @"深证指数";
                    break;
                case 2:
                    stock.name = @"创业板指";
                    break;
                case 3:
                    stock.name = @"中小板指";
                    break;
            }
            stock.index = 0;
            stock.rate = 0;
            stock.volume = 0;
            stock.gain = 0.01;
            [temp addObject:stock];
        }
        
        _stocks = [NSArray arrayWithArray:temp];
    }
    return _stocks;
}



- (NSArray *)newests
{
    if (!_newests) {
        NSMutableArray *temp = [NSMutableArray array];
        for (int i = 0; i < 2; i++) {
            YTInformation *information = [[YTInformation alloc] init];
            information.title = @"欢迎来到盈泰财富云";
            information.summary = @"我们坚持B2B模式，服务于财富管理机构和资产管理机构。我们坚持从金融走向互联网，专注于“互联网+”财富管理。我们坚持以市场化的机制，提供体制化、平台化的强力支撑。";
            information.date = @"今天";
            [temp addObject:information];
        }
        _newests = [NSArray arrayWithArray:temp];
    }
    return _newests;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
