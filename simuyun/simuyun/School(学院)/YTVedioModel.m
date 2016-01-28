//
//  YTVedioModel.m
//  simuyun
//
//  Created by Luwinjay on 16/1/27.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTVedioModel.h"

@implementation YTVedioModel

- (instancetype)initWithTitle:(NSString *)title image:(NSString *)image shortName:(NSString *)shortName
{
    self = [super init];
    if (self != nil) {
        self.videoName = title;
        self.image = [UIImage imageNamed:@"SchoolBanner"];
        self.shortName = shortName;
    }
    return self;
}

@end
