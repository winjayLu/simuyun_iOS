//
//  YTTeamGroupCell.h
//  simuyun
//
//  Created by Luwinjay on 16/5/6.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTGroupModel;

@interface YTTeamGroupCell : UITableViewCell

+ (instancetype)groupCell;

@property (nonatomic, strong) YTGroupModel *group;

@end
