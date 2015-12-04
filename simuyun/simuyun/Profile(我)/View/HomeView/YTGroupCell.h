//
//  YTGroupCell.h
//  simuyun
//
//  Created by Luwinjay on 15/10/10.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTGroupCell : UITableViewCell

@property (nonatomic, copy) NSString *title;

/**
 *  跳转的页面
 */
@property (nonatomic, strong) Class pushVc;
@end
