//
//  YTTeamMemberCell.h
//  simuyun
//
//  Created by Luwinjay on 16/5/6.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@class YTMemberModel;

@interface YTTeamMemberCell : SWTableViewCell

+ (instancetype)memberCell;

@property (nonatomic, strong) YTMemberModel *member;

@end
