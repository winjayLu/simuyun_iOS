//
//  YTInformationTableViewCell.m
//  simuyun
//
//  Created by Luwinjay on 15/10/26.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTInformationTableViewCell.h"

// 左右间距
#define maginWidth 7

@interface YTInformationTableViewCell()

/**
 *  图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *title;
/**
 *  摘要
 */
@property (weak, nonatomic) IBOutlet UILabel *summary;
/**
 *  日期
 */
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@end

@implementation YTInformationTableViewCell

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
- (void)setInformation:(YTInformation *)information
{
    _information = information;
    self.title.text = information.title;
    self.summary.text = information.summary;
//    self.dateLable.text = information.

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
