//
//  YTGroupDetailController.h
//  simuyun
//
//  Created by Luwinjay on 16/5/10.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTGroupModel;

@interface YTGroupDetailController : UITableViewController

// 团队成员数组
@property (nonatomic, strong) YTGroupModel *group;

// 团队所有成员数组
@property (nonatomic, strong) NSArray *members;

@end
