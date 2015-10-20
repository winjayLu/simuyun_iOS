//
//  YTColorConfig.h
//  simuyun
//
//  Created by Luwinjay on 15/10/5.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

/** 颜色 */


#ifndef YTColorConfig_h
#define YTColorConfig_h


//  RGB颜色
#define YTColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//  RGBA颜色
#define YTRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//  随机色
#define YTRandomColor YTColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))


// 导航栏背景    215,58,46
#define YTNavBackground YTColor(215, 58, 46)
// 导航栏文字颜色
#define YTNavTextColor [UIColor whiteColor]
// 导航返回按钮颜色
#define YTNavBackColor [UIColor whiteColor]


// TabBar背景颜色
#define YTTabBarBackground YTColor(232, 233, 232)
// TabBar选中时的文字颜色
#define YTTabBarSelectedColor YTColor(215, 58, 46)
// TabBar普通时候的文字颜色
#define YTTabBarNormalColor [UIColor blackColor]


// 界面黑色背景
#define YTViewBackground YTColor(51, 51, 51)

// 界面灰色背景
#define YTGrayBackground YTColor(246, 246, 246)




#endif /* YTColorConfig_h */
