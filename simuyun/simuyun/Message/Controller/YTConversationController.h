//
//  YTConversationController.h
//  simuyun
//
//  Created by Luwinjay on 16/3/30.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface YTConversationController : RCConversationViewController

/**
 *  自己的id
 */
@property (nonatomic, copy) NSString *userId;

/**
 *  是否需要拨打电话
 */
@property (nonatomic, assign) BOOL isMobile;

@end
