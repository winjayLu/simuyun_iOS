//
//  YTInformationTableViewCell.m
//  simuyun
//
//  Created by Luwinjay on 15/10/26.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTInformationTableViewCell.h"
#import "UIImageView+SD.h"

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
    if(information.date != nil && information.date.length > 0)
    {
        self.dateLable.text = information.date;
    }
    if (information.url == nil || information.url.length == 0) {
        self.iconImage.image = [UIImage imageNamed:@"yunguandian"];
    } else {
        [self.iconImage imageWithUrlStr:[NSString stringWithFormat:@"http://%@",information.url]phImage:nil];
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
