//
//  YTMemberModel.m
//  simuyun
//
//  Created by Luwinjay on 16/5/6.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTMemberModel.h"

@implementation YTMemberModel



- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[YTMemberModel class]]) {
        if ([((YTMemberModel *)object).adviserId isEqualToString:self.adviserId]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

@end
