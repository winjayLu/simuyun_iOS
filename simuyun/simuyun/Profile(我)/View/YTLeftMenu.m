//
//  YTLeftMenu.m
//  simuyun
//
//  Created by Luwinjay on 15/10/10.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTLeftMenu.h"

@implementation YTLeftMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)leftMenu
{
    return [[[NSBundle mainBundle] loadNibNamed:@"YTLeftMenu" owner:nil options:nil] firstObject];
}

@end
