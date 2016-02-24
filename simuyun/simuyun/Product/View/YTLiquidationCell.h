//
//  YTLiquidationCell.h
//  simuyun
//
//  Created by Luwinjay on 15/12/9.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTProductModel.h"

/**
 *  已清算产品
 */

@interface YTLiquidationCell : UITableViewCell

/**
 *  产品模型
 */
@property (nonatomic, strong) YTProductModel *product;

+ (instancetype)productCell;

@end
