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
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.nameLable becomeFirstResponder];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
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
}

- (IBAction)nextBtn:(UIButton *)sender {
    
    // 本地校验
    if (self.nameLable.text == nil || [self.nameLable.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入投资人姓名"];
        return;
    } else if ([self.buyMoney.text intValue] == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"金额不能为0"];
        return;
    }
    // 判断剩余额度
//    if([self.buyMoney.text intValue] > self.product.remaining_amt)
//    {
//        [SVProgressHUD showErrorWithStatus:@"额度不足,请重新选择额度"];
//        return;
//    }
    
    [self buyNow];
}

/**
 *  认购
 */
- (void)buyNow
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"product_id"] = self.product.pro_id;
#warning 用户id
    dict[@"advisers_id"] = @"f787e670f5ef4d24943242fa03420be1";
    dict[@"cust_name"] = self.nameLable.text;
    dict[@"order_amt"] = self.buyMoney.text;
    /*
     "product_id": "",
     "advisers_id": "",
     "cust_id": "",
     "cust_name": "",
     "order_amt": ""
     */
    
//    [YTHttpTool post:YTOrder params:dict success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
    YTContentViewController *content = [[YTContentViewController alloc] init];
    [self.navigationController pushViewController:content animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
