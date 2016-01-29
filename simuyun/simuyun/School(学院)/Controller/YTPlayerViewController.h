//
//  CustomMaskViewController.h
//  TCCloudPlayerSDKTest
//
//  Created by AlexiChen on 15/8/19.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleViewController.h"
#import "YTVedioModel.h"


@protocol vedioLikeDelegate <NSObject>

/**
 *  点赞后修改列表原数据
 */
- (void)likeChangData;

@end

@interface YTPlayerViewController : SimpleViewController

/**
 *  视频模型
 */
@property (nonatomic, strong) YTVedioModel *vedio;

/**
 *  代理
 */
@property (nonatomic, weak) id<vedioLikeDelegate> delegate;

@end
