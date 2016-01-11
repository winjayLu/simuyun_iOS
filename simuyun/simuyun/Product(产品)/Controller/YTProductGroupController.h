//
//  YTProductGroupController.h
//  simuyun
//
//  Created by Luwinjay on 15/11/3.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// 产品分类

#import <UIKit/UIKit.h>

/**
 *   产品分类类型
 */
typedef enum {
    ProductItemTypeTaiShan = 1,   //  泰山
    ProductItemTypeHuangShan = 2,   // 黄山
    ProductItemTypeHenShan = 3,     // 衡山
    ProductItemTypeSongShan = 4,    // 嵩山
    ProductItemTypeChangJiang = 5,  // 长江
    ProductItemTypeHuangHe = 6,     // 黄河
    ProductItemTypeLanCangJiang = 7,    // 澜沧江
    ProductItemTypeYaMaXun = 8,     // 亚马逊
    ProductItemTypeAll = 0 // 全部产品
} ProductItemType;



@interface YTProductGroupController : UIViewController

@end
