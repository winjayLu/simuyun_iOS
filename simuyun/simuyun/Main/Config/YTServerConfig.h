//
//  YTServerConfig.h
//  simuyun
//
//  Created by Luwinjay on 15/10/5.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#ifndef YTServerConfig_h
#define YTServerConfig_h


//#ifdef DEBUG
//#else
// 生产环境
//#define YTServer @"https://intime.simuyun.com/api/app/"
//#define YTH5Server @"http://www.simuyun.com"
//#define UmengAppKey @"5514ed3cfd98c5bca4000872"
//#define TXAppKey @"1251892263"
//#define jpushKey @"c2882b8380ed3637d6c60ed2"
//#define jpushProduction YES
//#define RongCloudKey @"8luwapkvuz04l"
//#endif

// 开发环境
#define UmengAppKey @"545867defd98c5f23a0021"
#define TXAppKey @"125189226"
#define jpushKey @"7ad519d9e10dac9dd4ea3d57"
#define jpushProduction NO
#define RongCloudKey @"tdrvipksrbgn5"


// 213
//#define YTServer @"http://192.168.17.213:8080/api/app/"
//#define YTH5Server @"http://192.168.17.213"

// 212
#define YTServer @"http://192.168.17.212:6060/api/app/"
#define YTH5Server @"http://192.168.17.212"

// 开发外网映射
// 212端口号18080
//#define YTServer @"http://218.241.181.229:8080/api/app/"
//#define YTH5Server @"http://218.241.181.229:8080"

// 客服ID
#define CustomerService @"dd0cc61140504258ab474b8f0a38bb56"

//  微信
#define WXAppID @"wx7259d65d4382e566"
#define WXAppSecret @"6e1deaa7b9a8c1380bd69e3de47fcc21"

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
#define YTProductList @"productsWithPaging"
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
#define YTEmailsharing @"products/emailsharing"
// 绑定手机号
#define YTBindPhone @"bindPhone"
// 修改密码
#define YTUpdatePassword @"updatePassword"
// 删除待办事项
#define YTMessageContent @"messageContent"
// 查询客户列表
#define YTCust @"cust"
// 跑马灯
#define YTMarquee @"marquee"
// 微信登录-验证unionid是否已存在
#define YTWeChatUnionId @"weChatUnionId"
// 推荐视频
#define YTRecommended @"academy/recommended"
// 其他视频
#define YTVideos @"academy/videos"
// 点赞
#define YTVideoLike @"academy/videos/like"
// 删除订单
#define YTdeleteOrder @"order/delete"
// 根据视频id查询视频
#define YTSelectVideo @"academy/videos/detail"
// 查询机构推荐人
#define YTReferee @"referee"
// 获取融云token
#define YTToken @"rc/gettoken"
// 获取融云聊天用户信息
#define YTRcUserInfo @"rc/userinfo"
// 获取机构经理发送消息
#define YTRcManagerInfo @"rc/managerinfo"
// 提交赎回申请
#define YTRedeemption @"redemptionApply"
// 可赎回订单列表
#define YTRedeemList @"redemptionOrderList"
// 赎回订单详情
#define YTRedeemDetail @"redemptionOrderDetail"
// 检查邀请码
#define YTCheckInviteCode @"checkInviteCode"
// 应用邀请码
#define YTCommitInviteCode @"applyInviteCode"
// 邮件获取赎回资料
#define YTGetRedeemMeans @"emailRedemMatirial"
// 获取平台客服消息
#define YTGreetingmessage @"rc/greetingmessage"
// 获取团队成员列表
#define YTGetAllMembers @"getAllMembers"
// 获取团队组列表
#define YTGetAllGroups @"getAllGroups"



#endif /* YTServerConfig_h */
