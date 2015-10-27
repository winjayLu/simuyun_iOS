//
//  YTBuySuccessController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/20.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTBuySuccessController.h"
#import "YTReportContentController.h"
#import "ShareManage.h"


@interface YTBuySuccessController ()





/**
 *  报备
 */

- (IBAction)reportClick:(UIButton *)sender;
/**
 *  微信发送
 */
- (IBAction)weiChatClick:(UIButton *)sender;
/**
 *  邮件发送
 *
 */
- (IBAction)emailClick:(UIButton *)sender;
/**
 *  短信发送
 *
 */
- (IBAction)smsClick:(UIButton *)sender;

/**
 *  分享
 */
@property (nonatomic, strong) ShareManage *shareManage;

/**
 *  回产品中心
 */
- (IBAction)blackProductClcik:(UIButton *)sender;
/**
 *  客户名称
 */
@property (weak, nonatomic) IBOutlet UILabel *customerNameLable;
/**
 *  产品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *productNameLable;
/**
 *  认购金额
 */
@property (weak, nonatomic) IBOutlet UILabel *buyMoney;
/**
 *  募集账户名称
 */
@property (weak, nonatomic) IBOutlet UILabel *accountNameLable;
/**
 *  开户行
 */
@property (weak, nonatomic) IBOutlet UILabel *accountBankLable;
/**
 *  帐号
 */
@property (weak, nonatomic) IBOutlet UILabel *accountLable;

/**
 *  提示信息
 */
@property (weak, nonatomic) IBOutlet UILabel *tiShiLable;


@end

@implementation YTBuySuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
}
/**
 *  设置数据
 */
- (void)setProuctModel:(YTProductModel *)prouctModel
{
    _prouctModel = prouctModel;
    self.customerNameLable.text = prouctModel.customerName;
    self.productNameLable.text = prouctModel.pro_name;
    self.buyMoney.text = [NSString stringWithFormat:@"%d万",prouctModel.buyMoney];
    self.accountNameLable.text = prouctModel.raise_account_name;
    self.accountBankLable.text = prouctModel.raise_bank;
    self.accountLable.text = prouctModel.raise_account;
    self.tiShiLable.text = [NSString stringWithFormat:@"请于%@前完成一下操作，否则视为认购失败", prouctModel.end_time];
}


/**
 *  报备
 */

- (IBAction)reportClick:(UIButton *)sender {
    YTReportContentController *report = [[YTReportContentController alloc] init];
    report.prouctModel = self.prouctModel;
    [self.navigationController pushViewController:report animated:YES];
    
}
/**
 *  微信发送
 */
- (IBAction)weiChatClick:(UIButton *)sender {
    [self.shareManage wxShareWithViewControll:self];
    
}
/**
 *  邮件发送
 *
 */
- (IBAction)emailClick:(UIButton *)sender {
    [self.shareManage displayEmailComposerSheet:self];
}
/**
 *  短信发送
 *
 */
- (IBAction)smsClick:(UIButton *)sender {

    [self.shareManage smsShareWithViewControll:self];
}


- (ShareManage *)shareManage
{
    if (!_shareManage) {
        ShareManage *share = [ShareManage shareManage];
        share.share_title = @"ss";
        share.share_content = @"ssssss";
        share.share_url = nil;
        _shareManage = share;
    }
    return _shareManage;
}
/**
 *  回产品中心
 */
- (IBAction)blackProductClcik:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
