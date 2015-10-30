//
//  YTAuthenticationErrorController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/30.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTAuthenticationErrorController.h"
#import "YTAuthenticationModel.h"
#import "YTAccountTool.h"
#import "YTAuthenticationViewController.h"

@interface YTAuthenticationErrorController ()

// 真实姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLable;

// 机构名称
@property (weak, nonatomic) IBOutlet UILabel *organizationNameLable;

// 重新填写
- (IBAction)registerAutenClick:(UIButton *)sender;


@end

@implementation YTAuthenticationErrorController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAuthen];
}


// 加载认证信息
- (void)loadAuthen
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"advisersId"] = [YTAccountTool account].userId;
    [YTHttpTool get:YTAuthAdviser params:params success:^(id responseObject) {
        YTAuthenticationModel *authen = [YTAuthenticationModel objectWithKeyValues:responseObject];
        self.authen = authen;
    } failure:^(NSError *error) {
        
    }];
    
}

// 设置数据
- (void)setAuthen:(YTAuthenticationModel *)authen
{
    
    self.nameLable.text = authen.realName;
    self.organizationNameLable.text = authen.orgName;
}

- (IBAction)registerAutenClick:(UIButton *)sender {
    
    YTAuthenticationViewController *authenVc = [[YTAuthenticationViewController alloc] init];
    [self.navigationController pushViewController:authenVc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
