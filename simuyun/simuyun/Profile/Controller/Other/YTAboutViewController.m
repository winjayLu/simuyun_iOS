//
//  YTAboutViewController.m
//  simuyun
//
//  Created by Luwinjay on 15/12/1.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTAboutViewController.h"
#import "YTNormalWebController.h"


@interface YTAboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLable;
- (IBAction)pushUrl:(UIButton *)sender;

- (IBAction)serviceClick;

@end

@implementation YTAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"关于私募云";
    // 获取版本号
    self.versionLable.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)pushUrl:(UIButton *)sender {
    
    YTNormalWebController *webVc = [YTNormalWebController webWithTitle:@"盈泰财富云" url:@"http://www.caifuyun.cn"];
    [self.navigationController pushViewController:webVc animated:YES];
}

- (IBAction)serviceClick {
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:@"tel://400-188-8848"];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}

@end
