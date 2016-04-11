//
//
//
//
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "SubLBXScanViewController.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "UINavigationBar+BackgroundColor.h"
#import "NSString+Password.h"
#import "SVProgressHUD.h"
#import "NSString+JsonCategory.h"
#import "NSDate+Extension.h"
#import "NSString+Extend.h"
#import "YTHttpTool.h"
#import "YTUserInfoTool.h"
#import "YTAccountTool.h"
#import "HHAlertView.h"

@interface SubLBXScanViewController ()

@end

@implementation SubLBXScanViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        //创建参数对象
        LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
        
        //矩形区域中心上移，默认中心点为屏幕中心点
        style.centerUpOffset = 44;
        
        //扫码框周围4个角的类型,设置为外挂式
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
        
        //扫码框周围4个角绘制的线条宽度
        style.photoframeLineW = 6;
        
        // 边线颜色
        style.colorRetangleLine = [UIColor whiteColor];
        
        //扫码框周围4个角的宽度
        style.photoframeAngleW = 24;
        
        //扫码框周围4个角的高度
        style.photoframeAngleH = 24;
        
        style.photoframeLineW = 2;
        
        style.colorAngle = [UIColor whiteColor];
        
        //扫码框内 动画类型 --线条上下移动
        style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
        
        //线条上下移动图片
        style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
        self.style = style;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor blackColor];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if (_isQQSimulator) {
        
         [self drawBottomItems];
        [self drawTitle];
         [self.view bringSubviewToFront:_topTitle];
    }
    else
        _topTitle.hidden = YES;
    
    // 初始化titleView
    [self setupTitleView];
   
}


- (void)setupTitleView
{
    //
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 64)];
    view.backgroundColor = YTRGBA(0, 0, 0, 0.7);
    [self.view addSubview:view];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, DeviceWidth, 44)];
    title.text = @"扫描推荐人二维码";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:20];
    [view addSubview:title];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 20, 44, 44);
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:backBtn];
}

- (void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//绘制扫描区域
- (void)drawTitle
{
    if (!_topTitle)
    {
        
        self.topTitle = [[UILabel alloc] init];

        _topTitle.width = DeviceWidth;
        
        _topTitle.x = 0;
        _topTitle.y = DeviceHight * 0.5 - (DeviceWidth - 60) * 0.5 - 50;
        _topTitle.height = 14;
        
        
        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.text = @"将取景器对准二维码即可自动扫描";
        _topTitle.textColor = [UIColor whiteColor];
        _topTitle.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:_topTitle];
    }
    
    
}

- (void)drawBottomItems
{
    if (_bottomItemsView) {
        
        return;
    }
    
    self.bottomItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceHight-100,
                                                                      CGRectGetWidth(self.view.frame), 100)];
    
    _bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    [self.view addSubview:_bottomItemsView];
    
    CGSize size = CGSizeMake(65, 87);
    self.btnFlash = [[UIButton alloc]init];
    _btnFlash.bounds = CGRectMake(0, 0, size.width, size.height);
    _btnFlash.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame) * 0.5 - 70 , CGRectGetHeight(_bottomItemsView.frame)/2);
     [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    [_btnFlash addTarget:self action:@selector(openOrCloseFlash) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnPhoto = [[UIButton alloc]init];
    _btnPhoto.bounds = _btnFlash.bounds;
    _btnPhoto.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame) * 0.5 + 70, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_nor"] forState:UIControlStateNormal];
    [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_down"] forState:UIControlStateHighlighted];
    [_btnPhoto addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomItemsView addSubview:_btnFlash];
    [_bottomItemsView addSubview:_btnPhoto];
    
}

- (void)showError:(NSString*)str
{
    [SVProgressHUD showErrorWithStatus:str];
}



- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    
    if (array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
     
        return;
    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //震动提醒
    [LBXScanWrapper systemVibrate];
    //声音提醒
    [LBXScanWrapper systemSound];
    
    
    //[self popAlertMsgWithScanResult:strResult];
    
    [self showNextVCWithScanResult:scanResult];
   
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        
        strResult = @"识别失败";
    }
    [SVProgressHUD showErrorWithStatus:@"不是有效的推荐人二维码"];
    [self reStartDevice];
//    __weak __typeof(self) weakSelf = self;
//    [LBXAlertAction showAlertWithTitle:@"扫码内容" msg:strResult chooseBlock:^(NSInteger buttonIdx) {
//
//        //点击完，继续扫码
//    } buttonsStatement:@"知道了",nil];
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    NSString *scan = strResult.strScanned;
    // 截取加密文本
    [SVProgressHUD showWithStatus:@"正在识别二维码" maskType:SVProgressHUDMaskTypeClear];
    if ([scan hasPrefix:@"http://www.simuyun.com/"]) {
        
        NSRange range = [scan rangeOfString:@"?"];
        NSString *coder = [scan substringFromIndex:range.location + range.length];
        scan = [NSString decrypt:coder];
        
        // 判断日期
        NSDictionary *dict = [scan JsonToValue];
        NSDate *deadline = [dict[@"deadline"] stringWithDate:@"yyyy-MM-dd"];
        NSDate *today = [NSDate date];
        NSComparisonResult result = [deadline compare:today];
        if (result <= 0) {
            [SVProgressHUD showErrorWithStatus:@"二维码已失效"];
            [self reStartDevice];
        } else {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"advisersId"] = [YTAccountTool account].userId;
            param[@"orgId"] = dict[@"party_id"];
            param[@"fatherId"] = dict[@"uid"];
            param[@"authenticationType"] = @"1";
            [YTHttpTool post:YTAuthAdviser params:param success:^(id responseObject) {
                [SVProgressHUD dismiss];
                // 改变用户信息状态
                [self updateUserInfo];
                HHAlertView *alert = [HHAlertView shared];
                [alert showAlertWidtTitle:@"认证成功" detail:[NSString stringWithFormat:@"您已成功认证到%@，推荐人%@", dict[@"party_name"],dict[@"nickName"]] Okbutton:@"知道了" block:^(HHAlertButton buttonindex) {
                    // 关闭控制器
                    [self dismissViewControllerAnimated:YES completion:^{
                        // 调用代理方法
                        if ([self.delegate respondsToSelector:@selector(closePage)]) {
                            [self.delegate closePage];
                        }
                    }];
                }];
                
            } failure:^(NSError *error) {
                [self reStartDevice];
            }];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:@"不是有效的推荐人二维码"];
        [self reStartDevice];
    }
}

// 修改用户信息
- (void)updateUserInfo
{
    [YTCenter postNotificationName:YTUpdateUserInfo object:nil];
    YTUserInfo *userInfo =[YTUserInfoTool userInfo];
    userInfo.adviserStatus = 0;
    [YTUserInfoTool saveUserInfo:userInfo];
}


#pragma mark -底部功能项
//打开相册
- (void)openPhoto
{
    if ([LBXScanWrapper isGetPhotoPermission])
        [self openLocalPhoto];
    else
    {
        [self showError:@"      请到设置->隐私中开启本程序相册权限     "];
    }
}

//开关闪光灯
- (void)openOrCloseFlash
{
    
    [super openOrCloseFlash];
   
    
    if (self.isOpenFlash)
    {
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    }
    else
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
}





@end
