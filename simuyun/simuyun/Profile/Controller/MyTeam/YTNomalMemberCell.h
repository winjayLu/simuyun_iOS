//
//  YTNomalMemberCell.h
//  simuyun
//
//  Created by Luwinjay on 16/5/10.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTMemberModel;

@interface YTNomalMemberCell : UITableViewCell


+ (instancetype)nomalMemberCell;

@property (nonatomic, strong) YTMemberModel *member;

@end
