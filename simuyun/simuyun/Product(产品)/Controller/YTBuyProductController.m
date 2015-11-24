//
//  YTBuyProductController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/20.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTBuyProductController.h"
#import "SVProgressHUD.h"
#import "YTContentViewController.h"
#import "YTAccountTool.h"
#import "YTUserInfoTool.h"

@interface YTBuyProductController ()

/**
 *  投资人姓名
 */
@property (weak, nonatomic) IBOutlet UITextField *nameLable;

/**
 *  投资金额
 */
@property (weak, nonatomic) IBOutlet UITextField *buyMoney;

/**
 *  调整购买金额
 *
 */
- (IBAction)buyNumber:(UIButton *)sender;

/**
 *  下一步
 *
 */
- (IBAction)nextBtn:(UIButton *)sender;


@end

@implementation YTBuyProductController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"填写认购信息";
    // 投资起点
    NSString *buy_start = self.product.buy_start;
    self.buyMoney.text = [buy_start substringToIndex:buy_start.length - 1];
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.nameLable becomeFirstResponder];
    
    [MobClick event:@"book_click" attributes:@{@"按钮" : @"客户姓名", @"机构" : [YTUserInfoTool userInfo].organizationName}];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
}


- (IBAction)buyNumber:(UIButton *)sender {
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
    
    // 旧的金额
    NSUInteger oldMoney = [self.buyMoney.text integerValue];
    if ([sender.titleLabel.text isEqualToString:@"100万"]) {
        oldMoney = 100;
    } else if([sender.titleLabel.text isEqualToString:@"300万"]) {
        oldMoney = 300;
    } else if([sender.titleLabel.text isEqualToString:@"500万"]) {
        oldMoney = 500;
    } else if([sender.titleLabel.text isEqualToString:@"+10万"]) {
        oldMoney += 10;
    } else if([sender.titleLabel.text isEqualToString:@"+50万"]) {
        oldMoney += 50;
    } else if([sender.titleLabel.text isEqualToString:@"+100万"]) {
        oldMoney += 100;
    }
    self.buyMoney.text = [NSString stringWithFormat:@"%zd",oldMoney];
    [MobClick event:@"book_click" attributes:@{@"按钮" : sender.titleLabel.text, @"机构" : [YTUserInfoTool userInfo].organizationName}];
}

- (IBAction)nextBtn:(UIButton *)sender {
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
    // 本地校验
    if (self.nameLable.text == nil || [self.nameLable.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请填写投资人姓名"];
        return;
    } else if ([self.buyMoney.text intValue] == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"金额不能为0"];
        return;
    }
    // 判断剩余额度
    YTLog(@"%d", self.product.remaining_amt);
    if([self.buyMoney.text intValue] > self.product.remaining_amt)
    {
        [SVProgressHUD showErrorWithStatus:@"额度不足,请重新选择额度"];
        return;
    }
    
    [self buyNow];
}

/**
 *  认购
 */
- (void)buyNow
{
    [SVProgressHUD showWithStatus:@"认购中" maskType:SVProgressHUDMaskTypeClear];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"product_id"] = self.product.pro_id;
    dict[@"advisers_id"] = [YTAccountTool account].userId;
    dict[@"cust_name"] = self.nameLable.text;
    dict[@"order_amt"] = self.buyMoney.text;
    [YTHttpTool post:YTOrder params:dict success:^(id responseObject) {
        [SVProgressHUD dismiss];
        self.product.customerName = self.nameLable.text;
        self.product.order_id = responseObject[@"order_id"];
        self.product.report_deadline = responseObject[@"report_deadline"];
        self.product.order_code = responseObject[@"order_code"];
        self.product.buyMoney = [self.buyMoney.text intValue];
        YTContentViewController *content = [[YTContentViewController alloc] init];
        content.prouctModel = self.product;
        [self.navigationController pushViewController:content animated:YES];
    } failure:^(NSError *error) {
    }];

    [MobClick event:@"book_click" attributes:@{@"按钮" : @"提交认购", @"机构" : [YTUserInfoTool userInfo].organizationName}];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
