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
#define YTRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
//  随机色
#define YTRandomColor YTColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))




#endif /* YTColorConfig_h */
