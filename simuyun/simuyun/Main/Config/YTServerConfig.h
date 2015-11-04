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


// H5测试地址
#define YTH5Server @"http://192.168.17.213"

/** 接口名 */
// 程序启动信息
#define YTGetResources @"resources"
// 红包雨
#define YTRedpacket @"redpacket"
// 登录
#define YTSession @"session"
// 关联微信
#define YTBindWeChat @"bindWeChat"
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
// 获取股指数据
#define YTStockindex @"stockindex"
// 签到
#define YTSignIn @"signIn"
// 获取机构列表
#define YTOrgnazations @"orgnazations"
// 理财师认证
#define YTAuthAdviser @"authAdviser"
// 打款凭条，证件资料图片上传
#define YTSlip @"upload"
// 报备
#define YTReport @"order/report"
// 上传图片
#define YTUploadUserImage @"uploadUserImage"
// 消息列表
#define YTChatContent @"messageList"
// 客服列表
#define YTCustomerService @"chatContent"
// 未读消息数量
#define YTMessageCount @"messageCount"
// 邮件获取产品资料
#define YTEmailsharing @"emailsharing"
// 绑定手机号
#define YTBindPhone @"bindPhone"
// 修改密码
#define YTUpdatePassword @"updatePassword"



#endif /* YTServerConfig_h */
