//
//  YTGroupCell.m
//  simuyun
//
//  Created by Luwinjay on 15/10/10.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTGroupCell.h"

@interface YTGroupCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UIView *lineView;


@end


@implementation YTGroupCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLable.text = _title;
    
}

- (void)setIsShowLine:(BOOL)isShowLine
{
    _isShowLine = isShowLine;
    self.lineView.hidden = !isShowLine;
}

@end
