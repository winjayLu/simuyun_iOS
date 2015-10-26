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

@interface YTProfileTopView() <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

/**
 *  头像单击事件
 */
- (IBAction)iconClick:(UITapGestureRecognizer *)sender;

/**
 *  认证按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *renZhenBtn;
/**
 *  认证按钮单击事件
 *
 */
- (IBAction)renZhenClick:(UIButton *)sender;

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
    // 调用代理方法
    [self.delegate addPicker:imagePicker];
}

/**
 *  拍照成功
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    // 关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    // 设置图片到iconView上
    [self setIconImageWithImage:image];
    
    // 将新的图片保存到用户信息中
    YTUserInfo *userInfo = [YTUserInfoTool userInfo];
    userInfo.iconImage = image;
    [YTUserInfoTool saveUserInfo:userInfo];
    
    // 发送通知
    [YTCenter postNotificationName:YTUpdateIconImage object:nil];
}


#pragma mark - 按钮点击
/**
 *  认证按钮点击事件
 */
- (IBAction)renZhenClick:(UIButton *)sender {
    // 调用代理方法
    [self sendDelegate:TopButtonTypeRenzhen];
}
/**
 *  签到按钮点击事件
 */
- (IBAction)qiaoDaoClick:(UIButton *)sender {
    // 调用代理方法
    [self sendDelegate:TopButtonTypeQiandao];
}
/**
 *  云豆按钮点击事件
 */
- (IBAction)yunDouClick:(UIButton *)sender {
    // 调用代理方法
    [self sendDelegate:TopButtonTypeYundou];
}
/**
 *  我的客户点击事件
 */
- (IBAction)keHuBtn:(id)sender {
    // 调用代理方法
    [self sendDelegate:TopButtonTypeKehu];
}
/**
 *  我的订单点击事件
 */
- (IBAction)orderClick:(UIButton *)sender {
    // 调用代理方法
    [self sendDelegate:TopButtonTypeDindan];
}
/**
 *  我的业绩点击事件
 */
- (IBAction)yeJiBtn:(UIButton *)sender {
    // 调用代理方法
    [self sendDelegate:TopButtonTypeYeji];
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

#pragma mark - 设置数据
/**
 *  给iconView设置图片
 */
- (void)setIconImageWithImage:(UIImage *)image
{
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.cornerRadius = self.iconImage.frame.size.width * 0.5;
    self.iconImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.iconImage.layer.shouldRasterize = YES;
    self.iconImage.clipsToBounds = YES;
    // 判断是否是更换图片
    if(image == nil) {
        self.iconImage.image = [UIImage imageNamed:@"avatar_default_big"];
        return;
    }
    
    self.iconImage.image = image;
}

/**
 *  设置用资料
 *
 */
- (void)setUserInfo:(YTUserInfo *)userInfo
{
    _userInfo = userInfo;
    if (_userInfo == nil) return;
    
    // 设置头像
    [self.iconImage imageWithUrlStr:userInfo.headImgUrl phImage:nil];
    
    // 签到按钮
    if (userInfo.isSingIn) { // 已经签到
        [self.qiaoDaoBtn setBackgroundImage:[UIImage imageNamed:@"yiqiandao"] forState:UIControlStateNormal];
        self.qiaoDaoBtn.enabled = NO;
    } else {    // 未签到
        [self.qiaoDaoBtn setBackgroundImage:[UIImage imageNamed:@"weiqiandao"] forState:UIControlStateNormal];
        self.qiaoDaoBtn.enabled = YES;
    }
    
    // 云豆
    [self.yunDouBtn setTitle:[NSString stringWithFormat:@"%d", userInfo.myPoint] forState:UIControlStateNormal];
    
    
    // 认证状态
    if (userInfo.adviserStatus) {
        self.renZhenBtn.hidden = NO;
        // 设置昵称
        self.nameLable.text = userInfo.nickName;
    } else {
        self.renZhenBtn.hidden = YES;
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
        self.yeJiLable.text = [NSString stringWithFormat:@"%.2f", (double)userInfo.completedOrderCount / 10000];
    } else {
        self.wanLable.text = @"万";
        self.yeJiLable.text = [NSString stringWithFormat:@"%d", userInfo.completedOrderCount];
    }
    
}


+ (instancetype)profileTopView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"YTProfileTopView" owner:nil options:nil] firstObject];
}
@end
