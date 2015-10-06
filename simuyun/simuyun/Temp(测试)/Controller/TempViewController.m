//
//  TempViewController.m
//  simuyun
//
//  Created by WJ-China on 15/9/10.
//  Copyright (c) 2015年 winjay. All rights reserved.
//


// 分享测试

#import "TempViewController.h"
#import "ShareCustomView.h"
#import "ShareManage.h"
#import "SVProgressHUD.h"

@interface TempViewController () <shareCustomDelegate>
//@interface TempViewController ()

- (IBAction)testClick:(id)sender;

/**
 *  分享视图
 */
@property (nonatomic, weak) ShareCustomView *customView;

@end

@implementation TempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)testClick:(id)sender {
    
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
    // 移除分享菜单
    [self.customView cancelMenu];
    //  分享工具类
    ShareManage *share = [ShareManage shareManage];
    //  设置分享内容
    [share shareConfig];
    share.share_title = @"杰哥正在帮你分享";
    share.share_content = @"盈泰财富云旗下主要互联网产品有自主研发的私募云App和InTime系统，通过产品、运营、营销和结算等相关服务，致力成为中国第三方财富管理行业最佳运营服务商。";
    share.share_image = [UIImage imageNamed:@"home_logo"];
    share.share_url = @"http://www.caifuyun.cn/";
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
}



@end
