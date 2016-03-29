//
//  YTCloudListCell.m
//  simuyun
//
//  Created by Luwinjay on 16/3/29.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTCloudListCell.h"

@implementation YTCloudListCell


/**
 *  修改Cell的frame
 *
 */
- (void)setFrame:(CGRect)frame
{
    CGRect newF = {{frame.origin.x + maginWidth, frame.origin.y}, {DeviceWidth - maginWidth * 2, frame.size.height}};
    [super setFrame:newF];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"%zd", self.portraitStyle);
        self.bubbleTipView.size = CGSizeMake(40, 40);
        
    }
    return self;
}

@end
