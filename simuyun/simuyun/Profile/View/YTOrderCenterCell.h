//
//  YTOrderCenterCell.h
//  simuyun
//
//  Created by Luwinjay on 15/10/23.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOrderCenterModel.h"

@interface YTOrderCenterCell : UITableViewCell
+ (instancetype)orderCenterCell;
@property (nonatomic, strong) YTOrderCenterModel *order;
@end
