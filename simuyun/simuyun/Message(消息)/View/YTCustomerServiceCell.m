//
//  YTCustomerServiceCell.m
//  simuyun
//
//  Created by Luwinjay on 15/10/25.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTCustomerServiceCell.h"
#import "YTMessageNumTool.h"

// 左右间距
#define maginWidth 7

@interface YTCustomerServiceCell()

// 日期
@property (weak, nonatomic) IBOutlet UILabel *dateLable;

// 标题
@property (weak, nonatomic) IBOutlet UILabel *contentLable;

// 未读消息数量
@property (weak, nonatomic) IBOutlet UIButton *unreadNum;
@end

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
// 设置数据
- (void)setService:(YTServiceModel *)service
{
    _service = service;
    self.dateLable.text = service.create_time;
    self.contentLable.text = service.content;
    YTMessageNum *num = [YTMessageNumTool messageNum];
    
    if (num.CHAT_CONTENT == 0) {
        self.unreadNum.hidden = YES;
    } else {
        [self.unreadNum setTitle:[NSString stringWithFormat:@"%d", [YTMessageNumTool messageNum].CHAT_CONTENT] forState:UIControlStateNormal];
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
