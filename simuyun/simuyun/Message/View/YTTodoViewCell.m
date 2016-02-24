//
//  YTTodoViewCell.m
//  simuyun
//
//  Created by Luwinjay on 15/10/31.
//  Copyright © 2015年 YTWealth. All rights reserved.
//
// 待办事项

#import "YTTodoViewCell.h"
#import "UIImageView+SD.h"

// 左右间距
#define maginWidth 7

@interface YTTodoViewCell()

// icon图片
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

// title
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

// 日期
@property (weak, nonatomic) IBOutlet UILabel *dateLable;

// 摘要
@property (weak, nonatomic) IBOutlet UILabel *detailLable;

@end

@implementation YTTodoViewCell


+ (instancetype)todoCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"YTTodoViewCell" owner:nil options:nil] lastObject];
}

/**
 *  修改Cell的frame
 *
 */
// frame.origin.x +
- (void)setFrame:(CGRect)frame
{
    CGRect newF = {{ maginWidth, frame.origin.y}, {DeviceWidth - maginWidth * 2, frame.size.height}};
    [super setFrame:newF];
}

// 设置数据
- (void)setMessage:(YTMessageModel *)message
{
    _message = message;
    
    // 设置图片
    [self.iconImage imageWithUrlStr:_message.iconUrl phImage:[UIImage imageNamed:@"messagePl"]];
    
    self.titleLable.text = _message.title;
    self.detailLable.text = _message.summary;
    self.dateLable.text = _message.createDate;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
