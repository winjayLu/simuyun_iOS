//
//  YTConsultView.h
//  simuyun
//
//  Created by Luwinjay on 15/10/19.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTNewest.h"

@protocol ConsultViewDelegate <NSObject>

/**
 *  选中的资讯
 *
 */
- (void)selectedCellWithRow:(YTNewest *)newest;

@end

@interface YTConsultView : UITableView

/**
 *  咨询列表
 */
@property (nonatomic, strong) NSArray *newests;

@property (nonatomic, weak) id<ConsultViewDelegate> consultDelegate;


@end
