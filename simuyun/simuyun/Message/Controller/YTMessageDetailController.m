//
//  YTNormalWebController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/29.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTMessageDetailController.h"
#import "YTAccountTool.h"
#import "NSDate+Extension.h"
#import "NSString+Password.h"
#import "YTAccountTool.h"
#import "YTReportContentController.h"
#import "YTProductModel.h"
#import "YTViewPdfViewController.h"
#import "YHWebViewProgress.h"
#import "YHWebViewProgressView.h"
#import "YTOrderdetailController.h"
#import "DXPopover.h"
#import "ShareCustomView.h"
#import "ShareManage.h"
#import "SVProgressHUD.h"
#import "YTUserInfoTool.h"


@interface YTMessageDetailController () <UIWebViewDelegate, shareCustomDelegate>



// 弹出菜单
@property (nonatomic, strong) DXPopover *popover;

// 菜单内容
@property (nonatomic, strong) UIView *innerView;

/**
 *  分享视图
 */
@property (nonatomic, weak) ShareCustomView *customView;

/**
 *  进度条代理
 */
@property (nonatomic, strong) YHWebViewProgress *progressProxy;

@end

@implementation YTMessageDetailController

+ (instancetype)webWithTitle:(NSString *)title url:(NSString *)url
{
    YTMessageDetailController *normal = [[self alloc] init];
    normal.toTitle = title;
    normal.url = url;
    return normal;
}


- (void)loadView
{
    // 将控制器的View替换为webView
    UIWebView *mainView = [[UIWebView alloc] initWithFrame:DeviceBounds];
    // 加时间戳
    if(self.isDate == NO)
    {
        NSMutableString *url = [NSMutableString string];
        [url appendString:self.url];
        [url appendString:[NSDate stringDate]];
        [mainView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    } else {
        [mainView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }

    mainView.scalesPageToFit = YES;
    mainView.delegate = self;
    mainView.opaque = NO;
    [mainView.scrollView setShowsVerticalScrollIndicator:NO];
    self.view = mainView;
    self.view.backgroundColor = YTGrayBackground;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 显示进度条
    self.title = @"正在加载";
    [self setupProgress];
    
    [self setupRightMenu];

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
    progressView.progressBarColor = YTRGBA(0, 0, 0, 0.7);
    // 设置进度条
    self.progressProxy.progressView = progressView;
    // 将UIWebView代理指向YHWebViq   ewProgress
    ((UIWebView *)self.view).delegate = self.progressProxy;
    // 设置webview代理转发到self
    self.progressProxy.webViewProxy = self;
    // 添加到视图
    [self.view addSubview:progressView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.progressProxy.progressView setProgress:1.0f animated:NO];
    
    self.title = self.toTitle;
    // 禁用用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    // 禁用长按弹出框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    self.progressProxy.progressView.hidden = YES;
    self.title = @"加载失败";
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIWebViewDelegate

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
            if ([command isEqualToString:@"openpage"])
            {
                YTMessageDetailController *normal = [[YTMessageDetailController alloc] init];
                normal.url = [NSString stringWithFormat:@"%@%@", YTH5Server, urlComps[2]];
                normal.isDate = YES;
                normal.toTitle = urlComps[3];
                [self.navigationController pushViewController:normal animated:YES];
            } else if ([command isEqualToString:@"closepage"])  // 关闭页面
            {
                [self.navigationController popViewControllerAnimated:YES];
            } else if ([command isEqualToString:@"filingdata"]) // 报备
            {
                YTReportContentController *report = [[YTReportContentController alloc] init];
                YTProductModel *product = [[YTProductModel alloc] init];
                product.order_id = urlComps[2];
                product.order_code = urlComps[3];
                product.customerName = urlComps[4];
                product.buyMoney = [urlComps[5] intValue];
                product.pro_name = urlComps[6];
                report.prouctModel = product;
                [self.navigationController pushViewController:report animated:YES];
            } else if ([command isEqualToString:@"viewpdf"])    // pdf浏览
            {
                YTViewPdfViewController *viewPdf = [[YTViewPdfViewController alloc] init];
                viewPdf.url = urlComps[2];
                viewPdf.shareTitle = urlComps[3];
                
                [self.navigationController pushViewController:viewPdf animated:YES];
            }
        }
        return NO;
    }
    return YES;
}

#pragma mark - 分享
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
    if (self.popover != nil || self.customView != nil)
    {
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

// 菜单内容
- (UIView *)innerView
{
    if (!_innerView) {
        UIView *view = [[UIView alloc] init];
        view.size = CGSizeMake(137, 42);
        // 间距
        CGFloat magin = 1;
        // 分享
        UIButton *share = [[UIButton alloc] init];
        share.frame = CGRectMake(magin, magin, view.width - 2 * magin, view.height -  magin * 2);
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
    share.share_title = self.message.title;
    share.share_content = self.message.summary;
    // 设置分享图片
    share.share_image = [UIImage imageNamed:self.shareImageName];
    share.share_url = [NSString stringWithFormat:@"http://www.simuyun.com/notice/shared.html?id=%@", self.message.messageId];
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
    [MobClick event:@"share_click" attributes:@{@"内容类别" : self.toTitle, @"分享途径" : @(tag) ,@"机构" : [YTUserInfoTool userInfo].organizationName}];
}



/**
 *  清理webView缓存
 */
- (void)dealloc
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

#pragma mark - lazy

- (YHWebViewProgress *)progressProxy
{
    if (!_progressProxy) {
        _progressProxy = [[YHWebViewProgress alloc] init];
    }
    return _progressProxy;
}




@end
