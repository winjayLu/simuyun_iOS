//
//  YTCollectionViewCell.m
//  simuyun
//
//  Created by Luwinjay on 16/1/28.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTSchoolCollectionCell.h"
#import "UIImageView+SD.h"

@interface YTSchoolCollectionCell()

/**
 *  图片
 */
@property (nonatomic, weak) UIImageView *imageView;

// 标题
@property (nonatomic, weak) UILabel *titleLable;
// 子标题
@property (nonatomic, weak) UILabel *detailLable;

@end

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
//    CGFloat vedioWidth = ;
    // 图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 1.0f;
    imageView.layer.borderColor = YTColor(208, 208, 208).CGColor;
    imageView.frame = CGRectMake(0, 0, (DeviceWidth - 32) * 0.5, 96);
    [self addSubview:imageView];
    self.imageView = imageView;
    // 标题
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.textColor = YTColor(51, 51, 51);
    titleLable.font = [UIFont systemFontOfSize:13];
    titleLable.origin = CGPointMake(0, CGRectGetMaxY(imageView.frame) + 5);
    [self addSubview:titleLable];
    self.titleLable = titleLable;
    // 子标题
    UILabel *detailLable = [[UILabel alloc] init];
    detailLable.textColor = YTColor(102, 102, 102);
    detailLable.font = [UIFont systemFontOfSize:12];
    detailLable.numberOfLines = 2;
    detailLable.origin = CGPointMake(0, CGRectGetMaxY(titleLable.frame) + 5);
    [self addSubview:detailLable];
    self.detailLable = detailLable;
}

- (void)setVedio:(YTVedioModel *)vedio {
    CGFloat vedioWidth = (DeviceWidth - 32) * 0.5;
    self.titleLable.text = vedio.videoName;
    [self.titleLable sizeToFit];
    self.titleLable.width = vedioWidth;
    self.detailLable.width = vedioWidth;
    self.detailLable.text = vedio.shortName;
    self.detailLable.origin = CGPointMake(0, CGRectGetMaxY(self.titleLable.frame) + 5);
    [self.detailLable sizeToFit];
    if (vedio.image) {
        self.imageView.image = [UIImage imageNamed:@"SchoolBanner"];
    } else{
        [self.imageView imageWithUrlStr:vedio.coverImageUrl phImage:[UIImage imageNamed:@"SchoolBanner"]];
    }
    
}




@end
