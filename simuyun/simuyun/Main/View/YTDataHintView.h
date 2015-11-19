//
//  YTDataHintView.h
//  simuyun
//
//  Created by Luwinjay on 15/11/19.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^refreshButton)();

/**
 *  内容类型
 */
typedef enum {
    contentTypeLoading,   //  加载中
    contentTypeNull,      //  没有数据
    contentTypeFailure,   //  加载失败
    contentTypeSuccess    //  加载成功
} contentType;


@interface YTDataHintView : UIView
/**
 *  显示加载中
 *
 */
- (void)showLoadingWithInView:(UITableView *)inView center:(CGPoint)center;

/**
 *  显示加载中
 *
 */
- (void)showLoadingWithInView:(UIView *)inView tableView:(UITableView *)tableView center:(CGPoint)center;

/**
 *  根据数据改变显示内容
 *
 */
- (void)changeContentTypeWith:(NSArray *)data;

/**
 *  根据数据改变显示内容
 *
 */
- (void)ContentFailure;

/**
 *  切换显示内容
 *
 */
- (void)switchContentTypeWIthType:(contentType)type;


/**
 *  加载后是否删除
 */
@property (nonatomic, assign) BOOL isRemove;



@end
