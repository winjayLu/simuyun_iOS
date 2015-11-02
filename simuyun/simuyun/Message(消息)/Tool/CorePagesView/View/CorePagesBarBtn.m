//
//  CorePagesBarBtn.m
//  CorePagesView
//
//  Created by muxi on 15/3/20.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "CorePagesBarBtn.h"

#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface CorePagesBarBtn()

// 小红点
@property (nonatomic, weak) UIImageView *hongDian;

@end


@implementation CorePagesBarBtn


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        //个性化
        [self corePagesBarBtnPrePare];
    }
    
    return self;
}



-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self=[super initWithCoder:aDecoder];
    
    if(self){
        
        //个性化
        [self corePagesBarBtnPrePare];
    }
    
    return self;
}

/**
 *  个性化
 */
-(void)corePagesBarBtnPrePare{
    [self setBackgroundColor:[UIColor whiteColor]];
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(DeviceWidth * 0.25 - 0.5, 0, 0.5, 34);
    view.backgroundColor = YTColor(231, 231, 231);
    [self addSubview:view];
    
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = [UIImage imageNamed:@"weidu"];
    icon.frame = CGRectMake(view.x - 14, 5, 9, 9);
    icon.hidden = YES;
    [self addSubview:icon];
    self.hongDian = icon;
    
    [self setTitleColor:YTColor(124, 124, 124) forState:UIControlStateNormal];
    [self setTitleColor:YTColor(215, 58, 46) forState:UIControlStateHighlighted];
    [self setTitleColor:YTColor(215, 58, 46) forState:UIControlStateSelected];
}

- (void)isShow:(BOOL)show
{
    self.hongDian.hidden = !show;
}


@end
