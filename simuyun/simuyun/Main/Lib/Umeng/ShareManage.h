//
//  ShareManage.h
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//
//  分享平台管理工具类

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface ShareManage : NSObject 
+ (ShareManage *)shareManage;

/**
 *  配置图文分享
 */
- (void)shareConfig;

/**
 *  分享标题
 */
@property (nonatomic, copy) NSString *share_title;
/**
 *  分享内容
 */
@property (nonatomic, copy) NSString *share_content;
/**
 *  分享url
 */
@property (nonatomic, copy) NSString *share_url;
/**
 *  分享图片
 */
@property (nonatomic, strong) UIImage *share_image;

/**新浪微博分享**/
/**
 *  下个版本考虑
 */
//- (void)wbShareWithViewControll:(UIViewController *)viewC;


/** 微信分享**/
- (void)wxShareWithViewControll:(UIViewController *)viewC;

/** 微信朋友圈分享**/
- (void)wxpyqShareWithViewControll:(UIViewController *)viewC;

/** 短信分享**/
- (void)smsShareWithViewControll:(UIViewController *)viewC;

/** 邮件分享**/
- (void)displayEmailComposerSheet:(UIViewController *)vc;

@end
