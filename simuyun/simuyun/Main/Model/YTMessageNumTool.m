//
//  YTMessageNumTool.m
//  simuyun
//
//  Created by Luwinjay on 15/11/2.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTMessageNumTool.h"

@implementation YTMessageNumTool


// 用户信息
static YTMessageNum *_messageNum;

/**
 *  存储未读消息数量
 */
+ (void)save:(YTMessageNum *)messageNum
{
    _messageNum = messageNum;
}

/**
 *  获得上次存储的未读消息数量
 */

+ (YTMessageNum *)messageNum
{
    return _messageNum;
}



@end
