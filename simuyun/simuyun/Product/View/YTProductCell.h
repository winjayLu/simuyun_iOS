//
//  YTProductCell.h
//  simuyun
//
//  Created by Luwinjay on 15/10/15.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTProductModel.h"

@interface YTProductCell : UITableViewCell

/**
 *  产品模型
 */
@property (nonatomic, strong) YTProductModel *product;

+ (instancetype)productCell;

@end
