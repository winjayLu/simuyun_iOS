//
//  YTNormalWebController.h
//  simuyun
//
//  Created by Luwinjay on 15/10/29.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTMessageModel.h"

@interface YTMessageDetailController : UIViewController
/**
 *  网页的url地址
 */
@property (nonatomic, copy) NSString *url;


/**
 *  页面标题
 */
@property (nonatomic, copy) NSString *toTitle;
/**
 *  分享图片名称
 */
@property (nonatomic, copy) NSString *shareImageName;


// 是否加时间戳
@property (nonatomic, assign) BOOL isDate;

// 消息模型
@property (nonatomic, strong) YTMessageModel *message;



+ (instancetype)webWithTitle:(NSString *)title url:(NSString *)url;
@end
