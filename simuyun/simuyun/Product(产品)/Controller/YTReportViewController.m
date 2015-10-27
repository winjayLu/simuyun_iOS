//
//  YTReportViewController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/21.
//  Copyright © 2015年 YTWealth. All rights reserved.
//
// 订单报备

#import "YTReportViewController.h"
#import "CoreTFManagerVC.h"
#import "NSString+Extend.h"
#import "YTPhotoView.h"
#import "UIView+Extension.h"

@interface YTReportViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, PhotoViewDelegate>

/**
 *  产品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *productNameLable;
/**
 *  订单编号
 */
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLable;
/**
 *  客户名称
 */
@property (weak, nonatomic) IBOutlet UILabel *customerNameLable;
/**
 *  认购金额
 */
@property (weak, nonatomic) IBOutlet UILabel *buyMoneyLable;

/**
 *  证件类型
 */
@property (weak, nonatomic) IBOutlet UITextField *typeField;
/**
 *  证件号码
 */
@property (weak, nonatomic) IBOutlet UITextField *numberField;
/**
 *  银行卡号
 */
@property (weak, nonatomic) IBOutlet UITextField *bankField;

/**
 *  结束银行卡号编辑
 *
 */
- (IBAction)endBankNumber:(UITextField *)sender;

/**
 *  开户行
 */
@property (weak, nonatomic) IBOutlet UITextField *bankHangField;

/**
 *  分行
 */
@property (weak, nonatomic) IBOutlet UITextField *branchField;

/**
 *  报备
 *
 */
- (IBAction)ReportClick:(UIButton *)sender;

/**
 *  证件选择器
 */
@property (nonatomic, weak) UIPickerView *picker;

/**
 *  证件类型
 */
@property (nonatomic, strong) NSArray *types;

/**
 *  打款凭条title
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

/**
 *  打款凭条图片选择器
 */
@property (nonatomic, weak) YTPhotoView *photo;
/**
 *  证件资料Lable
 */
@property (weak, nonatomic) IBOutlet UILabel *informationLable;

/**
 *  打款凭条图片选择器
 */
@property (nonatomic, weak) YTPhotoView *informationPhoto;

@end

@implementation YTReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化图片选择器
    [self setupPhotoView];
}
/**
 *  初始化图片选择器
 *
 */
- (void)setupPhotoView
{
    // 打款凭条
    CGFloat photoX = CGRectGetMaxX(self.titleLable.frame);
    YTPhotoView *photo = [[YTPhotoView alloc] initWithFrame:CGRectMake(photoX, self.titleLable.y - 20, DeviceWidth - photoX - 10, 53)];
    photo.delegate = self;
    [self.view addSubview:photo];
    self.photo = photo;
    
    // 证件资料
    CGFloat informationPhotoX = CGRectGetMaxX(self.informationLable.frame);
    YTPhotoView *informationPhoto = [[YTPhotoView alloc] initWithFrame:CGRectMake(photoX, self.informationLable.y - 20, DeviceWidth - informationPhotoX - 10, 53)];
    informationPhoto.delegate = self;
    [self.view addSubview:informationPhoto];
    self.informationPhoto = informationPhoto;
}


/**
 *  设置数据
 *
 */
- (void)setProuctModel:(YTProductModel *)prouctModel
{
    _prouctModel = prouctModel;
    self.productNameLable.text = prouctModel.pro_name;
    
    self.orderCodeLable.text = [NSString stringWithFormat:@"订单编号：%@",prouctModel.order_code];
    self.customerNameLable.text = [NSString stringWithFormat:@"客户：%@", prouctModel.customerName];
    self.buyMoneyLable.text = [NSString stringWithFormat:@"认购金额：%d", prouctModel.buyMoney];
}

/**
 *  报备
 *
 */
- (IBAction)ReportClick:(UIButton *)sender {
}

/**
 *  结束银行卡号编辑
 *
 */
- (IBAction)endBankNumber:(UITextField *)sender {
    if (sender.text.length == 6) {
        self.bankHangField.text = [NSString getBankFromCardNumber:sender.text];
    }
}


#pragma mark - pickerDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.types[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.typeField.text = self.types[row];
}


#pragma mark - 键盘处理

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [CoreTFManagerVC installManagerForVC:self scrollView:self.scroll tfModels:^NSArray *{
        UIPickerView *picker = [[UIPickerView alloc] init];
        picker.delegate = self;
        
        TFModel *tfm1=[TFModel modelWithTextFiled:self.typeField inputView:picker name:@"" insetBottom:11];
        TFModel *tfm2=[TFModel modelWithTextFiled:self.numberField inputView:nil name:@"" insetBottom:11];
        TFModel *tfm3=[TFModel modelWithTextFiled:self.bankField inputView:nil name:@"" insetBottom:65];
        TFModel *tfm4=[TFModel modelWithTextFiled:self.bankHangField inputView:nil name:@"" insetBottom:11];
        TFModel *tfm5=[TFModel modelWithTextFiled:self.branchField inputView:nil name:@"" insetBottom:11];
        
        return @[tfm1,tfm2,tfm3,tfm4,tfm5];
        
    }];
}


-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [CoreTFManagerVC uninstallManagerForVC:self];
}
#pragma mark - photoDelegate
-(void)addPicker:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - lazy

- (NSArray *)types
{
    if (!_types) {
        _types = [NSArray arrayWithObjects:@"身份证",@"护照",@"其他", nil];
    }
    return _types;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
