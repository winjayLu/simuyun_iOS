//
//  YTInformation.h
//  simuyun
//
//  Created by Luwinjay on 15/10/26.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTInformation : NSObject

/**
 *  资讯id
 */
@property (nonatomic, copy) NSString *infoId;
/**
 *  资讯标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  资讯摘要
 */
@property (nonatomic, copy) NSString *summary;
/**
 *  点赞数
 */
@property (nonatomic, copy) NSString *likes;
/**
 *  是否显示new的标签
 */
@property (nonatomic, copy) NSString *newlabel;

// 日期
@property (nonatomic, copy) NSString *date;

// 下载地址
@property (nonatomic, copy) NSString *url;

/**
 *  资讯分类
 */
@property (nonatomic, assign) int category;



@end
