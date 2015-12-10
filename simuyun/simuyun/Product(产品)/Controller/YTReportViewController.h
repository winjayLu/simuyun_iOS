//
//  YTReportViewController.h
//  simuyun
//
//  Created by Luwinjay on 15/10/21.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// 订单报备

#import <UIKit/UIKit.h>
#import "YTProductModel.h"
#import "YTCusomerModel.h"

@interface YTReportViewController : UIViewController

// 用于调整位置
@property (nonatomic, weak) UIScrollView *scroll;

// 产品模型
@property (nonatomic, strong) YTProductModel *prouctModel;

// 客户模型
@property (nonatomic, strong) YTCusomerModel *cusomerModel;

@end
