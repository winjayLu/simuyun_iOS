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


#warning 修改机构名称
- (NSString *)organizationName
{
    if (_organizationName == nil) {
        return @"";
    }
    return _organizationName;
}

//- (void)setHeadImgUrl:(NSString *)headImgUrl
//{
//    
//    NSMutableString *newUrl = [NSMutableString string];
//    [newUrl appendString:headImgUrl];
//    [newUrl appendString:[NSDate stringDate]];
//    _headImgUrl = newUrl;
//}


@end
