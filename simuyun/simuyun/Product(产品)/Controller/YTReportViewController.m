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


@interface YTReportViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextFieldDelegate>

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

@end

@implementation YTReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化图片选择器
    [self setupPhotoView];
    self.view.backgroundColor = YTGrayBackground;
    self.typeField.delegate = self;
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
 *  设置数据
 *
 */
- (void)setProuctModel:(YTProductModel *)prouctModel
{
    _prouctModel = prouctModel;
    self.productNameLable.text = prouctModel.pro_name;
    
    self.orderCodeLable.text = [NSString stringWithFormat:@"订单编号：%@",prouctModel.order_code];
    self.customerNameLable.text = [NSString stringWithFormat:@"客户：%@", prouctModel.customerName];
    self.buyMoneyLable.text = [NSString stringWithFormat:@"认购金额：%d万", prouctModel.buyMoney];
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
    YTLog(@"%zd",files.count);
    [YTHttpTool post:YTSlip params:nil files:files success:^(id responseObject) {
        YTLog(@"%@", responseObject);
        self.Slips = [YTSlipModel objectArrayWithKeyValuesArray:responseObject];
        if (self.informationPhoto.selectedPhoto.count == 0) {
            [self startReport];
        } else {
            [self uploadZhenJian];
        }
    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"报备失败"];
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
        //        YTLog(@"%@", responseObject);
        self.ZhenJian = [YTSlipModel objectArrayWithKeyValuesArray:responseObject];
        [self startReport];
    } failure:^(NSError *error) {
        //        [SVProgressHUD showErrorWithStatus:@"报备失败"];
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
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"param"] = [NSString stringWithFormat:@"{\"advisers_id\" : \"%@\", \"order_id\" : \"%@\", \"cust_name\" : \"%@\", \"cust_bank\" : \"%@\", \"cust_bank_detail\" : \"%@\", \"cust_bank_acct\" : \"%@\", \"credentialsname\" : \"%@\", \"credentialsnumber\" : \"%@\", \"annex\" : %@}",[YTAccountTool account].userId, self.prouctModel.order_id, self.prouctModel.customerName, self.bankHangField.text, self.branchField.text, self.bankField.text, typeName,self.numberField.text,[self annexWithSlps]];
    // 1.创建一个请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSLog(@"%@", dict);
    
    // 2.发送一个POST请求
    NSString *newUrl = [NSString stringWithFormat:@"%@%@",YTServer, YTReport];
    [mgr POST:newUrl parameters:dict
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          [SVProgressHUD showSuccessWithStatus:@"报备成功"];
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              
              [self.navigationController popToRootViewControllerAnimated:YES];
          });
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if(operation.responseObject[@"message"] != nil)
          {
              if ([operation.responseObject[@"message"] isEqualToString:@"tokenError"]) {
                  [YTHttpTool tokenError];
              } else {
                  [SVProgressHUD showErrorWithStatus:operation.responseObject[@"message"]];
              }
          } else if(error.userInfo[@"NSLocalizedDescription"] != nil)
          {
              [SVProgressHUD showInfoWithStatus:@"请检查您的网络连接"];
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
        YTLog(@"%@", annex);
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
    } else if(self.bankField.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入银行卡号"];
        return YES;
    } else if(self.branchField.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入分行支行"];
        return YES;
    }
//    NSLog(@"%zd", self.photo.assetsArray.count);
     if(self.photo.selectedPhoto.count == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请上传打款凭条"];
        return YES;
    }
    if ([self.typeField.text isEqualToString:@"其他"]) {
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
    NSString *selectedType = self.types[row];
    

    // 判断是否是其他类型
    if ([selectedType isEqualToString:@"其它"]) {
        self.CertificatesNumberConstr.constant = 78;
        if (self.certificatesView == nil) {
            [self createCertificatesName];
            self.photo.view.y = self.titleLable.y - 20 + 54;
            self.informationPhoto.view.y = self.informationLable.y - 20 + 54;
            // 更新键盘位置
            [self updateKeyboardPosition];
        }
    } else {
        self.CertificatesNumberConstr.constant = 25;
        if (self.certificatesView != nil) {
            [self.certificatesView removeFromSuperview];
            self.certificatesView = nil;
            self.photo.view.y = self.titleLable.y - 20 - 54;
            self.informationPhoto.view.y = self.informationLable.y - 20 - 54;
            self.scroll.contentSize = CGSizeMake(DeviceWidth, 667);
        }
    }
    
    self.typeField.text = selectedType;
    
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

// 设置键盘位置
- (void)updateKeyboardPosition
{
    [CoreTFManagerVC uninstallManagerForVC:self];
    [CoreTFManagerVC installManagerForVC:self scrollView:self.scroll tfModels:^NSArray *{

        TFModel *tfm6 = [TFModel modelWithTextFiled:self.catesViewTypeName inputView:nil name:@"" insetBottom:65];
        TFModel *tfm2=[TFModel modelWithTextFiled:self.numberField inputView:nil name:@"" insetBottom:65];
        TFModel *tfm3=[TFModel modelWithTextFiled:self.bankField inputView:nil name:@"" insetBottom:65];
        TFModel *tfm4=[TFModel modelWithTextFiled:self.bankHangField inputView:nil name:@"" insetBottom:65];
        TFModel *tfm5=[TFModel modelWithTextFiled:self.branchField inputView:nil name:@"" insetBottom:65];
        
        return @[tfm6,tfm2,tfm3,tfm4,tfm5];
        
    }];
    self.scroll.contentSize = CGSizeMake(DeviceWidth, 720);
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
        _types = [NSArray arrayWithObjects:@"身份证",@"护照",@"其它", nil];
    }
    return _types;
}

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



@end
