//
//  YTOrderCenterController.h
//  simuyun
//
//  Created by Luwinjay on 15/10/23.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFNavigationBarDrawer.h"

@interface YTOrderCenterController : UITableViewController


/**
 *  已选则分类status
 */
@property (nonatomic, copy) NSString *status;

/**
 *  是否显示完成订单
 */
@property (nonatomic, assign) BOOL isYiQueRen;




@end
