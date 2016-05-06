//
//  YTGroupModel.h
//  simuyun
//
//  Created by Luwinjay on 16/5/6.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTMemberModel.h"

@interface YTGroupModel : NSObject

@property (nonatomic, copy) NSString *groupId;

@property (nonatomic, copy) NSString *groupName;

@property (nonatomic, strong) NSArray<YTMemberModel *> *members;

@end

