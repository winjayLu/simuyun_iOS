//
//  YTViewPdfViewController.m
//  simuyun
//
//  Created by Luwinjay on 15/11/23.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTViewPdfViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "DXPopover.h"
#import "ShareCustomView.h"
#import "ShareManage.h"
#import "YTUserInfoTool.h"
#import "SVProgressHUD.h"

@interface YTViewPdfViewController () <shareCustomDelegate, UIWebViewDelegate>
@property (nonatomic, weak) UIWebView *webView;

// 弹出菜单
@property (nonatomic, strong) DXPopover *popover;

// 菜单内容
@property (nonatomic, strong) UIView *innerView;

/**
 *  分享视图
 */
@property (nonatomic, weak) ShareCustomView *customView;

@end

@implementation YTViewPdfViewController

- (void)loadView
{
    // 将控制器的View替换为webView
    UIWebView *mainView = [[UIWebView alloc] initWithFrame:DeviceBounds];
    
    mainView.scalesPageToFit = YES;
    [mainView.scrollView setShowsVerticalScrollIndicator:NO];
    mainView.delegate = self;
    self.webView = mainView;
    self.view = mainView;
    self.view.backgroundColor = YTColor(231, 231, 231);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品简版";
    self.webView.scalesPageToFit = YES;
    
    // 加载网页
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    // 右侧菜单
    [self setupRightMenu];
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
    if (self.popover != nil || self.customView != nil){
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
    share.share_title = self.shareTitle;
    // 如果有产品模型
    if (self.product) {
        if(self.product.type_code == 1)
        {
            share.share_content = [NSString stringWithFormat:@"私募云平台浮收项目%@开始募集，%@起投，%@封闭期", self.product.pro_name, self.product.buy_start, self.product.close_stage];
        } else {
            share.share_content = [NSString stringWithFormat:@"私募云平台固收项目%@开始募集，%@起投，%@投资期限", self.product.pro_name, self.product.buy_start, self.product.term];
        }
    }
    share.share_image = [UIImage imageNamed:@"WeChatPDF"];
    share.share_url = self.url;

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
    [MobClick event:@"share_click" attributes:@{@"内容类别" : @"pdf文档", @"分享途径" : @(tag) ,@"机构" : [YTUserInfoTool userInfo].organizationName}];
}





/**
 *  清理webView缓存
 */
- (void)dealloc
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


@end
