//
//  YTJpushModel.h
//  simuyun
//
//  Created by Luwinjay on 15/11/26.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// 推送消息模型

#import <Foundation/Foundation.h>

@interface YTJpushModel : NSObject

/**
 *  推送类型
 */
@property (nonatomic, copy) NSString *type;

/**
 *  推送标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  推送详情
 */
@property (nonatomic, copy) NSString *detail;


/**
 *  推送图片地址
 */
@property (nonatomic, copy) NSString *imageUrl;

/**
 *  推送跳转地址
 */
@property (nonatomic, copy) NSString *jumpUrl;

@end
