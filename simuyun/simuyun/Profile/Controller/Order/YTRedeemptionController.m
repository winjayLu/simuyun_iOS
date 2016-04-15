//
//  YTRedeemptionController.m
//  simuyun
//
//  Created by Luwinjay on 16/4/12.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTRedeemptionController.h"
#import "TZTestCell.h"
#import "JKImagePickerController.h"
#import "YTRedeemModel.h"
#import "SVProgressHUD.h"
#import "NSString+Extend.h"
#import "YTSlipModel.h"
#import "YTAccountTool.h"
#import "YTViewPdfViewController.h"
#import "UIImage+Extend.h"
#import "YTSenMailView.h"

// 赎回申请

@interface YTRedeemptionController () <UICollectionViewDelegate, UICollectionViewDataSource, JKImagePickerControllerDelegate, UIScrollViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, senMailViewDelegate>

/**
 *  滚动视图
 */
@property (nonatomic, weak) UIScrollView *mainView;

/**
 *  倒计时视图
 */
@property (nonatomic, weak) UIView *endTimeView;

/**
 *  截止赎回时间Lable
 */
@property (nonatomic, weak) UILabel *endTimeLable;

#pragma 账户信息视图

/**
 *  初始化账户信息视图
 */
@property (nonatomic, weak) UIView *AccountView;

/**
 *  客户姓名Lable
 */
@property (nonatomic, weak) UILabel *custNameLable;

/**
 *  赎回帐号Lable
 */
@property (nonatomic, weak) UILabel *redeemBankAccountLable;

/**
 *  帐号开户行Lable
 */
@property (nonatomic, weak) UILabel *bankNameLable;

#pragma 账户信息视图

/**
 *  账户信息视图
 */
@property (nonatomic, weak) UIView *RedeemView;

/**
 *  赎回金额Lable
 */
@property (nonatomic, weak) UILabel *redeemAmtLable;

/**
 *  赎回份额
 */
@property (nonatomic, weak) UITextField *fenNum;

/**
 *  图片选择View
 */
@property (nonatomic, weak) UICollectionView *photoView;


#pragma 底部视图

/**
 *  初始化底部视图
 */
@property (nonatomic, weak) UIView *bottomView;

/**
 *  文件视图
 */
@property (nonatomic, weak) UIView *fileView;

/**
 *  赎回说明View
 */
@property (nonatomic, weak) UIView *descriptionView;

/**
 *  获取电子邮件
 */
@property (nonatomic, weak) UIButton *getEmail;

/**
 *  赎回按钮
 */
@property (nonatomic, weak) UIButton *redeemBtn;

#pragma mark Data

/**
 *  选择的照片相册路径
 */
@property (nonatomic, strong) NSMutableArray *assetsArray;

/**
 *  选中的照片
 */
@property (nonatomic, strong) NSMutableArray *selectedPhoto;

/**
 *  赎回数据
 */
@property (nonatomic, strong) YTRedeemModel *redeem;

// 发送邮件视图
@property (nonatomic, weak) YTSenMailView *sendMailView;

@end

@implementation YTRedeemptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"赎回申请";
    
    // 初始化滚动视图
    [self setupScrollView];
    
    // 初始化倒计时视图
    [self setupEndTimeView];
    
    // 初始化账户信息视图
    [self setupAccountView];
    
    // 初始化赎回信息视图
    [self setupRedeemView];
    
    // 初始化图片选择视图
    [self setupPhotoView];
    
    // 初始化底部视图
    [self setupBottomView];
    
    // 获取赎回数据
    [self loadRedeem];
}

#pragma mark Load

/**
 *  获取赎回数据
 */
- (void)loadRedeem
{
    [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeClear];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"order_id"] = self.orderId;
    param[@"advisers_id"] = [YTAccountTool account].userId;
    [YTHttpTool get:YTRedeemDetail params:param success:^(id responseObject) {
        self.redeem = [YTRedeemModel objectWithKeyValues:responseObject];
        [self setData];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
    }];
}

/**
 *   上传照片
 *
 */
- (void)uploadPhoto
{
    [SVProgressHUD showWithStatus:@"正在提交" maskType:SVProgressHUDMaskTypeClear];
    NSMutableArray *files = [NSMutableArray array];
    for (UIImage *image in self.selectedPhoto) {
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
        NSArray *photos = [YTSlipModel objectArrayWithKeyValuesArray:responseObject];
        // 生成照片附件参数
        [self redeemWithPhotos:photos];
    } failure:^(NSError *error) {
    }];
}

/**
 *  提交赎回
 *
 */
- (void)redeemWithPhotos:(NSArray *)photos
{
    // 拼接附件参数
    NSMutableString *annex = [NSMutableString string];
    // 打款凭条
    for (int i = 0; i < photos.count; i++) {
        YTSlipModel *slip = photos[i];
        if (i == 0) {
            [annex appendString:@"[{"];
#warning 赎回用3
            [annex appendString:@"\"annex_type\":\"3\""];
            [annex appendString:[NSString stringWithFormat:@",\"annex_path\":\"%@\"",slip.url]];
            [annex appendString:[NSString stringWithFormat:@",\"file_type\":\"%@\"",slip.type]];
            [annex appendString:[NSString stringWithFormat:@",\"file_name\":\"%@\"}",slip.original]];
        } else {
            [annex appendString:@",{\"annex_type\":\"3\""];
            [annex appendString:[NSString stringWithFormat:@",\"annex_path\":\"%@\"",slip.url]];
            [annex appendString:[NSString stringWithFormat:@",\"file_type\":\"%@\"",slip.type]];
            [annex appendString:[NSString stringWithFormat:@",\"file_name\":\"%@\"}",slip.original]];
        }
    }
    [annex appendString:@"]"];
    
    // 发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.redeem.productType == 2) {
        params[@"redemptionShare"] = @(self.redeem.redeemAmt);
    } else {
        params[@"redemptionShare"] = @([self.fenNum.text doubleValue]);
    }
    params[@"redemptionMaterial"] = annex;
    params[@"applyAdviserId"] = [YTAccountTool account].userId;
    params[@"orderId"] = self.redeem.orderId;
    [YTHttpTool post:YTRedeemption params:params success:^(id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate redeemSuccess];
    } failure:^(NSError *error) {
    }];
}


#pragma mark Control



/**
 *  获取详细资料
 */
- (void)getEmailClick
{
    if (self.sendMailView != nil) return;
    
    YTSenMailView *sendMail = [[YTSenMailView alloc] initWithViewController:self];
    sendMail.frame = self.view.bounds;
    
    //  设置代理
    sendMail.sendDelegate = self;
    [self.view addSubview:sendMail];
    self.sendMailView = sendMail;
}
#warning 缺少接口
/**
 *  发送请求
 *
 */
- (void)sendMail:(NSString *)mail
{
//    // 发送请求
//    [SVProgressHUD showWithStatus:@"正在发送" maskType:SVProgressHUDMaskTypeClear];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"email"] = mail;
//    params[@"proId"] = self.product.pro_id;
//    [YTHttpTool get:YTEmailsharing params:params success:^(id responseObject) {
//        YTLog(@"%@", responseObject);
//        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
//        // 保存发送成功的Email
//        [CoreArchive setStr:mail key:@"mail"];
//        [self.sendMailView sendSuccess:YES];
//        self.sendMailView = nil;
//    } failure:^(NSError *error) {
//    }];
}
/**
 *  提交赎回
 */
- (void)redeemBtnClick
{
    // 本地校验
    if (self.redeem.productType == 1) {
        if (self.fenNum.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入赎回份额"];
            return;
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提交赎回" message:@"确认已经获得客户赎回授权，并正确填写赎回材料?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 删除订单
    if (buttonIndex == 1) {
        // 上传图片
        [self uploadPhoto];
    }
}

/**
 *  拨打客服电话
 */
- (void)phoneClick
{
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:@"tel://400-188-8848"];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}

/**
 *  打开Pdf页面
 *
 */
- (void)pdfClick:(UIButton *)btn
{
    YTViewPdfViewController *viewPdf = [[YTViewPdfViewController alloc] init];
    viewPdf.url = self.redeem.files[btn.tag][@"fileUrl"];
    viewPdf.shareTitle = self.redeem.files[btn.tag][@"fileName"];;
    [self.navigationController pushViewController:viewPdf animated:YES];
}


#pragma mark - 初始化方法
/**
 *  初始化滚动视图
 */
- (void)setupScrollView
{
    // 将控制器的View替换为ScrollView
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, self.view.height - 64)];
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.showsVerticalScrollIndicator = NO;
    mainView.delegate = self;
    [self.view addSubview:mainView];
    self.mainView = mainView;
}

/**
 *  初始化倒计时视图
 */
- (void)setupEndTimeView
{
    // 容器
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = YTColor(246, 246, 246);
    container.frame = CGRectMake(0, 0, DeviceWidth, 40);
    [self.mainView addSubview:container];
    self.endTimeView = container;
    
    // 分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = YTColor(208, 208, 208);
    line.frame = CGRectMake(0, container.height - 1, DeviceWidth, 1);
    [container addSubview:line];
    
    // 文本
    UILabel *text = [[UILabel alloc] init];
    text.frame = container.bounds;
    text.font = [UIFont systemFontOfSize:12];
    text.textColor = YTColor(51, 51, 51);
    text.text = @"本次申请赎回截止时间还剩";
    text.textAlignment = NSTextAlignmentCenter;
    [container addSubview:text];
    self.endTimeLable = text;
}

/**
 *  初始化账户信息视图
 */
- (void)setupAccountView
{
    // 容器
    UIView *container = [[UIView alloc] init];
    container.frame = CGRectMake(0, CGRectGetMaxY(self.endTimeView.frame), DeviceWidth, 118);
    [self.mainView addSubview:container];
    self.AccountView = container;
    
    // lable左边距
    CGFloat maginX = 35;
    
    // 标题
    UILabel *title = [[UILabel alloc] init];
    title.text = @"账户信息";
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = YTColor(51, 51, 51);
    [title sizeToFit];
    title.frame = CGRectMake(maginX, 15, title.width, title.height);
    [container addSubview:title];

    // 小红点
    UIImageView *redView = [[UIImageView alloc] init];
    redView.image = [UIImage imageNamed:@"redeemDian"];
    redView.size = redView.image.size;
    redView.center = title.center;
    redView.x = title.x - 10 - redView.image.size.width;
    [container addSubview:redView];
    
    // 客户姓名
    UILabel *custNameLable = [self createDarkGrayLable];
    custNameLable.text = @"客户姓名：";
    [custNameLable sizeToFit];
    custNameLable.x = 35;
    custNameLable.y = CGRectGetMaxY(title.frame) + 10;
    [container addSubview:custNameLable];
    self.custNameLable = custNameLable;
    
    // 赎回帐号
    UILabel *redeemBankAccountLable = [self createDarkGrayLable];
    redeemBankAccountLable.text = @"赎回帐号：";
    [redeemBankAccountLable sizeToFit];
    redeemBankAccountLable.x = 35;
    redeemBankAccountLable.y = CGRectGetMaxY(custNameLable.frame) + 10;
    [container addSubview:redeemBankAccountLable];
    self.redeemBankAccountLable = redeemBankAccountLable;
    
    // 所属银行
    UILabel *bankNameLable = [self createDarkGrayLable];
    bankNameLable.text = @"所属银行：";
    [bankNameLable sizeToFit];
    bankNameLable.x = 35;
    bankNameLable.y = CGRectGetMaxY(redeemBankAccountLable.frame) + 10;
    [container addSubview:bankNameLable];
    self.bankNameLable = bankNameLable;
    
    // 客服电话
    CGFloat rightMagin = 20;
    UIButton *phoneBtn = [[UIButton alloc] init];
    [phoneBtn setImage:[UIImage imageNamed:@"redeemPhone"] forState:UIControlStateNormal];
    phoneBtn.size = phoneBtn.currentImage.size;
    phoneBtn.frame = CGRectMake(container.width - rightMagin - phoneBtn.width, 20, phoneBtn.width, phoneBtn.height);
    [phoneBtn addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:phoneBtn];
    
    // 修改容器高度
    container.height = CGRectGetMaxY(bankNameLable.frame) + 15;
    
    // 分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = YTColor(208, 208, 208);
    line.frame = CGRectMake(0, container.height - 1, DeviceWidth, 1);
    [container addSubview:line];
}

/**
 *  初始化赎回信息视图
 */
- (void)setupRedeemView
{
    // 容器
    UIView *container = [[UIView alloc] init];
    container.frame = CGRectMake(0, CGRectGetMaxY(self.AccountView.frame), DeviceWidth, 118);
    [self.mainView addSubview:container];
    self.RedeemView = container;
    // lable左边距
    CGFloat maginX = 35;
    
    // 标题
    UILabel *title = [[UILabel alloc] init];
    title.text = @"赎回信息";
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = YTColor(51, 51, 51);
    [title sizeToFit];
    title.frame = CGRectMake(maginX, 15, title.width, title.height);
    [container addSubview:title];
    
    // 小红点
    UIImageView *redView = [[UIImageView alloc] init];
    redView.image = [UIImage imageNamed:@"redeemDian"];
    redView.size = redView.image.size;
    redView.center = title.center;
    redView.x = title.x - 10 - redView.image.size.width;
    [container addSubview:redView];
    
    // 赎回金额
    UILabel *redeemAmtLable = [self createDarkGrayLable];
    redeemAmtLable.text = @"赎回金额：";
    [redeemAmtLable sizeToFit];
    redeemAmtLable.x = 35;
    redeemAmtLable.y = CGRectGetMaxY(title.frame) + 10;
    [container addSubview:redeemAmtLable];
    self.redeemAmtLable = redeemAmtLable;
    
    // 赎回材料
    UILabel *redeemDescription = [self createDarkGrayLable];
    redeemDescription.text = @"赎回材料：";
    [redeemDescription sizeToFit];
    redeemDescription.x = 35;
    redeemDescription.y = CGRectGetMaxY(redeemAmtLable.frame) + 10;
    [container addSubview:redeemDescription];
    
    // 修改容器高度
    container.height = CGRectGetMaxY(redeemDescription.frame) + 10;
}

/**
 *  初始图片选择视图
 */
- (void)setupPhotoView
{
    CGFloat margin = 20;
    CGFloat padding = 10;
    CGFloat itemWh = (self.view.width - 2 * (margin + padding)) / 3;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemWh, itemWh);
    layout.minimumInteritemSpacing = padding;
    layout.minimumLineSpacing = padding;
    UICollectionView *photoView = [[UICollectionView alloc] initWithFrame:CGRectMake(margin, CGRectGetMaxY(self.RedeemView.frame), self.view.width - margin * 2, itemWh + padding) collectionViewLayout:layout];
    photoView.backgroundColor = [UIColor whiteColor];
//    photoView.contentInset = UIEdgeInsetsMake(4, 0, 0, 2);
//    photoView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    photoView.dataSource = self;
    photoView.delegate = self;
    [self.mainView addSubview:photoView];
    self.photoView = photoView;
    [photoView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}


/**
 *  初始化底部视图
 */
- (void)setupBottomView
{
    // 容器
    UIView *container = [[UIView alloc] init];
    container.frame = CGRectMake(0, CGRectGetMaxY(self.photoView.frame) + 10, DeviceWidth, 118);
    [self.mainView addSubview:container];
    self.bottomView = container;
    
    // 文件资源View
    UIView *fileView = [[UIView alloc] init];
    fileView.frame = CGRectMake(35, 0, DeviceWidth - 55, 40);
    [container addSubview:fileView];
    self.fileView = fileView;
    
    // 赎回说明View
    UIView *descriptionView = [[UIView alloc] init];
    descriptionView.frame = CGRectMake(20, fileView.height, DeviceWidth - 40, 40);
    [container addSubview:descriptionView];
    self.descriptionView = descriptionView;
    
    // 邮件获取赎回材料按钮
    UIButton *getEmail = [[UIButton alloc] init];
    [getEmail setBackgroundImage:[UIImage imageWithColor:YTColor(91, 168, 243)] forState:UIControlStateNormal];
    [getEmail setBackgroundImage:[UIImage imageWithColor:YTColor(65, 133, 197)] forState:UIControlStateHighlighted];
    [getEmail setTitle:@"邮件获取赎回材料" forState:UIControlStateNormal];
    [getEmail.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [getEmail setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getEmail.layer.cornerRadius = 5;
    getEmail.layer.masksToBounds = YES;
    getEmail.frame = CGRectMake(10, CGRectGetMaxY(descriptionView.frame) + 20, self.view.width - 20, 44);
    [getEmail addTarget:self action:@selector(getEmailClick) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:getEmail];
    self.getEmail = getEmail;
    
    // 提交赎回按钮
    UIButton *redeemBtn = [[UIButton alloc] init];
    [redeemBtn setBackgroundImage:[UIImage imageWithColor:YTNavBackground] forState:UIControlStateNormal];
    [redeemBtn setBackgroundImage:[UIImage imageWithColor:YTColor(210, 36, 20)] forState:UIControlStateHighlighted];
    [redeemBtn setBackgroundImage:[UIImage imageWithColor:YTColor(208, 208, 208)] forState:UIControlStateDisabled];
    [redeemBtn setTitle:@"提交赎回" forState:UIControlStateNormal];
    [redeemBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [redeemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    redeemBtn.layer.cornerRadius = 5;
    redeemBtn.layer.masksToBounds = YES;
    redeemBtn.frame = CGRectMake(10, CGRectGetMaxY(getEmail.frame) + 10, self.view.width - 20, 44);
    [redeemBtn addTarget:self action:@selector(redeemBtnClick) forControlEvents:UIControlEventTouchUpInside];
    redeemBtn.enabled = NO;
    [container addSubview:redeemBtn];
    self.redeemBtn = redeemBtn;
    
    // 修改容器高度
    container.height = CGRectGetMaxY(redeemBtn.frame) + 20;
    
    // 修改滚动范围
    self.mainView.contentSize = CGSizeMake(DeviceWidth, CGRectGetMaxY(container.frame));
}

#pragma mark - 设置数据
/**
 *  设置数据
 */
- (void)setData
{
    
    // 手动调用倒计时
    [self timerFireMethod:nil];
    
    // 开始倒计时
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    
    // 客户姓名
    self.custNameLable.text = [NSString stringWithFormat:@"客户姓名：%@",self.redeem.custName];
    [self.custNameLable sizeToFit];
    
    // 赎回帐号
    self.redeemBankAccountLable.text = [NSString stringWithFormat:@"赎回帐号：%@",self.redeem.redeemBankAccount];
    [self.redeemBankAccountLable sizeToFit];
    
    // 开户行
    self.bankNameLable.text = [NSString stringWithFormat:@"所属银行：%@",self.redeem.bankName];
    [self.bankNameLable sizeToFit];
    
    // 赎回金额/份额
    if (self.redeem.productType == 2) {
        // 固收
        self.redeemAmtLable.text = [NSString stringWithFormat:@"赎回金额：%d万（全额赎回）", self.redeem.redeemAmt];
        [self.redeemAmtLable sizeToFit];
    } else {
        // 浮收
        self.redeemAmtLable.text = @"赎回份额：";
        [self.redeemAmtLable sizeToFit];
        
        // 输入框
        UITextField *fenNum = [[UITextField alloc] init];
        fenNum.font = [UIFont systemFontOfSize:14];
        fenNum.textColor = YTColor(102, 102, 102);
        fenNum.layer.borderWidth = 1;
        fenNum.layer.borderColor = YTColor(208, 208, 208).CGColor;
        fenNum.frame = CGRectMake(CGRectGetMaxX(self.redeemAmtLable.frame), self.redeemAmtLable.y, 85, self.redeemAmtLable.height);
        fenNum.keyboardType = UIKeyboardTypeDecimalPad;
        fenNum.delegate = self;
        fenNum.textAlignment = NSTextAlignmentCenter;
        [self.RedeemView addSubview:fenNum];
        self.fenNum = fenNum;
        
        // 右侧文字
        UILabel *textLable = [self createDarkGrayLable];
        textLable.text = @"份";
        [textLable sizeToFit];
        textLable.frame = CGRectMake(CGRectGetMaxX(fenNum.frame) + 5, fenNum.y, textLable.width, textLable.height);
        [self.RedeemView addSubview:textLable];
    }
    
    
    // 相关文件视图
    if (self.redeem.files.count > 0) {
        UILabel *redeemDescription = [self createDarkGrayLable];
        redeemDescription.text = @"相关文件：";
        [redeemDescription sizeToFit];
        redeemDescription.frame = CGRectMake(0, 0, redeemDescription.width, redeemDescription.height);
        [self.fileView addSubview:redeemDescription];
        
        // 文件列表
        for (int i = 0; i < self.redeem.files.count; i++) {
            UIButton *button = [[UIButton alloc] init];
            [button setImage:[UIImage imageNamed:@"redeemPDF"] forState:UIControlStateNormal];
            [button setTitle:self.redeem.files[i][@"fileName"] forState:UIControlStateNormal];
            button.tag = i;
            [button addTarget:self action:@selector(pdfClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(CGRectGetMaxX(redeemDescription.frame), redeemDescription.height * i, self.fileView.width - redeemDescription.width, redeemDescription.height);
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [button setTitleColor:YTColor(102, 102, 102) forState:UIControlStateNormal];
            [button setContentMode:UIViewContentModeScaleAspectFill];
            [button.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [self.fileView addSubview:button];
            if (i > 0) {
                button.y = (redeemDescription.height + 10) * i;
            }
        }
        self.fileView.height = self.redeem.files.count * (redeemDescription.height + 10);
        self.descriptionView.y = CGRectGetMaxY(self.fileView.frame);
    } else {
        self.fileView.height = 0;
        self.descriptionView.y = 0;
    }
    
    // 赎回说明
    if (self.redeem.redeemDescription.length == 0) {
        self.descriptionView.height = 0;
    } else {
        UILabel *textLable = [[UILabel alloc] init];
        textLable.text = self.redeem.redeemDescription;
        textLable.font = [UIFont systemFontOfSize:12];
        textLable.numberOfLines = 0;
        textLable.textColor = YTColor(102, 102, 102);
        textLable.width = self.descriptionView.width - 20;
        [textLable sizeToFit];
        textLable.frame = CGRectMake(10, 10, textLable.width, textLable.height);
        [self.descriptionView addSubview:textLable];
        self.descriptionView.height = textLable.height + 20;
        
        // 设置边框虚线
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.bounds = CGRectMake(0, 0, self.descriptionView.width, self.descriptionView.height);
        borderLayer.position = CGPointMake(CGRectGetMidX(self.descriptionView.bounds), CGRectGetMidY(self.descriptionView.bounds));
        
        //    borderLayer.path = [UIBezierPath bezierPathWithRect:borderLayer.bounds].CGPath;
        borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:0].CGPath;
        borderLayer.lineWidth = 1. / [[UIScreen mainScreen] scale];
        //虚线边框
        borderLayer.lineDashPattern = @[@3, @6];
        //实线边框
        //    borderLayer.lineDashPattern = nil;
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.strokeColor = YTColor(208, 208, 208).CGColor;
        [self.descriptionView.layer addSublayer:borderLayer];
    }
    
    // 更新位置
    self.getEmail.y = CGRectGetMaxY(self.descriptionView.frame) + 20;
    self.redeemBtn.y = CGRectGetMaxY(self.getEmail.frame) + 10;
    // 修改容器高度
    self.bottomView.height = CGRectGetMaxY(self.redeemBtn.frame) + 20;
    
    // 修改滚动范围
    self.mainView.contentSize = CGSizeMake(DeviceWidth, CGRectGetMaxY(self.bottomView.frame));
}


#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetsArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    if (indexPath.row == self.assetsArray.count) {
        cell.imageView.image = [UIImage imageNamed:@"redeemAddPhoto"];
        cell.delete.hidden = YES;
    } else {
        JKAssets *asset = [self.assetsArray objectAtIndex:[indexPath row]];
        ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:asset.assetPropertyURL resultBlock:^(ALAsset *newAsset) {
            if (asset) {
                UIImage *image = [UIImage imageWithCGImage:[[newAsset defaultRepresentation] fullScreenImage]];
                cell.imageView.image = image;
                cell.delete.hidden = NO;
                [self.selectedPhoto addObject:image];
            }
        } failureBlock:^(NSError *error) {
            
        }];
        
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.assetsArray.count)
    {
        [self composePicAdd];
    } else {
        [self.assetsArray removeObjectAtIndex:indexPath.row];
        [self.photoView deleteItemsAtIndexPaths:@[indexPath]];
        [self upadtaFrame];
        self.redeemBtn.enabled = self.assetsArray.count;
    }
    
}

- (void)composePicAdd
{
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 20;
    imagePickerController.selectedAssetArray = self.assetsArray;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
//        [self changePlayerStatus:NO];
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    self.assetsArray = [NSMutableArray arrayWithArray:assets];
    self.redeemBtn.enabled = self.assetsArray.count;
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        [self.selectedPhoto  removeAllObjects];
        [self.photoView reloadData];
        [self upadtaFrame];
    }];
}

/**
 *  更新底部视图Frame
 */
- (void)upadtaFrame
{
    NSInteger count = self.assetsArray.count + 1;
    NSInteger line = count / 3;
    if (count % 3 != 0) {
        line += 1;
    }
    CGFloat margin = 20;
    CGFloat padding = 10;
    CGFloat itemWh = (self.view.width - 2 * (margin + padding)) / 3;
    self.photoView.height = line * (itemWh + padding);
    self.bottomView.y = CGRectGetMaxY(self.photoView.frame) + 10;
    self.mainView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.bottomView.frame));
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UITextViewDelegate
/**
 *  当用户开始拖拽scrollView时调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


#pragma mark - TextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL isHaveDian = YES;
    if ([textField.text rangeOfString:@"."].location==NSNotFound) {
        isHaveDian=NO;
    }
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length]==0){
                if(single == '.'){
//                    [self alertView:@"亲，第一个数字不能为小数点"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                    
                }
                if (single == '0') {
//                    [self alertView:@"亲，第一个数字不能为0"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                    
                }
            }
            if (single=='.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian=YES;
                    return YES;
                }else
                {
                    [SVProgressHUD showErrorWithStatus:@"已经输入过小数点了"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (isHaveDian)//存在小数点
                {
                    //判断小数点的位数
                    NSRange ran=[textField.text rangeOfString:@"."];
                    NSInteger tt=range.location-ran.location;
                    if (tt <= 4){
                        return YES;
                    }else{
                        [SVProgressHUD showErrorWithStatus:@"最多输入四位小数"];
                        return NO;
                    }
                }
                else
                {
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
//            [self alertView:@"亲，您输入的格式不正确"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }  
    
}

#pragma mark - 倒计时

- (void)timerFireMethod:(NSTimer *)theTimer
{
    NSDate *today = [NSDate date];    //得到当前时间
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *overTime = [dateFormatter dateFromString:self.redeem.redeemEndTime];
    
    NSUInteger unitFlags = NSCalendarUnitDay| NSCalendarUnitHour| NSCalendarUnitMinute| NSCalendarUnitSecond;
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDateComponents *d = [cal components:unitFlags fromDate:today toDate:overTime options:0];
    NSString *fen = [NSString stringWithFormat:@"%zd", [d minute]];
    if([d minute] < 10) {
        fen = [NSString stringWithFormat:@"0%zd",[d minute]];
    }
    NSString *miao = [NSString stringWithFormat:@"%zd", [d second]];
    if([d second] < 10) {
        miao = [NSString stringWithFormat:@"0%zd",[d second]];
    }
    if([d day] == 0 && [d hour] == 0 && [d minute] == 0 && [d second] == 0) {
        //计时结束 do_something
        [theTimer invalidate];
    }
    
    NSString *title = @"本次申请赎回截止时间还剩：";
    NSString *endTimeText = [NSString stringWithFormat:@"%zd天 %zd小时%@分%@秒", [d day], [d hour], fen, miao];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", title, endTimeText]];
    [attrStr addAttribute:NSForegroundColorAttributeName value:YTColor(51, 51, 51) range:NSMakeRange(0,title.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:YTNavBackground range:NSMakeRange(title.length,attrStr.length - title.length)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attrStr.length)];
    [self.endTimeLable setAttributedText:attrStr];
    
}


/**
 *  创建灰色lable
 */
- (UILabel *)createDarkGrayLable
{
    UILabel *lable = [[UILabel alloc] init];
    lable.font = [UIFont systemFontOfSize:14];
    lable.textColor = YTColor(102, 102, 102);
    return lable;
}

#pragma mark - lazy
- (NSMutableArray *)assetsArray
{
    if (!_assetsArray) {
        _assetsArray = [[NSMutableArray alloc] init];
    }
    return _assetsArray;
}

- (NSMutableArray *)selectedPhoto
{
    if (!_selectedPhoto) {
        _selectedPhoto = [[NSMutableArray alloc] init];
    }
    return _selectedPhoto;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
