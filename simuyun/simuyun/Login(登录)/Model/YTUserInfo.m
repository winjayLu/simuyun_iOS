//
//  YTUserInfo.m
//  simuyun
//
//  Created by Luwinjay on 15/10/18.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// 用户信息模型

#import "YTUserInfo.h"
#import "NSDate+Extension.h"

@implementation YTUserInfo


- (NSString *)organizationName
{
    if (_organizationName == nil) {
        return @"";
    }
    return _organizationName;
}


MJCodingImplementation
@end
