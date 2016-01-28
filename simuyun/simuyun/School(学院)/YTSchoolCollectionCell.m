//
//  YTCollectionViewCell.m
//  simuyun
//
//  Created by Luwinjay on 16/1/28.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTSchoolCollectionCell.h"

@implementation YTSchoolCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

/**
 *  初始化方法
 */
- (void)setup
{
    CGFloat vedioWidth = (DeviceWidth - 32) * 0.5;
    // 图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"SchoolBanner"];
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 1.0f;
    imageView.layer.borderColor = YTColor(208, 208, 208).CGColor;
    imageView.frame = CGRectMake(0, 0, vedioWidth, 96);
    [self addSubview:imageView];
    // 标题
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.text = @"我是标题";
    titleLable.textColor = YTColor(51, 51, 51);
    titleLable.font = [UIFont systemFontOfSize:13];
    [titleLable sizeToFit];
    titleLable.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 5, titleLable.width, titleLable.height);
    [self addSubview:titleLable];
    // 子标题
    UILabel *detailLable = [[UILabel alloc] init];
    detailLable.text = @"聚合财富管理力量！聚合财富管理力量！聚合财富管理力量！聚合财富管理力量！聚合财富管理力量！聚合财富管理力量！聚合财富管理力量！聚合财富管理力量！聚合财富管理力量！聚合财富管理力量！聚合财富管理力量！";
    detailLable.textColor = YTColor(102, 102, 102);
    detailLable.font = [UIFont systemFontOfSize:12];
    detailLable.width = vedioWidth;
    detailLable.numberOfLines = 2;
    [detailLable sizeToFit];
    detailLable.frame = CGRectMake(0, CGRectGetMaxY(titleLable.frame) + 5, detailLable.width, detailLable.height);
    [self addSubview:detailLable];
}




@end
