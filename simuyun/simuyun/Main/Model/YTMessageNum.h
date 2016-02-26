//
//  YTMessageNum.h
//  simuyun
//
//  Created by Luwinjay on 15/11/2.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// 未读消息数量

#import <Foundation/Foundation.h>

@interface YTMessageNum : NSObject

// 客服消息
@property (nonatomic, assign) int unreadTalkNum;

// 产品动态
@property (nonatomic, assign) int unreadProductNum;

// 运营公告
@property (nonatomic, assign) int unreadNoticeNum;

// 营销喜报
@property (nonatomic, assign) int unreadGoodNewsNum;

// 待办事项
@property (nonatomic, assign) int unreadTodoNum;
@end

/** 
 未读消息数量字段定义
 1> 平台客服 : unreadTalkNum
 2> 产品动态 : unreadProductNum
 3> 运营公告 : unreadNoticeNum
 4> 营销喜报 : unreadGoodNewsNum
 5> 待办事项 : unreadTodoNum
 字段对应的时间参数
 1> 平台客服 : timestampCategory0
 2> 产品动态 : timestampCategory2
 3> 运营公告 : timestampCategory4
 5> 营销喜报 : timestampCategory6
 6> 待办事项 : timestampCategory1  
 注：待办事项默认显示全部数据，未读消息数量为消息总量（不需要时间判断），客户端可不传
 */

