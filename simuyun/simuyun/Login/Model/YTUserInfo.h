//
//  YTUserInfo.h
//  simuyun
//
//  Created by Luwinjay on 15/10/18.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTUserInfo : NSObject <NSCoding>

/**
 *  用户昵称
 */
@property (nonatomic, copy) NSString *nickName;

/**
 *  真实姓名
 */
@property (nonatomic, copy) NSString *realName;

// 理财师认证状态
// 0 已认证， 1 未认证， 2 认证中， 3 驳回
@property (nonatomic, assign) int adviserStatus;

// 机构ID
@property (nonatomic, copy) NSString *organizationId;

// 机构名称
@property (nonatomic, copy) NSString *organizationName;

// 微信id
@property (nonatomic, copy) NSString *wechatUnionid;

// 头像地址
@property (nonatomic, copy) NSString *headImgUrl;

// 云豆数量
@property (nonatomic, assign) int myPoint;

// 签到状态   0 未签到
@property (nonatomic, assign) int isSingIn;

// 我的客户数
@property (nonatomic, assign) int myCustomersCount;

// 我的已完成订单数
@property (nonatomic, assign) int completedOrderCount;

// 我的业绩总数
@property (nonatomic, assign) int completedOrderAmountCount;

// 电子邮件
@property (nonatomic, copy) NSString *email;

// 理财师等级
@property (nonatomic, assign) int adviserLevel;

// 电话号码
@property (nonatomic, copy) NSString *phoneNumer;

/**
 *  用户头像
 */
@property (nonatomic, strong) UIImage *iconImage;

// 待报备订单数量
@property (nonatomic, assign) int preparedforNum;

// 团队数量
@property (nonatomic, assign) int teamNum;
// 是否有二维码
@property (nonatomic, assign) BOOL isExtension;


@end
