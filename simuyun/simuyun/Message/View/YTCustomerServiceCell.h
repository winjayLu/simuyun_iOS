//
//  YTCustomerServiceCell.h
//  simuyun
//
//  Created by Luwinjay on 15/10/25.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTServiceModel.h"

@interface YTCustomerServiceCell : UITableViewCell

+ (instancetype)CustomerServiceCell;

@property (nonatomic, strong) YTServiceModel *service;
@end
