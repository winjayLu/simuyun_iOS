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
@property (nonatomic, assign) int CHAT_CONTENT;

// 待办事项
@property (nonatomic, assign) int TODO_LIST;

// 产品新闻
@property (nonatomic, assign) int SYSTEM_NOTICE;

// 系统通知
@property (nonatomic, assign) int PRODUCT_NEWS;
@end
