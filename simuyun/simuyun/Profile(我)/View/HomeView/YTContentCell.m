//
//  YTContentCell.m
//  simuyun
//
//  Created by Luwinjay on 15/10/10.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTContentCell.h"

@interface YTContentCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLble;

@end

@implementation YTContentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSummary:(NSString *)summary
{
    _summary = summary;
    self.titleLble.text = summary;
}

@end
