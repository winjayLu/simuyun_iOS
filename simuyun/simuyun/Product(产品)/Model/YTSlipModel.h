//
//  YTSlipModel.h
//  simuyun
//
//  Created by Luwinjay on 15/10/28.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTSlipModel : NSObject
/**
 *  文件名
 *
 */
@property (nonatomic, copy) NSString *original;
/**
 *  文件类型
 *
 */
@property (nonatomic, copy) NSString *type;
/**
 *  文件地址
 *
 */
@property (nonatomic, copy) NSString *url;
/**
 *  附件类型
 *
 */
@property (nonatomic, copy) NSString *annex_type;


@end
