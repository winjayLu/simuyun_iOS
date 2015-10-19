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


// 左右间距
#define maginWidth 7
// 滚动视图的高度偏移量
#define pptvcY 64


@interface YTDiscoverViewController ()

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

@end

@implementation YTDiscoverViewController

- (void)loadView
{
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:DeviceBounds];
//    mainView.bounces = NO;
    mainView.showsVerticalScrollIndicator = NO;
    self.view = mainView;
    self.view.backgroundColor = YTViewBackground;
}


- (void)viewDidLoad {
    [super viewDidLoad];
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
    pptvc.view.backgroundColor = [UIColor blueColor];
    [self addChildViewController:pptvc];
    [self.view addSubview:pptvc.view];
    self.pptVC = pptvc;
    pptvc.pptItemClickBlock = ^(PPTModel *pptModel){
        [self pptVcClick:pptModel.extension_url];
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
    CGFloat consultH = headerH + cellH * 5;
    YTConsultView *consult = [[YTConsultView alloc] initWithFrame:CGRectMake(maginWidth, consultY, self.stock.width, consultH)];
    consult.layer.cornerRadius = 5;
    consult.layer.masksToBounds = YES;
    [self.view addSubview:consult];
    
    [(UIScrollView *)self.view setContentSize:CGSizeMake(DeviceWidth, CGRectGetMaxY(consult.frame) + maginWidth)];
}


#pragma mark - getServer
/**
 *  获取轮播图片地址
 */
- (void)getAdvertise
{
    
    PPTModel *pptModel1 = [[PPTModel alloc] init];
    pptModel1.image = [UIImage imageNamed:@"1"];
    
    
    PPTModel *pptModel2 = [[PPTModel alloc] init];
    pptModel2.image = [UIImage imageNamed:@"2"];
    
    
    PPTModel *pptModel3 = [[PPTModel alloc] init];
    pptModel3.image = [UIImage imageNamed:@"1"];
    
    
    PPTModel *pptModel4 = [[PPTModel alloc] init];
    pptModel4.image = [UIImage imageNamed:@"2"];
    
    
    PPTModel *pptModel5 = [[PPTModel alloc] init];
    pptModel5.image = [UIImage imageNamed:@"1"];
    
    PPTModel *pptModel6 = [[PPTModel alloc] init];
    pptModel6.image = [UIImage imageNamed:@"2"];
    
    self.pptVC.pptModels = @[pptModel1, pptModel2, pptModel3, pptModel4, pptModel5];
}

/**
 *  获取股指数据
 *
 */
- (void)loadStock
{
    self.stocks = [NSArray arrayWithObjects:@"1", @"2", @"3",@"2", @"3",@"2", @"3", nil];
    self.stock.stocks = self.stocks;

}



/**
 *  轮播图片的点击事件
 *
 *  @param toUrl 跳转的地址
 */
- (void)pptVcClick:(NSString *)toUrl
{
    YTWebViewController *webView = [[YTWebViewController alloc] init];
    webView.url = toUrl;
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:YES];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
