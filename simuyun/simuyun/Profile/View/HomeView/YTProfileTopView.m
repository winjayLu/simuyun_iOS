//
//  YTProfileTopView.m
//  测试头像上传
//
//  Created by Luwinjay on 15/10/4.
//  Copyright © 2015年 Luwinjay. All rights reserved.
//

#import "YTProfileTopView.h"
#import "UIWindow+YUBottomPoper.h"
#import "UIImageView+SD.h"
#import "YTUserInfoTool.h"
#import "YTHttpTool.h"
#import "YTAccountTool.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "YTTabBarController.h"
#import "CoreArchive.h"

@interface YTProfileTopView() <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/**
 *  菜单点击
 */
- (IBAction)menuClick:(UIButton *)sender;

/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

/**
 *  头像单击事件
 */
- (IBAction)iconClick:(UITapGestureRecognizer *)sender;

///**
// *  认证按钮
// */
//@property (weak, nonatomic) IBOutlet UIButton *renZhenBtn;
/**
 *  签到按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *qiaoDaoBtn;

/**
 *  签到按钮点击事件
 *
 */
- (IBAction)qiaoDaoClick:(UIButton *)sender;

/**
 *  云豆按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *yunDouBtn;

/**
 *  云豆按钮单击事件
 *
 */
- (IBAction)yunDouClick:(UIButton *)sender;
/**
 *  用户昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLable;

/**
 *  我的客户单击事件
 *
 */
- (IBAction)keHuBtn:(id)sender;

/**
 *  我的客户数量
 */
@property (weak, nonatomic) IBOutlet UILabel *keHuLable;

/**
 *  我的订单点击事件
 */
- (IBAction)orderClick:(UIButton *)sender;
/**
 *  我的订单数量
 */
@property (weak, nonatomic) IBOutlet UILabel *orderLable;

/**
 *  我的业绩单击事件
 *
 */
- (IBAction)yeJiBtn:(UIButton *)sender;

/**
 *  我的业绩数量
 */
@property (weak, nonatomic) IBOutlet UILabel *yeJiLable;

/**
 *  我的业绩单位
 */
@property (weak, nonatomic) IBOutlet UILabel *wanLable;

/**
 *  皇冠
 */
@property (weak, nonatomic) IBOutlet UIImageView *huangGuanImage;

// 是否修改了头像
@property (nonatomic, assign) BOOL isChang;

// 首页背景图片
@property (weak, nonatomic) IBOutlet UIImageView *homeImageView;

// 二维码点击
- (IBAction)myScanClick:(id)sender;

// 二维码按钮
@property (weak, nonatomic) IBOutlet UIButton *myScanBtn;

// 二维码底部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanBottomConstraint;

@end

@implementation YTProfileTopView


#pragma mark - 头像处理
/**
 *  头像单击事件
 */
- (IBAction)iconClick:(UITapGestureRecognizer *)sender
{
    NSLog(@"sss");
    [self.window  showPopWithButtonTitles:@[@"拍        摄",@"相册选取"] styles:@[YUDefaultStyle, YUDefaultStyle] whenButtonTouchUpInSideCallBack:^(int index  ) {
        switch (index) {
            case 0:
                // 拍摄
                [self takePhoto:UIImagePickerControllerSourceTypeCamera];
                break;
            case 1:
                // 相册选取
                [self takePhoto:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
                break;
            default:
                break;
        }
    }];
}


/**
 *  打开相册或相机
 */
- (void)takePhoto:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    // 设置拍照后的图片可被编辑
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    // 前置摄像头
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }

    UIWindow *keyWindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            keyWindow = window;
            break;
        }
    }
    UIViewController *appRootVC = keyWindow.rootViewController;
    if ([appRootVC isKindOfClass:[YTTabBarController class]]) {
        YTTabBarController *tabBar = ((YTTabBarController *)appRootVC);
        tabBar.floatView.boardWindow.hidden = YES;
    }
        // 调用代理方法
    [self.delegate addPicker:imagePicker];
    
}

/**
 *  拍照成功
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIWindow *keyWindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            keyWindow = window;
            break;
        }
    }
    UIViewController *appRootVC = keyWindow.rootViewController;
    if ([appRootVC isKindOfClass:[YTTabBarController class]]) {
        YTTabBarController *tabBar = ((YTTabBarController *)appRootVC);
        tabBar.floatView.boardWindow.hidden = NO;
    }
    
    // 关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];

    // 将新的图片保存到用户信息中
    YTUserInfo *userInfo = [YTUserInfoTool userInfo];
    userInfo.iconImage = image;
    [YTUserInfoTool saveUserInfo:userInfo];
    // 发送通知
    [YTCenter postNotificationName:YTUpdateIconImage object:nil];
    
    self.isChang = YES;
    // 设置图片到iconView上
    [self setIconImageWithImage:image];
    
    // 上传图片
    [self uploadImage:image];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    UIWindow *keyWindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            keyWindow = window;
            break;
        }
    }
    UIViewController *appRootVC = keyWindow.rootViewController;
    if ([appRootVC isKindOfClass:[YTTabBarController class]]) {
        YTTabBarController *tabBar = ((YTTabBarController *)appRootVC);
        tabBar.floatView.boardWindow.hidden = NO;
    }
    // 关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 设置数据
/**
 *  给iconView设置图片
 */
- (void)setIconImageWithImage:(UIImage *)image
{
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.cornerRadius = self.iconImage.frame.size.width * 0.5;
    self.iconImage.clipsToBounds = YES;
    // 判断是否是更换图片
    if(image == nil) {
        self.iconImage.image = [UIImage imageNamed:@"avatar_default_big"];
        return;
    }
    self.iconImage.image = image;
}


/**
 *  上传图片
 */
- (void)uploadImage:(UIImage *)image
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"advisersId"] = [YTAccountTool account].userId;
    YTHttpFile *file = [YTHttpFile fileWithName:@"filedata" data:UIImageJPEGRepresentation(image, 1.0) mimeType:@"image/jpg" filename:@"image.jpg"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 2.发送请求
    NSString *newUrl = [NSString stringWithFormat:@"%@%@",YTServer, YTUploadUserImage];
    [manager POST:newUrl parameters:[NSDictionary httpWithDictionary:params] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 上传文件设置
        [formData appendPartWithFileData:file.data name:file.name fileName:file.filename mimeType:file.mimeType];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        YTLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(operation.responseObject[@"message"] != nil)
        {
            if ([operation.responseObject[@"message"] isEqualToString:@"tokenError"]) {
                [YTHttpTool tokenError];
            } else {
                [SVProgressHUD showErrorWithStatus:operation.responseObject[@"message"]];
            }
        }
        
    }];
}

#pragma mark - 按钮点击
/**
 *  签到按钮点击事件
 */
- (IBAction)qiaoDaoClick:(UIButton *)sender {
    // 调用代理方法
    sender.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.scanBottomConstraint.constant = -37;
    }];
    [self sendDelegate:TopButtonTypeQiandao];
    [MobClick event:@"main_click" attributes:@{@"按钮" : @"签到", @"机构" : [YTUserInfoTool userInfo].organizationName}];
}
/**
 *  云豆按钮点击事件
 */
- (IBAction)yunDouClick:(UIButton *)sender {
    // 调用代理方法
    [self sendDelegate:TopButtonTypeYundou];
    [MobClick event:@"main_click" attributes:@{@"按钮" : @"云豆", @"机构" : [YTUserInfoTool userInfo].organizationName}];
}
/**
 *  我的客户点击事件
 */
- (IBAction)keHuBtn:(id)sender {
    // 调用代理方法
    [self sendDelegate:TopButtonTypeKehu];
    [MobClick event:@"main_click" attributes:@{@"按钮" : @"我的客户", @"机构" : [YTUserInfoTool userInfo].organizationName}];
}
/**
 *  我的订单点击事件
 */
- (IBAction)orderClick:(UIButton *)sender {
    // 调用代理方法
    [self sendDelegate:TopButtonTypeDindan];
    [MobClick event:@"main_click" attributes:@{@"按钮" : @"完成订单", @"机构" : [YTUserInfoTool userInfo].organizationName}];
}
/**
 *  我的业绩点击事件
 */
- (IBAction)yeJiBtn:(UIButton *)sender {
    // 调用代理方法
    [self sendDelegate:TopButtonTypeYeji];
    [MobClick event:@"main_click" attributes:@{@"按钮" : @"我的业绩", @"机构" : [YTUserInfoTool userInfo].organizationName}];
}
/**
 *  菜单点击事件
 */
- (IBAction)menuClick:(UIButton *)sender {
    [self sendDelegate:TopButtonTypeMenu];
    [MobClick event:@"main_click" attributes:@{@"按钮" : @"侧边栏", @"机构" : [YTUserInfoTool userInfo].organizationName}];
}
/**
 *  调用代理方法
 *
 */
- (void)sendDelegate:(TopButtonType)type
{
    if ([self.delegate respondsToSelector:@selector(topBtnClicked:)]) {
        [self.delegate topBtnClicked:type];
    }
}

- (IBAction)myScanClick:(id)sender {
    
}


/**
 *  设置用资料
 *
 */
- (void)setUserInfo:(YTUserInfo *)userInfo
{
    userInfo.isExtension = 1;
    _userInfo = userInfo;
    if (_userInfo == nil) return;
    
    // 设置背景图片
    NSString *homeImageUrl = nil;
    if (DeviceWidth > 375) {   // 使用3X图片
        homeImageUrl = [CoreArchive strForKey:@"home3x"];
    } else {
        homeImageUrl = [CoreArchive strForKey:@"home2x"];
    }
    if (homeImageUrl != nil) {
        [self.homeImageView imageWithUrlStr:homeImageUrl phImage:[UIImage imageNamed:@"backgroundpicture"]];
    }
    
    // 设置头像
    if (_userInfo.iconImage != nil){
        self.iconImage.layer.masksToBounds = YES;
        self.iconImage.layer.cornerRadius = self.iconImage.frame.size.width * 0.5;
        self.iconImage.clipsToBounds = YES;
        self.iconImage.image = [YTUserInfoTool userInfo].iconImage;
    } else {
        [self.iconImage imageWithUrlStr:userInfo.headImgUrl phImage:[UIImage imageNamed:@"avatar_default_big"]];
    }

	    // 签到按钮
    if (userInfo.isSingIn) { // 已经签到
        self.qiaoDaoBtn.hidden = YES;
        self.scanBottomConstraint.constant = -37;
    } else {    // 未签到
        [self.qiaoDaoBtn setBackgroundImage:[UIImage imageNamed:@"weiqiandao"] forState:UIControlStateNormal];
        self.qiaoDaoBtn.hidden = NO;
        self.scanBottomConstraint.constant = 15;
    }
 	    // 云豆
    [self.yunDouBtn setTitle:[NSString stringWithFormat:@"%d", userInfo.myPoint] forState:UIControlStateNormal];

    if (userInfo.adviserStatus == 1 || userInfo.adviserStatus == 3) {
        // 设置昵称
        self.nameLable.text = userInfo.nickName;
    } else if (userInfo.adviserStatus == 2)
    {
        // 设置昵称
        self.nameLable.text = userInfo.nickName;
    
    } else {
        // 设置昵称
        if (userInfo.nickName) {
            self.nameLable.text = [NSString stringWithFormat:@"%@ | %@",userInfo.organizationName, userInfo.nickName];
        } else {
            self.nameLable.text = userInfo.organizationName;
        }
    }
    
    
    // 客户数量
    self.keHuLable.text = [NSString stringWithFormat:@"%d", userInfo.myCustomersCount];
    
    // 我的订单数量
    self.orderLable.text = [NSString stringWithFormat:@"%d", userInfo.completedOrderCount];
    
    // 我的业绩数量
    if (userInfo.completedOrderAmountCount > 10000) {
        self.wanLable.text = @"亿";
        self.yeJiLable.text = [NSString stringWithFormat:@"%.2f", (double)userInfo.completedOrderAmountCount / 10000];
    } else {
        self.wanLable.text = @"万";
        self.yeJiLable.text = [NSString stringWithFormat:@"%d", userInfo.completedOrderAmountCount];
    }
    
    // 理财师等级
    self.huangGuanImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"lv%d",userInfo.adviserLevel - 1]];
    
    // 是否显示二维码
    if (userInfo.isExtension) {
        self.myScanBtn.hidden = NO;
    } else {
        self.myScanBtn.hidden = YES;
    }

}


+ (instancetype)profileTopView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"YTProfileTopView" owner:nil options:nil] firstObject];
}


@end
