//
//  YTResources.h
//  simuyun
//
//  Created by Luwinjay on 15/10/21.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTResources : NSObject

/**
 *  欢迎图片地址
 */
@property (nonatomic, copy) NSString *appWelcomeImg;

// appstroe开关
// 0 隐藏  1 显示
@property (nonatomic, assign) int versionFlag;

// 新版本内容
@property (nonatomic, copy) NSString *adverts;

// 下载地址
@property (nonatomic, copy) NSString *downUrl;

// 是否强制更新
@property (nonatomic, copy) NSString *isMustUpdate;

// 版本号
@property (nonatomic, copy) NSString *version;


@end
