//
//  YTSchoolTableViewCell.m
//  simuyun
//
//  Created by Luwinjay on 16/1/28.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTSchoolTableViewCell.h"
#import "UIImageView+SD.h"


@interface YTSchoolTableViewCell()



/**
 *  视频标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

/**
 *  视频短标题
 */
@property (weak, nonatomic) IBOutlet UILabel *shortNameLable;

/**
 *  视频创建日期
 */
@property (weak, nonatomic) IBOutlet UILabel *dateLable;


/**
 *  点赞按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

/**
 *  title的宽度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleConstraint;

@end


@implementation YTSchoolTableViewCell

+ (instancetype)schoolCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"YTSchoolTableViewCell" owner:nil options:nil] lastObject];
}
- (void)setVedio:(YTVedioModel *)vedio
{
    _vedio = vedio;
    
    // 设置图片
    self.coverImageView.layer.borderColor = YTColor(208, 208, 208).CGColor;
    [self.coverImageView imageWithUrlStr:vedio.coverImageUrl phImage:[UIImage imageNamed:@"SchoolBanner"]];
    
    [self.likeBtn setImage:[UIImage imageNamed:@"Likeanxia"] forState:UIControlStateNormal];
    // 设置点赞数量
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%d", vedio.likes] forState:UIControlStateNormal];
    [self.likeBtn sizeToFit];
    
    CGFloat titleW = DeviceWidth - 165 - self.likeBtn.width;
    // 设置标题
    self.titleLable.text = vedio.videoName;
    self.titleConstraint.constant = titleW;
    
    // 设置短标题
    self.shortNameLable.text = vedio.shortName;
    // 设置日期
    self.dateLable.text = vedio.createDate;
}


@end
