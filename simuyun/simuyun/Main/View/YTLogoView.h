//
//  YTLogoView.h
//  simuyun
//
//  Created by Luwinjay on 15/10/6.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YTLogoViewDelegate <NSObject>

@optional

// 切换到Profile控制器
- (void)logoViewDidSelectProfileItem;
@end


@interface YTLogoView : UIView

@property (nonatomic, weak) id<YTLogoViewDelegate> delegate;

/**
 *  云荐按钮图片
 */
@property (nonatomic, strong) UIImage *logoImage;

@end
