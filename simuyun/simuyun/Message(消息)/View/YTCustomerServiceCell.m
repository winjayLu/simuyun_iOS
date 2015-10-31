//
//  YTCustomerServiceCell.m
//  simuyun
//
//  Created by Luwinjay on 15/10/25.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTCustomerServiceCell.h"

// 左右间距
#define maginWidth 7
@implementation YTCustomerServiceCell


+ (instancetype)CustomerServiceCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"YTCustomerServiceCell" owner:nil options:nil] lastObject];
}

/**
 *  修改Cell的frame
 *
 */
- (void)setFrame:(CGRect)frame
{
    CGRect newF = {{frame.origin.x + maginWidth, frame.origin.y}, {frame.size.width - maginWidth * 2, frame.size.height}};
    [super setFrame:newF];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
