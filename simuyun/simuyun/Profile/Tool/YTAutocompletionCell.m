//
//  YTAutocompletionCell.m
//  simuyun
//
//  Created by Luwinjay on 15/12/7.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTAutocompletionCell.h"

@interface YTAutocompletionCell()

@property (weak, nonatomic) IBOutlet UIView *lineView;


@end

@implementation YTAutocompletionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)autocompletionCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"YTAutocompletionCell" owner:nil options:nil] lastObject];
}

- (void)setTitle:(NSString *)title
{
    self.titleLable.text = title;
}

- (void)setIsHidden:(BOOL)isHidden
{
    self.lineView.hidden = isHidden;
}

@end
