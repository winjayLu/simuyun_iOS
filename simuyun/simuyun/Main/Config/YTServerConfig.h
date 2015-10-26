//
//  YTServerConfig.h
//  simuyun
//
//  Created by Luwinjay on 15/10/5.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#ifndef YTServerConfig_h
#define YTServerConfig_h


//  微信
#define WXAppID @"wx7259d65d4382e566"
#define WXAppSecret @"6e1deaa7b9a8c1380bd69e3de47fcc21"

// 友盟
#define UmengAppKey @"545867defd98c5f23a0021da"  // 开发环境
//#define UmengAppKey @"5514ed3cfd98c5bca4000872"  // 生产环境

//  开发环境
#define YTServer @"http://192.168.17.213:8080/api/app/"
//#define YTServer @"http://172.168.1.177:8080/api/app/"

//  测试环境
//#define YTServer @"http://192.168.17.212:8080/api/interface/api"

//  生产环境
//#define YTServer @"https://intime.simuyun.com/api/interface/api"



/** 接口名 */
// 程序启动信息
#define YTGetResources @"resources"
// 登录
#define YTSession @"session"
// 加载产品列表
#define YTProductList @"products"
// 发送验证码
#define YTCaptcha @"captcha"
// 注册
#define YTRegister @"register"
// 找回密码
#define YTresetPassword @"resetPassword"
// 微信登录
#define YTWeChatLogin @"weChatLogin"
// 获取用户信息
#define YTUser @"userInfo"
// 认购产品
#define YTOrder @"order"
// 轮播图片
#define YTBanner @"banner"
// 订单列表
#define YTOrders @"orders"
// 资讯列表5条
#define YTNewes @"informations/newest"
// 获取资讯列表
#define YTInformations @"informations"





#endif /* YTServerConfig_h */
