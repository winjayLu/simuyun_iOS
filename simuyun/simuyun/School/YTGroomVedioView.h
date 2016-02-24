//
//  YTGroomVedioController.h
//  simuyun
//
//  Created by Luwinjay on 16/1/27.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTVedioModel;

@protocol groomViewDelegate <NSObject>

/**
 *  播放视频
 */
- (void)playVedioWithVedio:(YTVedioModel *)vedio;

/**
 *  打开列表页
 */
- (void)plusList;

@end

@interface YTGroomVedioView : UIView


/**
 *  视频数组
 */
@property (nonatomic, strong) NSArray *vedios;



/**
 *  代理
 */
@property (nonatomic, weak) id<groomViewDelegate> groomDelegate;

- (instancetype)initWithVedios:(NSArray *)vedios;

@end
