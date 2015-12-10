//
//  YTCustomerView.m
//  QKInfoCardDemo
//
//  Created by Luwinjay on 15/12/10.
//  Copyright © 2015年 Qiankai. All rights reserved.
//

#import "YTCustomerView.h"

@interface YTCustomerView()


- (IBAction)okClick:(UIButton *)sender;
- (IBAction)cancelClick:(UIButton *)sender;

/**
 *  证件类型
 */
@property (weak, nonatomic) IBOutlet UILabel *credentialsnameLable;
/**
 *  证件号码
 */
@property (weak, nonatomic) IBOutlet UILabel *credentialsnumberLable;

/**
 *  银行卡号
 */
@property (weak, nonatomic) IBOutlet UILabel *custbankacctLable;
/**
 *  开户行
 */
@property (weak, nonatomic) IBOutlet UILabel *custbankLable;

/**
 *  分行支行
 */
@property (weak, nonatomic) IBOutlet UILabel *custbankdetail;

@end

@implementation YTCustomerView

+ (instancetype)customerView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"YTCustomerView" owner:nil options:nil] lastObject];
}

- (void)setCusomer:(YTCusomerModel *)cusomer
{
    _cusomer = cusomer;
    self.credentialsnameLable.text = cusomer.credentialsname;
    self.credentialsnumberLable.text = cusomer.credentialsnumber;
    self.custbankacctLable.text = cusomer.cust_bank_acct;
    self.custbankLable.text = cusomer.cust_bank;
    self.custbankdetail.text = cusomer.cust_bank_detail;
}



- (IBAction)okClick:(UIButton *)sender {
    [YTCenter postNotificationName:YTSelectedCustomer object:nil];
}

- (IBAction)cancelClick:(UIButton *)sender {
    [YTCenter postNotificationName:YTCancelCustomer object:nil];

}
@end
