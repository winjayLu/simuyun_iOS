//
//  YTStockItem.h
//  simuyun
//
//  Created by Luwinjay on 15/10/16.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTStockModel.h"

@interface YTStockItem : UIView

/**
 *  数据模型
 */
@property (nonatomic, strong) YTStockModel *stockModel;

+ (instancetype)stockItem;
@end
