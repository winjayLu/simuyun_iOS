//
//  YTStockCell.m
//  simuyun
//
//  Created by Luwinjay on 15/10/19.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTStockCell.h"

@interface YTStockCell()

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
@end

@implementation YTStockCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNewes:(YTNewest *)newes
{
    _newes = newes;
    self.title.text = newes.title;
    self.summary.text = newes.summary;

}

@end
