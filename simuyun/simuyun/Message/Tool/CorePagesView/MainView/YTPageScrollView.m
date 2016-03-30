//
//  YTPageScrollView.m
//  simuyun
//
//  Created by Luwinjay on 16/3/30.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTPageScrollView.h"

@interface YTPageScrollView()<UIGestureRecognizerDelegate>



@end


@implementation YTPageScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer.state != 0) {
        return YES;
    } else {
        return NO;
    }
}

@end
