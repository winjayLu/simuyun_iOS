//
//  YTAuthenticationModel.h
//  simuyun
//
//  Created by Luwinjay on 15/10/30.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTAuthenticationModel : NSObject

// 真实姓名
@property (nonatomic, copy) NSString *realName;

// 机构名称
@property (nonatomic, copy) NSString *orgName;

// 认证时间
@property (nonatomic, copy) NSString *submitTime;



@end
