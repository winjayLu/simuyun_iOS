//
//  YTLeftMenu.h
//  simuyun
//
//  Created by Luwinjay on 15/10/10.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTUserInfoTool.h"

@interface YTLeftMenu : UIView

+ (instancetype)leftMenu;

/**
 *  用户信息
 */
@property (nonatomic, strong) YTUserInfo *userInfo;


@end
