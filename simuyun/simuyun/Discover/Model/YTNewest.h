//
//  YTNewest.h
//  simuyun
//
//  Created by Luwinjay on 15/10/26.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTNewest : NSObject


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

// 图片地址
@property (nonatomic, copy) NSString *url;



@end
