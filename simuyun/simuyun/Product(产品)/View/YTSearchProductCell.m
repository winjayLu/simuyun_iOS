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



- (void)setProduct:(YTProductModel *)product
{
    _product = product;
    self.titleLable.text = _product.pro_name;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
