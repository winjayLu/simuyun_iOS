//
//  YTTodoViewCell.m
//  simuyun
//
//  Created by Luwinjay on 15/10/31.
//  Copyright © 2015年 YTWealth. All rights reserved.
//
// 待办事项

#import "YTTodoViewCell.h"

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
- (void)setFrame:(CGRect)frame
{
    CGRect newF = {{frame.origin.x + maginWidth, frame.origin.y}, {frame.size.width - maginWidth * 2, frame.size.height}};
    [super setFrame:newF];
}

// 设置数据
- (void)setMessage:(YTMessageModel *)message
{
    _message = message;
    NSString *imageName = nil;
    switch (message.category2Code) {    // 判断类型
        case 11:
            imageName = [NSString stringWithFormat:@"message%d",message.category2Code];
            break;
        case 12:
            imageName = [NSString stringWithFormat:@"message%d",message.category2Code];
            break;
        case 21:
            imageName = [NSString stringWithFormat:@"message%d",message.category2Code];
            break;
        case 22:
            imageName = [NSString stringWithFormat:@"message%d",message.category2Code];
            break;
        case 23:
            imageName = [NSString stringWithFormat:@"message%d",message.category2Code];
            break;
        case 24:
            imageName = [NSString stringWithFormat:@"message%d",message.category2Code];
            break;
        case 31:
            imageName = [NSString stringWithFormat:@"message%d",message.category2Code];
            break;
        case 32:
            imageName = [NSString stringWithFormat:@"message%d",message.category2Code];
            break;
        case 33:
            imageName = [NSString stringWithFormat:@"message%d",message.category2Code];
            break;
        case 34:
            imageName = [NSString stringWithFormat:@"message%d",message.category2Code];
            break;
        case 35:
            imageName = [NSString stringWithFormat:@"message%d",message.category2Code];
            break;
    }
    self.iconImage.image = [UIImage imageNamed:imageName];
    
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
