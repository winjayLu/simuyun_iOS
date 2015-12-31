//
//  YTSearchProductCell.m
//  simuyun
//
//  Created by Luwinjay on 15/12/28.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTSearchProductCell.h"
#import "YTProductModel.h"

@interface YTSearchProductCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end

@implementation YTSearchProductCell


+ (instancetype)productCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"YTSearchProductCell" owner:nil options:nil] lastObject];
}



- (void)setSearchTitle:(NSString *)searchTitle
{
    _searchTitle = searchTitle;
    self.titleLable.text = searchTitle;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
