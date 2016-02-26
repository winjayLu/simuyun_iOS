//
//  YTHotProductCell.h
//  simuyun
//
//  Created by Luwinjay on 16/2/26.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTProductModel.h"

@interface YTHotProductCell : UITableViewCell
/**
 *  产品模型
 */
@property (nonatomic, strong) YTProductModel *product;

+ (instancetype)hotProductCell;

@end
