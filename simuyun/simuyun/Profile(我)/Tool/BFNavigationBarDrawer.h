//
//  BFNavigationBarDrawer.h
//  BFNavigationBarDrawer
//
//  Created by Balázs Faludi on 04.03.14.
//  Copyright (c) 2014 Balazs Faludi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

/**
 *   按钮类型
 */
typedef enum {
    btnTypeQuanBu,      // 全部
    btnTypeDaiBaoBei,   // 待报备
    btnTypeQueRenZhong, // 确认中
    btnTypeYiQueRen,    // 已确认
    btnTypeYiShiXiao    // 已失效
    
} btnType;

@protocol BarDrawerDelegate <NSObject>

- (void)selectedBtnWithType:(btnType)btnType;

@end

@interface BFNavigationBarDrawer : UIView

@property (nonatomic, assign) BOOL isYiQueRen;


@property (nonatomic, readonly, getter=isVisible) BOOL visible;
@property (nonatomic) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *buttons;

@property (nonatomic, weak) id<BarDrawerDelegate> delegate;

- (void)showFromNavigationBar:(UINavigationBar *)bar animated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;

- (instancetype)initWithisYiQueRen:(BOOL)isYiQueRen;

@end
