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
    ProductItemTypeTaiShan,   //  泰山
    ProductItemTypeHuangShan,   // 黄山
    ProductItemTypeSongShan,    // 嵩山
    ProductItemTypeHenShan,     // 衡山
    ProductItemTypeHuangHe,     // 黄河
    ProductItemTypeChangJiang,  // 长江
    ProductItemTypeLanCangJiang,    // 澜沧江
    ProductItemTypeYaMaXun,     // 亚马逊
    ProductItemTypeAll  // 全部产品
} ProductItemType;



@interface YTProductGroupController : UIViewController

@end
