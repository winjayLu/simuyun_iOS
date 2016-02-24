//
//  YTSchoolHeaderView.h
//  simuyun
//
//  Created by Luwinjay on 16/1/27.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTVedioModel.h"

@protocol headerViewDelegate <NSObject>

/**
 *  播放视频
 */
- (void)playVedio:(YTVedioModel *)vedio;

/**
 *  打开列表页
 */
- (void)plusVedioList:(NSString *)type;

@end

@interface YTSchoolHeaderView : UIView


/**
 *  视频模型
 */
@property (nonatomic, strong) YTVedioModel *vedio;

/**
 *  代理
 */
@property (nonatomic, weak) id<headerViewDelegate> headerDelegate;

@end
