//
//  YTReportTopView.h
//  simuyun
//
//  Created by Luwinjay on 15/11/24.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTProductModel.h"

@interface YTReportTopView : UIView

// 产品模型
@property (nonatomic, strong) YTProductModel *prouctModel;

+ (instancetype)reportTopView;

@end
