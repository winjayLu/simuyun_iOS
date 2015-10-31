//
//  YTTodoViewCell.h
//  simuyun
//
//  Created by Luwinjay on 15/10/31.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// 待办事项

#import <UIKit/UIKit.h>

@interface YTTodoViewCell : UITableViewCell

+ (instancetype)todoCell;

@property (nonatomic, copy) NSString *imageName;

@end
