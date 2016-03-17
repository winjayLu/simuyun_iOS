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
#import "SVProgressHUD.h"


@interface YTAuthenticationErrorController ()

// 真实姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLable;

// 机构名称
@property (weak, nonatomic) IBOutlet UILabel *organizationNameLable;

// 重新填写
- (IBAction)registerAutenClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *fatherLable;
@property (weak, nonatomic) IBOutlet UILabel *biaozhuLable;

@end

@implementation YTAuthenticationErrorController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.title = @"认证失败";
    [self loadAuthen];
    
    //获取数据
    NSString *text = @"您所提交的申请没有通过审核，请重新提交一次审核，对此有其他疑问，请致电400-188-8488或者在App中与平台客服直接联系。";
  
    //Label获取attStr式样
    self.biaozhuLable.attributedText = [self attributedStringWithStr:text];
}


- (NSMutableAttributedString *)attributedStringWithStr:(NSString *)str
{
    //创建NSMutableAttributedString实例，并将text传入
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
    //创建NSMutableParagraphStyle实例
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    //设置行距
    [style setLineSpacing:8.0f];
    
    //根据给定长度与style设置attStr式样]
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    return attStr;
}


// 加载认证信息
- (void)loadAuthen
{
    [SVProgressHUD showWithStatus:@"正在加载认证信息" maskType:SVProgressHUDMaskTypeClear];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"advisersId"] = [YTAccountTool account].userId;
    [YTHttpTool get:YTAuthAdviser params:params success:^(id responseObject) {
        [SVProgressHUD dismiss];
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
    self.fatherLable.text = authen.fatherName;
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
