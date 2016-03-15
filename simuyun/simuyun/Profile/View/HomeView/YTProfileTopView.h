//
//  YTProfileTopView.h
//  测试头像上传
//
//  Created by Luwinjay on 15/10/4.
//  Copyright © 2015年 Luwinjay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTUserInfo.h"

/**
 *   按钮类型
 */
typedef enum {
//    TopButtonTypeRenzhen,   //  未认证
    TopButtonTypeQiandao,   //  签到
    TopButtonTypeYundou,    //  云豆
    TopButtonTypeKehu,      //  我的客户
    TopButtonTypeDindan,    //  完成订单
    TopButtonTypeYeji,       //  我的业绩
    TopButtonTypeMenu,       // 菜单
    TopButtonTypeMyScan        // 我的二维码
    
} TopButtonType;



@protocol TopViewDelegate <NSObject>

@optional

/**
 *  打开系统相机
 */
-(void)addPicker:(UIViewController *)picker;

/**
 *  按钮点击
 *
 */
- (void)topBtnClicked:(TopButtonType)type;

@end

@interface YTProfileTopView : UIView

/**
 *  用户信息
 */
@property (nonatomic, strong) YTUserInfo *userInfo;


/**
 *  代理
 */
@property (nonatomic, weak) id <TopViewDelegate> delegate;

/**
 *  设置头像
 *
 */
- (void)setIconImageWithImage:(UIImage *)image;

+ (instancetype)profileTopView;
@end
