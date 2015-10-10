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

- (void)setTodoTitle:(NSString *)todoTitle
{

    _todoTitle = todoTitle;
    self.titleLble.text = _todoTitle;
}

@end
