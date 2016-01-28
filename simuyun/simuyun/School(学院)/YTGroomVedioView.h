//
//  YTGroomVedioController.h
//  simuyun
//
//  Created by Luwinjay on 16/1/27.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTGroomVedioView : UIView

/**
 *  自身高度
 */
@property (nonatomic, assign) CGFloat selfHeight;

/**
 *  视频数组
 */
@property (nonatomic, strong) NSArray *vedios;


- (instancetype)initWithVedios:(NSArray *)vedios;

@end
