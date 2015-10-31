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


- (void)setImageName:(NSString *)imageName
{
    self.iconImage.image = [UIImage imageNamed:imageName];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
