//
//  YTTodoViewCell.h
//  simuyun
//
//  Created by Luwinjay on 15/10/31.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// 待办事项

#import <UIKit/UIKit.h>
#import "YTMessageModel.h"
#import "SWTableViewCell.h"

@interface YTTodoViewCell : SWTableViewCell

+ (instancetype)todoCell;

// 消息
@property (nonatomic, strong) YTMessageModel *message;

@end
