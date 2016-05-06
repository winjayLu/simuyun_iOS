//
//  YTGroupModel.m
//  simuyun
//
//  Created by Luwinjay on 16/5/6.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTGroupModel.h"

@implementation YTGroupModel


+ (NSDictionary *)objectClassInArray{
    return @{@"members" : [YTMemberModel class]};
}

@end



