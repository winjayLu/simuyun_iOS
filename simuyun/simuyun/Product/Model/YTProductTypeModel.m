//
//  YTProductTypeModel.m
//  simuyun
//
//  Created by Luwinjay on 16/5/11.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTProductTypeModel.h"

@implementation YTProductTypeModel

- (instancetype)initWithName:(NSString *)name type:(NSString *)type
{
    self = [super init];
    if (self) {
        self.name = name;
        self.type = type;
    }
    return self;
}

@end
