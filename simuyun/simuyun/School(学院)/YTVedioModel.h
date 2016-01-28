//
//  YTVedioModel.h
//  simuyun
//
//  Created by Luwinjay on 16/1/27.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTVedioModel : NSObject

/**
 *  高清地址
 */
@property (nonatomic, copy) NSString *HDVideoUrl;

/**
 *  标清地址
 */
@property (nonatomic, copy) NSString *SDVideoUrl;

/**
 *  封面图片地址
 */
@property (nonatomic, copy) NSString *coverImageUrl;

/**
 *  视频创建日期
 */
@property (nonatomic, copy) NSString *createDate;

/**
 *  是否点过赞
 *  0没有，1点过
 */
@property (nonatomic, assign) int isLiked;

/**
 *  点赞数量
 */
@property (nonatomic, assign) int likes;

/**
 *  视频短标题
 */
@property (nonatomic, copy) NSString *shortName;

/**
 *  视频对应的腾讯id
 */
@property (nonatomic, copy) NSString *tencentVideoId;

/**
 *  视频对应自己后台的id
 */
@property (nonatomic, copy) NSString *videoId;

/**
 *  视频标题
 */
@property (nonatomic, copy) NSString *videoName;

/**
 *  假数据图片
 */
@property (nonatomic, strong) UIImage *image;

/**
 *  视频描述
 */
@property (nonatomic, copy) NSString *videoSummary;

- (instancetype)initWithTitle:(NSString *)title image:(NSString *)image shortName:(NSString *)shortName;

@end
