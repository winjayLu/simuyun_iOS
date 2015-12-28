//
//  YTSearchProductCell.h
//  simuyun
//
//  Created by Luwinjay on 15/12/28.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTProductModel;

@interface YTSearchProductCell : UITableViewCell

/**
 *  产品模型
 */
@property (nonatomic, strong) YTProductModel *product;

+ (instancetype)productCell;

@end
