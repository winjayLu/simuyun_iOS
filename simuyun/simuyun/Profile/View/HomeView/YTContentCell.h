//
//  YTContentCell.h
//  simuyun
//
//  Created by Luwinjay on 15/10/10.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"


@interface YTContentCell : SWTableViewCell

/**
 *  待办事项标题
 */
@property (nonatomic, copy) NSString *summary;

@end