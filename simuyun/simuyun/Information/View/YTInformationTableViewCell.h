//
//  YTInformationTableViewCell.h
//  simuyun
//
//  Created by Luwinjay on 15/10/26.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTInformation.h"

@interface YTInformationTableViewCell : UITableViewCell

@property (nonatomic, strong) YTInformation *information;

@property (nonatomic, assign) bool isShowLine;


@end
