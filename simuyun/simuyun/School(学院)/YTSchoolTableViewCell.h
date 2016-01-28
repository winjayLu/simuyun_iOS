//
//  YTSchoolTableViewCell.h
//  simuyun
//
//  Created by Luwinjay on 16/1/28.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTVedioModel.h"

@interface YTSchoolTableViewCell : UITableViewCell

/**
 *  封面图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

/**
 *  视频模型
 */
@property (nonatomic, strong) YTVedioModel *vedio;

+ (instancetype)schoolCell;

@end
