//
//  YTServiceModel.h
//  simuyun
//
//  Created by Luwinjay on 15/11/1.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// 客服模型

#import <Foundation/Foundation.h>

@interface YTServiceModel : NSObject

// 客服消息内容
@property (nonatomic, copy) NSString *content;

// 消息创建时间
@property (nonatomic, copy) NSString *create_time;

// 本次请求时间
@property (nonatomic, copy) NSString *lastTimestamp;



@end
