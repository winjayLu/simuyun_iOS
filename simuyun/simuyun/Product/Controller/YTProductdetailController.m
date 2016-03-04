//
//  YTProductdetailController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/29.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTProductdetailController.h"
#import "YHWebViewProgress.h"
#import "YHWebViewProgressView.h"
#import "UIBarButtonItem+Extension.h"
#import "DXPopover.h"
#import "ShareCustomView.h"
#import "ShareManage.h"
#import "SVProgressHUD.h"
#import "YTSenMailView.h"
#import "YTBuyProductController.h"
#import "NSDate+Extension.h"
#import "YTReportContentController.h"
#import "YTNormalWebController.h"
#import "YTUserInfoTool.h"
#import "YTViewPdfViewController.h"
#import "YTAuthenticationViewController.h"
#import "YTAuthenticationStatusController.h"
#import "YTAuthenticationErrorController.h"
#import "HHAlertView.h"
#import "YTTabBarController.h"
#import "CoreArchive.h"
#import "YTPlayerViewController.h"
#import "YTAccountTool.h"



@interface YTProductdetailController () <shareCustomDelegate, senMailViewDelegate, UIWebViewDelegate>
@property (nonatomic, weak) UIWebView *webView;

// 弹出菜单
@property (nonatomic, strong) DXPopover *popover;

// 菜单内容
@property (nonatomic, strong) UIView *innerView;

/**
 *  分享视图
 */
@property (nonatomic, weak) ShareCustomView *customView;

// 发送邮件视图
@property (nonatomic, weak) YTSenMailView *sendMailView;

/**
 *  进度条代理
 */
@property (nonatomic, strong) YHWebViewProgress *progressProxy;

@end

@implementation YTProductdetailController

- (void)loadView
{
    // 将控制器的View替换为webView
    UIWebView *mainView = [[UIWebView alloc] initWithFrame:DeviceBounds];
    
    mainView.scalesPageToFit = YES;
    [mainView.scrollView setShowsVerticalScrollIndicator:NO];
    mainView.delegate = self;
    mainView.opaque = NO;
    self.webView = mainView;
    self.view = mainView;
    self.view.backgroundColor = YTColor(231, 231, 231);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品详情";
    self.webView.scalesPageToFit = YES;

    // 加载网页
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    // 右侧菜单
    [self setupRightMenu];
    
    // 加载进度条
    [self setupProgress];
    
    if (self.proId != nil && self.proId.length > 0) {
        [self loadProductWithId];
    }
}


/**
 *  加载产品列表
 */
- (void)loadProductWithId
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = [YTAccountTool account].userId;
    param[@"proId"] = self.proId;
    [YTHttpTool get:YTProductList params:param success:^(id responseObject) {
        NSArray *products = [YTProductModel objectArrayWithKeyValuesArray:responseObject];
        if (products.count > 0) {
            self.product = products[0];
        }
    } failure:^(NSError *error) {
    }];
    self.proId = nil;
}

/**
 *  初始化进度条
 */
- (void)setupProgress
{
    // 创建进度条
    YHWebViewProgressView *progressView = [[YHWebViewProgressView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 2)];
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    progressView.barAnimationDuration = 0.5;
    progressView.progressBarColor = YTRGBA(0, 0, 0, 0.75);
    // 设置进度条
    self.progressProxy.progressView = progressView;
    // 将UIWebView代理指向YHWebViq   ewProgress
    self.webView.delegate = self.progressProxy;
    // 设置webview代理转发到self
    self.progressProxy.webViewProxy = self;
    // 添加到视图
    [self.view addSubview:progressView];
}

/**
 *  右侧菜单
 */
- (void)setupRightMenu
{
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, 22, 22);
    [button addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
/**
 *  右侧菜单点击
 */
- (void)rightClick:(UIButton *)button
{
    if (self.popover != nil || self.customView != nil || self.sendMailView != nil){
        [self.popover dismiss];
        return;
    }
    [button setBackgroundImage:[UIImage imageNamed:@"jihaoguanbi"] forState:UIControlStateNormal];
    DXPopover *popover = [DXPopover popover];
    self.popover = popover;
    // 修正位置
    UIView *view = [[UIView alloc] init];
    view.frame = button.frame;
    view.y = view.y - 33;
    [popover showAtView:view withContentView:self.innerView inView:self.view];
    popover.didDismissHandler = ^{
        [button setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
        self.innerView.layer.cornerRadius = 0.0;
        self.popover = nil;
    };
}





#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.progressProxy.progressView setProgress:1.0f animated:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    self.progressProxy.progressView.hidden = YES;
    [SVProgressHUD showErrorWithStatus:@"加载失败"];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[request URL] absoluteString];
    NSArray *result = [urlString componentsSeparatedByString:@":"];
    NSMutableArray *urlComps = [[NSMutableArray alloc] init];
    for (NSString *str in result) {
        [urlComps addObject:[str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"app"])
    {
        // 跳转的地址和标题
        if (urlComps.count) {
            NSString *command = urlComps[1];
            if ([command isEqualToString:@"buynow"])    // 认购
            {
                // 判断是否认证
                if (![self isAuthentication]) return NO;
                // 认购
                [self buyNow];
                [MobClick event:@"proDetail_click" attributes:@{@"产品" : self.product.pro_name, @"按钮" : @"认购", @"机构" : [YTUserInfoTool userInfo].organizationName}];
            } else if ([command isEqualToString:@"closepage"])  // 关闭页面
            {
                [self.navigationController popViewControllerAnimated:YES];
            } else if ([command isEqualToString:@"openpage"])   // 打开新页面
            {
                YTNormalWebController *normal = [[YTNormalWebController alloc] init];
                normal.isDate = YES;
                normal.url = [NSString stringWithFormat:@"%@%@", YTH5Server, urlComps[2]];
                normal.toTitle = urlComps[3];
                [self.navigationController pushViewController:normal animated:YES];
            } else if ([command isEqualToString:@"viewpdf"])    // 打开pdf
            {
                YTViewPdfViewController *viewPdf = [[YTViewPdfViewController alloc] init];
                viewPdf.product = self.product;
                viewPdf.url = urlComps[2];
                viewPdf.shareTitle = urlComps[3];
                [self.navigationController pushViewController:viewPdf animated:YES];
                [MobClick event:@"proDetail_click" attributes:@{@"产品" : self.product.pro_name, @"按钮" : @"pdf简版", @"机构" : [YTUserInfoTool userInfo].organizationName}];
            } else if([command isEqualToString:@"copytoclipboard"]) // copy字符串
            {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = [NSString stringWithFormat:@"%@\n%@",self.product.pro_name, urlComps[2]];
                [SVProgressHUD showSuccessWithStatus:@"复制成功"];
                [MobClick event:@"proDetail_click" attributes:@{@"产品" : self.product.pro_name, @"按钮" : @"复制打款帐号", @"机构" : [YTUserInfoTool userInfo].organizationName}];
            } else if ([command isEqualToString:@"cantbuy"])    // 不可认购状态
            {
                // 判断是否认证
                if (![self isAuthentication]) return NO;
                // 认购
                [self buyNow];
                [MobClick event:@"proDetail_click" attributes:@{@"产品" : self.product.pro_name, @"按钮" : @"认购", @"机构" : [YTUserInfoTool userInfo].organizationName}];
            } else if ([command isEqualToString:@"mobclick"])   // h5事件统计
            {
                [MobClick event:@"proDetail_click" attributes:@{@"产品" : self.product.pro_name, @"按钮" : urlComps[2], @"机构" : [YTUserInfoTool userInfo].organizationName}];
            } else if ([command isEqualToString:@"playVideo"])   // 视频播放
            {
                [self playVedio:urlComps[2]];
                [MobClick event:@"proDetail_click" attributes:@{@"产品" : self.product.pro_name, @"按钮" : @"产品详情播放视频", @"机构" : [YTUserInfoTool userInfo].organizationName}];
            }
        }
        return NO;
    }
    return YES;
}

/**
 *  播放视频
 */
- (void)playVedio:(NSString *)videoId
{
    UIWindow *keyWindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            keyWindow = window;
            break;
        }
    }
    UIViewController *appRootVC = keyWindow.rootViewController;
    if ([appRootVC isKindOfClass:[YTTabBarController class]]) {
        YTTabBarController *tabBar = ((YTTabBarController *)appRootVC);
        if (tabBar != nil) {
            FloatView *floatView = tabBar.floatView;
            YTPlayerViewController *player = tabBar.playerVc;
            if (player != nil && [player.vedio.videoId isEqualToString:videoId] ) {
                tabBar.floatView.boardWindow.hidden = YES;
                [self presentViewController:player animated:YES completion:nil];
            } else {
                [floatView removeFloatView];
                tabBar.playerVc = nil;
                tabBar.floatView = nil;
                YTPlayerViewController *player = [[YTPlayerViewController alloc] init];
                player.videoId = videoId;
                [self presentViewController:player animated:YES completion:nil];
                
            }
        }
    }
}



/**
 *  判断理财师是否认证
 */
- (BOOL)isAuthentication
{
    // 0 已认证， 1 未认证， 2 认证中， 3 驳回
    BOOL result = YES;
    YTUserInfo *userInfo = [YTUserInfoTool userInfo];
    UIViewController *vc = nil;
    switch (userInfo.adviserStatus) {
        case 0:
            return result;
        case 1:
            vc = [[YTAuthenticationViewController alloc] init];
            result = NO;
            break;
        case 2:
            vc = [[YTAuthenticationStatusController alloc] init];
            result = NO;
            break;
        case 3:
            vc = [[YTAuthenticationErrorController alloc] init];
            result = NO;
            break;
    }
    HHAlertView *alert = [HHAlertView shared];
    [alert showAlertWithStyle:HHAlertStyleJpush imageName:@"pushIconDock" Title:@"没有操作权限" detail:@"您还未认证为理财师，无法进行此操作" cancelButton:@"返回" Okbutton:@"立即认证" block:^(HHAlertButton buttonindex) {
        if (buttonindex == HHAlertButtonOk) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    return result;
}

// 认购
- (void)buyNow
{
    if (self.product == nil) return;
    HHAlertView *alert = [HHAlertView shared];
    if (self.product.state == 10)   // 可以购买
    {
        YTBuyProductController *buy = [[YTBuyProductController alloc] init];
        buy.product = self.product;
        [self.navigationController pushViewController:buy animated:YES];
    } else if (self.product.state == 20)    // 暂停募集
    {
        [alert showAlertWithStyle:HHAlertStyleJpush imageName:@"pushIconDock" Title:@"无法认购" detail:[NSString stringWithFormat:@"%@目前已经募集结束，您可以看看其它产品或联系平台客服。", self.product.pro_name] cancelButton:@"再看看" Okbutton:@"联系客服" block:^(HHAlertButton buttonindex) {
            if (buttonindex == HHAlertButtonOk) {
                YTNormalWebController *normal = [YTNormalWebController webWithTitle:@"平台客服" url:[NSString stringWithFormat:@"%@/livehelp%@",YTH5Server, [NSDate stringDate]]];
                normal.isDate = YES;
                normal.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:normal animated:YES];
            }
        }];
    } else if (self.product.state == 30)    // 已经清算
    {
        [alert showAlertWithStyle:HHAlertStyleJpush imageName:@"pushIconDock" Title:@"无法认购" detail:[NSString stringWithFormat:@"%@目前已经结算，您可以看看其它产品或联系平台客服。", self.product.pro_name] cancelButton:@"再看看" Okbutton:@"联系客服" block:^(HHAlertButton buttonindex) {
            if (buttonindex == HHAlertButtonOk) {
                YTNormalWebController *normal = [YTNormalWebController webWithTitle:@"平台客服" url:[NSString stringWithFormat:@"%@/livehelp%@",YTH5Server, [NSDate stringDate]]];
                normal.isDate = YES;
                normal.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:normal animated:YES];
            }
        }];
    } else {    // 未发行
        [alert showAlertWithStyle:HHAlertStyleJpush imageName:@"pushIconDock" Title:@"无法认购" detail:@"您所在的机构未同意发行该产品，您可以看看其它产品或联系平台客服。" cancelButton:@"再看看" Okbutton:@"联系客服" block:^(HHAlertButton buttonindex) {
            if (buttonindex == HHAlertButtonOk) {
                YTNormalWebController *normal = [YTNormalWebController webWithTitle:@"平台客服" url:[NSString stringWithFormat:@"%@/livehelp%@",YTH5Server, [NSDate stringDate]]];
                normal.isDate = YES;
                normal.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:normal animated:YES];
            }
        }];
    }
    [MobClick event:@"proDetail_click" attributes:@{@"产品" : self.product.pro_name, @"按钮" : @"认购", @"机构" : [YTUserInfoTool userInfo].organizationName}];
}






// 菜单内容
- (UIView *)innerView
{
    if (!_innerView) {
        UIView *view = [[UIView alloc] init];
        view.size = CGSizeMake(137, 84);
        // 间距
        CGFloat magin = 1;
        // 分享
        UIButton *share = [[UIButton alloc] init];
        share.frame = CGRectMake(magin, magin, view.width - 2 * magin, view.height * 0.5 - 2 * magin);
        [share setBackgroundImage:[UIImage imageNamed:@"fenxianghongkuang"] forState:UIControlStateHighlighted];
        [share setImage:[UIImage imageNamed:@"fenxiangzc"] forState:UIControlStateNormal];
        [share setImage:[UIImage imageNamed:@"fenxianganxia"] forState:UIControlStateHighlighted];
        [share setTitle:@"分享" forState:UIControlStateNormal];
        share.titleLabel.textColor = [UIColor blackColor];
        share.titleLabel.font = [UIFont systemFontOfSize:14];
        [share setTitleColor:YTColor(51, 51, 51) forState:UIControlStateNormal];
        [share setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        share.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        share.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        share.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [share addTarget:self action:@selector(shareClcik) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:share];
        
        // 分割线
        UIView *line = [[UIView alloc] init];
        line.frame = CGRectMake(0, view.height * 0.5, view.width, 1);
        line.backgroundColor = YTColor(203, 203, 203);
        [view addSubview:line];
        
        // 获取详细资料
        UIButton *getDetail = [[UIButton alloc] init];
        getDetail.frame = CGRectMake(magin, CGRectGetMaxY(line.frame) + magin, share.width, share.height - magin);
        [getDetail setBackgroundImage:[UIImage imageNamed:@"fenxianghongkuang"] forState:UIControlStateHighlighted];
        [getDetail setImage:[UIImage imageNamed:@"xiazai"] forState:UIControlStateNormal];
        [getDetail setImage:[UIImage imageNamed:@"xiazaianxia"] forState:UIControlStateHighlighted];
        [getDetail setTitle:@"获取详细资料" forState:UIControlStateNormal];
        [getDetail setTitleColor:YTColor(51, 51, 51) forState:UIControlStateNormal];
        [getDetail setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        getDetail.titleLabel.font = [UIFont systemFontOfSize:14];
        getDetail.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        getDetail.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        getDetail.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [getDetail addTarget:self action:@selector(DetailClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:getDetail];
        
        _innerView = view;
    }
    return _innerView;
}
// 分享
- (void)shareClcik
{
    [self.popover dismiss];
    self.popover = nil;
    
    if (self.customView != nil) return;
    
    //  设置分享视图平台数据
    NSArray *titleArr = [NSArray arrayWithObjects:@"微信好友",@"朋友圈",@"邮件",@"短信",@"复制链接", nil];
    NSArray *imgArr = [NSArray arrayWithObjects:@"ShareButtonTypeWxShare",@"ShareButtonTypeWxPyq",@"ShareButtonTypeEmail",@"ShareButtonTypeSms",@"ShareButtonTypeCopy", nil];
    //  创建自定义分享视图
    ShareCustomView *customView = [[ShareCustomView alloc] initWithTitleArray:titleArr imageArray:imgArr];
    customView.frame = self.view.bounds;
    
    //  设置代理
    customView.shareDelegate = self;
    [self.view addSubview:customView];
    self.customView = customView;
}
/**
 *  自定义分享视图代理方法
 *
 */
- (void)shareBtnClickWithIndex:(NSUInteger)tag
{
    [self.customView cancelMenu];
    self.customView = nil;
    if (tag == ShareButtonTypeCancel) return;
    // 移除分享菜单
    //  分享工具类
    ShareManage *share = [ShareManage shareManage];
    //  设置分享内容
    [share shareConfig];
    // 分享标题  传  产品名称
    share.share_title = self.product.pro_name;
    // 分享内容  传  分享子标题 share_summary
    share.share_content = self.product.share_summary;
    share.share_image = [UIImage imageNamed:@"maillogo"];
    if(self.product.type_code == 1)
    {
        // 分享地址
         share.share_url = [NSString stringWithFormat:@"http://www.simuyun.com/product/floating_shared.html?id=%@",self.product.pro_id];
    } else {
        share.share_url = [NSString stringWithFormat:@"http://www.simuyun.com/product/fixed_shared.html?id=%@",self.product.pro_id];
    }
    switch (tag) {
        case ShareButtonTypeWxShare:
            //  微信分享
            [share wxShareWithViewControll:self];
            break;
        case ShareButtonTypeWxPyq:
            //  朋友圈分享
            [share wxpyqShareWithViewControll:self];
            break;
        case ShareButtonTypeEmail:
            [share displayEmailComposerSheet:self];
            break;
        case ShareButtonTypeSms:
            //  短信分享
            [share smsShareWithViewControll:self];
            break;
        case ShareButtonTypeCopy:
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = share.share_url;
            [SVProgressHUD showSuccessWithStatus:@"复制成功"];
        }
            break;
    }
    [MobClick event:@"share_click" attributes:@{@"内容类别" : @"产品", @"分享途径" : @(tag) ,@"机构" : [YTUserInfoTool userInfo].organizationName}];
}



// 获取详细资料
- (void)DetailClick
{

    [self.popover dismiss];
    self.popover = nil;
    
    if (self.sendMailView != nil) return;
    
    YTSenMailView *sendMail = [[YTSenMailView alloc] initWithViewController:self];
    sendMail.frame = self.view.bounds;
    
    //  设置代理
    sendMail.sendDelegate = self;
    [self.view addSubview:sendMail];
    self.sendMailView = sendMail;
}

- (void)sendMail:(NSString *)mail
{
    // 发送请求
    [SVProgressHUD showWithStatus:@"正在发送" maskType:SVProgressHUDMaskTypeClear];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"email"] = mail;
    params[@"proId"] = self.product.pro_id;
    [YTHttpTool get:YTEmailsharing params:params success:^(id responseObject) {
        YTLog(@"%@", responseObject);
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        // 保存发送成功的Email
        [CoreArchive setStr:mail key:@"mail"];
        [self.sendMailView sendSuccess:YES];
        self.sendMailView = nil;
    } failure:^(NSError *error) {
    }];
    [MobClick event:@"proDetail_click" attributes:@{@"产品" : self.product.pro_name, @"按钮" : @"获取详细资料", @"机构" : [YTUserInfoTool userInfo].organizationName}];
}

- (YHWebViewProgress *)progressProxy
{
    if (!_progressProxy) {
        _progressProxy = [[YHWebViewProgress alloc] init];
    }
    return _progressProxy;
}



/**
 *  清理webView缓存
 */
- (void)dealloc
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
