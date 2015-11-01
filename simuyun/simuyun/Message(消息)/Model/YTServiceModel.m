//
//  YTServiceModel.m
//  simuyun
//
//  Created by Luwinjay on 15/11/1.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// 客服模型

#import "YTServiceModel.h"
#import "CoreArchive.h"

@implementation YTServiceModel


- (void)setLastTimestamp:(NSString *)lastTimestamp
{
    _lastTimestamp = lastTimestamp;
    [CoreArchive setStr:_lastTimestamp key:@"lastTimestamp"];
}
@end
