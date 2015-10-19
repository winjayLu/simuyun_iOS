//
//  YTUserInfoTool.h
//  simuyun
//
//  Created by Luwinjay on 15/10/18.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// 用户信息工具类

#import <Foundation/Foundation.h>
#import "YTUserInfo.h"

@interface YTUserInfoTool : NSObject

/**
 *  加载用户信息
 */
+ (YTUserInfo *)loadUserInfo;

@end
