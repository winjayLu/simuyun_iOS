//
//  YTMemberModel.h
//  simuyun
//
//  Created by Luwinjay on 16/5/6.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTMemberModel : NSObject

@property (nonatomic, copy) NSString *lastLoginTime;

@property (nonatomic, copy) NSString *phoneNum;

@property (nonatomic, copy) NSString *memo;

@property (nonatomic, copy) NSString *headImgUrl;

@property (nonatomic, copy) NSString *joinTeamTime;

@property (nonatomic, assign) NSInteger isFather;

@property (nonatomic, copy) NSString *adviserId;

@property (nonatomic, copy) NSString *nickName;

@end
