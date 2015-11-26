//
//  YTTokenView.m
//  simuyun
//
//  Created by Luwinjay on 15/11/1.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTTokenView.h"
#import "YTAccountTool.h"

@interface YTTokenView() <UIWebViewDelegate>

@end

@implementation YTTokenView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setToken];
    }
    return self;
}

// 填充token
- (void)setToken
{
    
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/setData.html", YTH5Server]]]];
    self.delegate = self;
}

@end
