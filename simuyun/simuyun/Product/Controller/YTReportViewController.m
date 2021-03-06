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
#import "YTPhotoViewController.h"
#import "UIView+Extension.h"
#import "SVProgressHUD.h"
#import "UIImage+Extend.h"
#import "NSString+Extend.h"
#import "YTAccountTool.h"
#import "YTSlipModel.h"
#import "AFNetworking.h"
#import "NSString+Extend.h"
#import "JKAssets.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "YTUserInfoTool.h"
#import "YTOrderCenterController.h"
#import "YTCustomPickerView.h"


@interface YTReportViewController () <UITextFieldDelegate>
// UIPickerViewDelegate
// UIPickerViewDataSource
// UITextFieldDelegate

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
 *  打款凭条title
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

/**
 *  打款凭条图片选择器
 */
@property (nonatomic, weak) YTPhotoViewController *photo;
/**
 *  证件资料Lable
 */
@property (weak, nonatomic) IBOutlet UILabel *informationLable;

/**
 *  打款凭条图片选择器
 */
@property (nonatomic, weak) YTPhotoViewController *informationPhoto;

/**
 *  上传成功的打款凭条
 */
@property (nonatomic, strong) NSArray *Slips;

/**
 *  上传成功的证件图片
 */
@property (nonatomic, strong) NSArray *ZhenJian;

/**
 *  证件号码约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CertificatesNumberConstr;
/**
 *  参照lable
 */
@property (weak, nonatomic) IBOutlet UILabel *ReferenceLable;
/**
 *  参照分割线
 */
@property (weak, nonatomic) IBOutlet UIView *ReferenceLine;
/**
 *  证件名称视图
 */
@property (nonatomic, weak) UIView *certificatesView;
/**
 *  自定义证件名称
 */
@property (nonatomic, weak) UITextField *catesViewTypeName;

/**
 *  身份证二次验证
 */
@property (nonatomic, copy) NSString *numberValidation;

- (IBAction)typeBtnClick:(id)sender;

@end

@implementation YTReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化图片选择器
    [self setupPhotoView];
    self.view.backgroundColor = YTGrayBackground;
    self.typeField.userInteractionEnabled = NO;
}



/**
 *  设置客户数据
 *
 */
- (void)setCusomerModel:(YTCusomerModel *)cusomerModel
{

    _cusomerModel = cusomerModel;
    
    // 判断证件类型
    NSString *credentialsname = cusomerModel.credentialsname;
    if ([credentialsname isEqualToString:@"身份证"] || [credentialsname isEqualToString:@"护照"] || [credentialsname isEqualToString:@"港澳通行证"] || [credentialsname isEqualToString:@"营业执照"]) {
        self.typeField.text = credentialsname;
    } else {
        self.CertificatesNumberConstr.constant = 78;
        if (self.certificatesView == nil) {
            [self createCertificatesName];
            self.photo.view.y = self.titleLable.y - 15 + 53;
            self.informationPhoto.view.y = self.informationLable.y - 15 + 53;
            // 更新键盘位置
            [self updateKeyboardPosition:NO];
        }
        self.typeField.text = @"其它";
        self.catesViewTypeName.text = credentialsname;
    }
    
    // 证件号码
    self.numberField.text = cusomerModel.credentialsnumber;
    
    // 银行卡号
    // 拼接空格
    self.bankField.text = [self stringAppendNull:cusomerModel.cust_bank_acct];
    
    // 开户行
    self.bankHangField.text = cusomerModel.cust_bank;
    
    // 分行
    self.branchField.text = cusomerModel.cust_bank_detail;

}



/**
 *  初始化图片选择器
 *
 */
- (void)setupPhotoView
{
    // 打款凭条
    CGFloat photoX = CGRectGetMaxX(self.titleLable.frame);
    YTPhotoViewController *photo = [[YTPhotoViewController alloc] init];
    photo.viewWidth = DeviceWidth - photoX - 10;
    photo.view.frame = CGRectMake(photoX, self.titleLable.y - 15, DeviceWidth - photoX - 10, 53);
    [self.view addSubview:photo.view];
    [self addChildViewController:photo];
    self.photo = photo;
    
    
    // 证件资料
    CGFloat informationPhotoX = CGRectGetMaxX(self.informationLable.frame);
    YTPhotoViewController *informationPhoto = [[YTPhotoViewController alloc] init];
    informationPhoto.viewWidth = DeviceWidth - informationPhotoX - 10;
    informationPhoto.view.frame = CGRectMake(photoX, self.informationLable.y - 15, DeviceWidth - informationPhotoX - 10, 53);
    [self.view addSubview:informationPhoto.view];
    [self addChildViewController:informationPhoto];
    self.informationPhoto = informationPhoto;
    
}

/**
 *  报备
 *
 */
- (IBAction)ReportClick:(UIButton *)sender {
    // 本地验证
    if([self checkText]) return;
    [SVProgressHUD showWithStatus:@"正在报备" maskType:SVProgressHUDMaskTypeClear];
    // 上传打款凭条 和 证件资料
    [self uploadSlip];
}


// 上传打款凭条
- (void)uploadSlip
{
    
    NSMutableArray *files = [NSMutableArray array];
    for (UIImage *image in self.photo.selectedPhoto) {
        YTHttpFile *file = [[YTHttpFile alloc] init];
        // 文件名
        NSString *name = [NSString createCUID];
        file.filename = [NSString stringWithFormat:@"%@.jpg",name];
        file.name = [NSString stringWithFormat:@"%@",name];
        file.mimeType = @"image/jpg";
        // 文件数据
        file.data = UIImageJPEGRepresentation(image, 0.5);
        [files addObject:file];
    }
    [YTHttpTool post:YTSlip params:nil files:files success:^(id responseObject) {
        self.Slips = [YTSlipModel objectArrayWithKeyValuesArray:responseObject];
        if (self.informationPhoto.selectedPhoto.count == 0) {
            [self startReport];
        } else {
            [self uploadZhenJian];
        }
    } failure:^(NSError *error) {
    }];
}
// 上传证件资料
- (void)uploadZhenJian
{
    
    NSMutableArray *files = [NSMutableArray array];
    for (UIImage *image in self.informationPhoto.selectedPhoto) {
        YTHttpFile *file = [[YTHttpFile alloc] init];
        // 文件名
        NSString *name = [NSString createCUID];
        file.filename = [NSString stringWithFormat:@"%@.jpg",name];
        file.name = [NSString stringWithFormat:@"%@",name];
        file.mimeType = @"image/jpg";
        // 文件数据
        file.data = UIImageJPEGRepresentation(image, 0.5);
        [files addObject:file];
    }
    [YTHttpTool post:YTSlip params:nil files:files success:^(id responseObject) {
        self.ZhenJian = [YTSlipModel objectArrayWithKeyValuesArray:responseObject];
        [self startReport];
    } failure:^(NSError *error) {
    }];
}

// 开始报备
- (void)startReport
{

    // 证件名称
    NSString *typeName = nil;
    if ([self.typeField.text isEqualToString:@"其它"]) {
        typeName = self.catesViewTypeName.text;
    } else {
        typeName = self.typeField.text;
    }
    // 身份证是否做修改
    if (self.numberValidation.length > 0 && [self.numberValidation isEqualToString:self.numberField.text]) {
        [SVProgressHUD showInfoWithStatus:@"身份证号码与姓名不匹配，请修改后提交。"];
        return;
    }
    
    NSString *cust_id = @"";
    if (self.cusomerModel != nil)
    {
        cust_id = self.cusomerModel.cust_id;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"param"] = [NSString stringWithFormat:@"{\"cust_id\" : \"%@\",\"advisers_id\" : \"%@\", \"order_id\" : \"%@\", \"cust_name\" : \"%@\", \"cust_bank\" : \"%@\", \"cust_bank_detail\" : \"%@\", \"cust_bank_acct\" : \"%@\", \"credentialsname\" : \"%@\", \"credentialsnumber\" : \"%@\", \"annex\" : %@}",cust_id ,[YTAccountTool account].userId, self.prouctModel.order_id, self.prouctModel.customerName, self.bankHangField.text, self.branchField.text, [self nullStringWithString:self.bankField.text], typeName,self.numberField.text,[self annexWithSlps]];
    // 1.创建一个请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送一个POST请求
    NSString *newUrl = [NSString stringWithFormat:@"%@%@",YTServer, YTReport];
    [mgr POST:newUrl parameters:dict
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          YTOrderCenterController *orderVc = [[YTOrderCenterController alloc] init];
          orderVc.isOrder = YES;
          [self.navigationController pushViewController:orderVc animated:YES];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if(operation.responseObject[@"message"] != nil)
          {
              if ([operation.responseObject[@"message"] isEqualToString:@"tokenError"]) {
                  [YTHttpTool tokenError];
              } else {
                  NSString *errorStr = operation.responseObject[@"message"];
                  [SVProgressHUD showErrorWithStatus:errorStr];
                  if ([errorStr isEqualToString:@"身份证号码与姓名不匹配，请修改后提交。"])
                  {
                      self.numberValidation = self.numberField.text;
                  }
              }
          } else if(error.userInfo[@"NSLocalizedDescription"] != nil)
          {
              [SVProgressHUD showInfoWithStatus:@"网络链接失败\n请稍候再试"];
          } else {
              [SVProgressHUD showErrorWithStatus:@"报备失败"];
          }
      }];
}

// 拼接附件参数
- (NSString *)annexWithSlps
{
    // 拼接附件参数
    NSMutableString *annex = [NSMutableString string];
    // 打款凭条
    for (int i = 0; i < self.Slips.count; i++) {
        YTSlipModel *slip = self.Slips[i];
        if (i == 0) {
            [annex appendString:@"[{"];
            [annex appendString:@"\"annex_type\":\"1\""];
            [annex appendString:[NSString stringWithFormat:@",\"annex_path\":\"%@\"",slip.url]];
            [annex appendString:[NSString stringWithFormat:@",\"file_type\":\"%@\"",slip.type]];
            [annex appendString:[NSString stringWithFormat:@",\"file_name\":\"%@\"}",slip.original]];
        } else {
            [annex appendString:@",{\"annex_type\":\"1\""];
            [annex appendString:[NSString stringWithFormat:@",\"annex_path\":\"%@\"",slip.url]];
            [annex appendString:[NSString stringWithFormat:@",\"file_type\":\"%@\"",slip.type]];
            [annex appendString:[NSString stringWithFormat:@",\"file_name\":\"%@\"}",slip.original]];
        }
    }
    if (self.ZhenJian.count == 0) {
        [annex appendString:@"]"];
        return annex;
    }
    for (int i = 0; i < self.ZhenJian.count; i++) {
        YTSlipModel *slip = self.ZhenJian[i];
        [annex appendString:@",{\"annex_type\":\"2\""];
        [annex appendString:[NSString stringWithFormat:@",\"annex_path\":\"%@\"",slip.url]];
        [annex appendString:[NSString stringWithFormat:@",\"file_type\":\"%@\"",slip.type]];
        [annex appendString:[NSString stringWithFormat:@",\"file_name\":\"%@\"}",slip.original]];
    }
    [annex appendString:@"]"];
    return annex;
}


#pragma mark - 验证
// 本地验证
- (BOOL)checkText
{
    // 本地验证
    if (self.numberField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入证件号码"];
        return YES;
    } else if(self.bankField.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入银行卡号"];
        return YES;
    } else if(self.bankHangField.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入开户行"];
        return YES;
    } else if(self.branchField.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入分行支行"];
        return YES;
    }
     if(self.photo.selectedPhoto.count == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请上传打款凭条"];
        return YES;
    }
    if ([self.typeField.text isEqualToString:@"其它"]) {
        if (self.catesViewTypeName.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入证件名称"];
            return YES;
        }
    } else if([self.typeField.text isEqualToString:@"身份证"]){
        if(![NSString validateIdentityCard:self.numberField.text])
        {
            [SVProgressHUD showErrorWithStatus:@"身份证号码不正确"];
            return YES;
        }
    }
    
    return NO;
}



/**
 *  结束银行卡号编辑
 *
 */
- (IBAction)endBankNumber:(UITextField *)sender {
    sender.delegate = self;
    if (sender.text.length == 8) {
        self.bankHangField.text = [NSString getBankFromCardNumber:[self nullStringWithString:sender.text]];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length == 1) {
        textField.text = [NSString stringWithFormat:@" %@",textField.text];
    }
    if ([string isEqualToString:@""]) { // 删除字符
        if ((textField.text.length - 2) % 5 == 0) {
            textField.text = [textField.text substringToIndex:textField.text.length - 1];
        }
        return YES;
    } else
    {
        if (textField.text.length % 5 == 0) {
            textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
        }
    }
        return YES;
}

/**
 *  去除字符串中的空格
 *
 */
- (NSString *)nullStringWithString:(NSString *)str
{
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    
    NSArray *parts = [str componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    return [filteredArray componentsJoinedByString:@""];
}
/**
 *  按格式拼接空格
 *
 */
- (NSString *)stringAppendNull:(NSString *)str
{
    NSInteger count = str.length;
    if(count == 0) return @"";
    NSMutableString *string = [NSMutableString stringWithString:str];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 4) {
        count -= 4;
        NSRange rang = NSMakeRange(0, 4);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:newstring.length];
        [newstring insertString:@" " atIndex:newstring.length];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:newstring.length];
    return [NSString stringWithFormat:@" %@",newstring];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))
        return NO;
    return [super canPerformAction:action withSender:sender];
}

#pragma mark - 创建证件名称选项
- (void)createCertificatesName
{
    UIView *certificatesView = [[UIView alloc] init];
    certificatesView.backgroundColor = [UIColor clearColor];
    certificatesView.frame = CGRectMake(0, CGRectGetMaxY(self.ReferenceLine.frame) + 1, DeviceWidth, 53);
    [self.view addSubview:certificatesView];
    self.certificatesView = certificatesView;

    // 标题
    UILabel *lable = [[UILabel alloc] init];
    lable.frame = CGRectMake(10, 25, 0, 0);
    lable.text = @"证件名称：";
    lable.font = [UIFont systemFontOfSize:15];
    [lable sizeToFit];
    lable.textColor = YTColor(102, 102, 102);
    [certificatesView addSubview:lable];
    
    // 输入框
    UITextField *inputName = [[UITextField alloc] init];
    CGFloat inputX = CGRectGetMaxX(lable.frame) + 20;
    CGFloat inputW = DeviceWidth - inputX - 10;
    inputName.size = CGSizeMake(inputW, 30);
    inputName.center = lable.center;
    inputName.x = inputX;
    [inputName setFont:lable.font];
    inputName.tintColor = YTColor(51, 51, 51);
    inputName.textColor = YTColor(51, 51, 51);
    inputName.textAlignment = NSTextAlignmentRight;
    [certificatesView addSubview:inputName];
    self.catesViewTypeName = inputName;
    
    // 分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = YTColor(208, 208, 208);
    line.frame = CGRectMake(10, certificatesView.height - 1, DeviceWidth, 1);
    [certificatesView addSubview:line];
}



#pragma mark - 键盘处理

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 退出键盘
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            [window endEditing:YES];
            break;
        }
    }
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [CoreTFManagerVC installManagerForVC:self scrollView:self.scroll tfModels:^NSArray *{
        TFModel *tfm2=[TFModel modelWithTextFiled:self.numberField inputView:nil name:@"" insetBottom:65];
        TFModel *tfm3=[TFModel modelWithTextFiled:self.bankField inputView:nil name:@"" insetBottom:65];
        TFModel *tfm4=[TFModel modelWithTextFiled:self.bankHangField inputView:nil name:@"" insetBottom:65];
        TFModel *tfm5=[TFModel modelWithTextFiled:self.branchField inputView:nil name:@"" insetBottom:11];
        
        return @[tfm2,tfm3,tfm4,tfm5];
        
    }];
    
}

// 设置键盘位置
- (void)updateKeyboardPosition:(BOOL)isIncrease
{
    if (isIncrease) {   // 选择了身份证或护照
        [CoreTFManagerVC uninstallManagerForVC:self];
        [CoreTFManagerVC installManagerForVC:self scrollView:self.scroll tfModels:^NSArray *{
            TFModel *tfm2=[TFModel modelWithTextFiled:self.numberField inputView:nil name:@"" insetBottom:11];
            TFModel *tfm3=[TFModel modelWithTextFiled:self.bankField inputView:nil name:@"" insetBottom:11];
            TFModel *tfm4=[TFModel modelWithTextFiled:self.bankHangField inputView:nil name:@"" insetBottom:11];
            TFModel *tfm5=[TFModel modelWithTextFiled:self.branchField inputView:nil name:@"" insetBottom:-43];
            
            return @[tfm2,tfm3,tfm4,tfm5];
            
        }];
        self.scroll.contentSize = CGSizeMake(DeviceWidth, self.view.height);
        return;
    }
    //   选择了其他
    [CoreTFManagerVC uninstallManagerForVC:self];
    [CoreTFManagerVC installManagerForVC:self scrollView:self.scroll tfModels:^NSArray *{
        TFModel *tfm6 = [TFModel modelWithTextFiled:self.catesViewTypeName inputView:nil name:@"" insetBottom:65];
        TFModel *tfm2=[TFModel modelWithTextFiled:self.numberField inputView:nil name:@"" insetBottom:119];
        TFModel *tfm3=[TFModel modelWithTextFiled:self.bankField inputView:nil name:@"" insetBottom:119];
        TFModel *tfm4=[TFModel modelWithTextFiled:self.bankHangField inputView:nil name:@"" insetBottom:119];
        TFModel *tfm5=[TFModel modelWithTextFiled:self.branchField inputView:nil name:@"" insetBottom:65];
        
        return @[tfm6,tfm2,tfm3,tfm4,tfm5];
        
    }];
    self.scroll.contentSize = CGSizeMake(DeviceWidth, self.view.height + 53);
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


- (NSArray *)Slips
{
    if (!_Slips) {
        _Slips = [[NSArray alloc] init];
    }
    return _Slips;
}

- (NSArray *)ZhenJian
{
    if (!_ZhenJian) {
        _ZhenJian = [[NSArray alloc] init];
    }
    return _ZhenJian;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)typeBtnClick:(id)sender {
    // 退出键盘
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            [window endEditing:YES];
            break;
        }
    }
    YTCustomPickerView *addressPickerView = [[YTCustomPickerView alloc]init];
    addressPickerView.types = @[@"身份证",@"护照",@"港澳通行证", @"营业执照", @"其它"];
    addressPickerView.block = ^(YTCustomPickerView *view,UIButton *btn,NSString *selectType){
        self.typeField.text = selectType;
        // 判断是否是其他类型
        if ([selectType isEqualToString:@"其它"]) {
            self.CertificatesNumberConstr.constant = 78;
            if (self.certificatesView == nil) {
                [self createCertificatesName];
                self.photo.view.y = self.titleLable.y - 15 + 53;
                self.informationPhoto.view.y = self.informationLable.y - 15 + 53;
                // 更新键盘位置
                [self updateKeyboardPosition:NO];
            }
            
        } else {
            self.CertificatesNumberConstr.constant = 25;
            if (self.certificatesView != nil) {
                [self.certificatesView removeFromSuperview];
                self.certificatesView = nil;
                self.photo.view.y = self.titleLable.y - 15 - 53;
                self.informationPhoto.view.y = self.informationLable.y - 15 - 53;
                // 更新键盘位置
                [self updateKeyboardPosition:YES];
            }
        }
        [MobClick event:@"orderDetail_click" attributes:@{ @"按钮" : @"选择证件类型", @"机构" : [YTUserInfoTool userInfo].organizationName}];
    };
    [addressPickerView showWithSlectedType:self.typeField.text];
}
@end
