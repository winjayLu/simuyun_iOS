//
//  YTMessageModel.h
//  simuyun
//
//  Created by Luwinjay on 15/11/1.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTMessageModel : NSObject

// 消息ID
@property (nonatomic, copy) NSString *messageId;

// 标题
@property (nonatomic, copy) NSString *title;

// 摘要
@property (nonatomic, copy) NSString *summary;


// 已读/未读  0:未读  1:已读
@property (nonatomic, assign) int readFlg;

// 二级分类
@property (nonatomic, assign) int category2Code;

// 字符串
@property (nonatomic, copy) NSString *createDate;


// 本次请求取得时间
@property (nonatomic, copy) NSString *lastTimestamp;


@end
