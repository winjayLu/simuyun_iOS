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
        self.bubbleTipView.size = CGSizeMake(40, 40);
        // 标题lable
        self.conversationTitle.textColor = YTColor(51, 51, 51);
        // 最后一条消息Lable
        self.messageContentLabel.textColor = YTColor(102, 102, 102);
        // 发送时间Lable
        self.messageCreatedTimeLabel.textColor = YTColor(102, 102, 102);
        self.headerImageViewBackgroundView.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setDataModel:(RCConversationModel *)model
{
    [super setDataModel:model];
    self.bubbleTipView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"voice_unread999"]];
    self.bubbleTipView.layer.cornerRadius = 4;
    self.bubbleTipView.layer.masksToBounds = YES;
    self.bubbleTipView.bubbleTipBackgroundColor = [UIColor clearColor];
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    self.bubbleTipView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"voice_unread999"]];
}


@end
