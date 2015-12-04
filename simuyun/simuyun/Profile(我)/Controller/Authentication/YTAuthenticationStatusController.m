//
//  YTAuthenticationStatusController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/27.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTAuthenticationStatusController.h"
#import "YTAccountTool.h"
#import "UIBarButtonItem+Extension.h"


@interface YTAuthenticationStatusController ()

// 真实姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLable;

// 机构名称
@property (weak, nonatomic) IBOutlet UILabel *organizationNameLable;

// 提示信息
@property (weak, nonatomic) IBOutlet UILabel *detailLable;


@end

@implementation YTAuthenticationStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"认证中";
    // 加载认证信息
    if (self.authen == nil) {
        [self loadAuthen];
    } else {
        self.nameLable.text = self.authen.realName;
        self.organizationNameLable.text = self.authen.orgName;
        if (self.authen.submitTime != nil) {
            self.detailLable.text = [NSString stringWithFormat:@"您于%@提交了资料，请联系您所在机构管理员在云台系统进行审核，如7日内没有审核通过，系统会自动驳回申请，对此有其他疑问，请致电400-188-8848或者在App中与平台客服直接联系。", self.authen.submitTime];
        } else
        {
            self.detailLable.text = @"您提交了资料，请联系您所在机构管理员在云台系统进行审核，如7日内没有审核通过，系统会自动驳回申请，对此有其他疑问，请致电400-188-8848或者在App中与平台客服直接联系。";
        }
    }
    
    // 初始化左侧返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithBg:@"fanhui" target:self action:@selector(blackClick)];
}

- (void)blackClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 加载认证信息
- (void)loadAuthen
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"advisersId"] = [YTAccountTool account].userId;
    [YTHttpTool get:YTAuthAdviser params:params success:^(id responseObject) {
        YTLog(@"%@", responseObject);
        YTAuthenticationModel *authen = [YTAuthenticationModel objectWithKeyValues:responseObject];
        self.authen = authen;
    } failure:^(NSError *error) {
        
    }];

}

- (void)setAuthen:(YTAuthenticationModel *)authen
{
    _authen = authen;
    self.nameLable.text = authen.realName;
    self.organizationNameLable.text = authen.orgName;
    self.detailLable.text = [NSString stringWithFormat:@"您于%@提交了资料，请联系您所在机构管理员在云台系统进行审核，如7日内没有审核通过，系统会自动驳回申请，对此有其他疑问，请致电400-188-8848或者在App中与平台客服直接联系。", authen.submitTime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
