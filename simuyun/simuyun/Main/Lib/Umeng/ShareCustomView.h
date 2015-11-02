//
//  ShareCustomView.h
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//
//  自定义分享视图

#import <UIKit/UIKit.h>

@protocol shareCustomDelegate <NSObject>

@required

- (void)shareBtnClickWithIndex:(NSUInteger)tag;

@end

@interface ShareCustomView : UIView

/**
 *   分享按钮类型
 */
typedef enum {
    ShareButtonTypeWxShare, //  微信好友
    ShareButtonTypeWxPyq,//  微信朋友圈
    ShareButtonTypeEmail,//  电子邮件
    ShareButtonTypeSms,//  短信
    ShareButtonTypeCopy,//  复制url
    ShareButtonTypeCancel // 取消
} ShareButtonType;

/**
 *  初始化方法
 *
 *  @param titleArray 所有分享平台的标题
 *  @param NSArray    所有分享平台的图片
 */
- (instancetype)initWithTitleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray;

/**
 *  代理
 */
@property(nonatomic,retain)id <shareCustomDelegate> shareDelegate;

/**
 *  退出分享菜单
 */
- (void)cancelMenu;

@end
