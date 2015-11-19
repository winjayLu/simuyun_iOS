//
//  YTDataHintView.m
//  simuyun
//
//  Created by Luwinjay on 15/11/19.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTDataHintView.h"
#import "MJRefresh.h"

@interface YTDataHintView()

@property (nonatomic, copy) refreshButton refreshBlock;

/**
 *  加载中视图
 */
@property (nonatomic, strong) UIImageView *loadingView;


/**
 *  没有数据视图
 */
@property (nonatomic, strong) UIImageView *nullDataView;

/**
 *  加载失败
 */
@property (nonatomic, strong) UIButton *failureView;

/**
 *  当前的父视图
 */
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation YTDataHintView

/**
 *  显示加载中
 *
 */
- (void)showLoadingWithInView:(UITableView *)inView center:(CGPoint)center
{
//    _refreshBlock = block;
    self.size = CGSizeMake(160, 160);
    if (center.x == 0) {
        self.center = CGPointMake(inView.width * 0.5, inView.height * 0.5);
    } else {
        self.center = center;
    }
    [self addSubview:self.loadingView];
    [inView addSubview:self];
    self.tableView = inView;
}

/**
 *  显示加载中
 *
 */
- (void)showLoadingWithInView:(UIView *)inView tableView:(UITableView *)tableView center:(CGPoint)center
{
    self.size = CGSizeMake(160, 160);
    if (center.x == 0) {
        self.center = CGPointMake(inView.width * 0.5, inView.height * 0.5);
    } else {
        self.center = center;
    }
    [self addSubview:self.loadingView];
    [inView addSubview:self];
    self.tableView = tableView;
}


/**
 *  切换显示内容
 *
 */
- (void)switchContentTypeWIthType:(contentType)type
{
    // 删除所有子控件
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    switch (type) {
        case contentTypeLoading:
            [self addSubview:self.loadingView];
            break;
        case contentTypeNull:
            [self addSubview:self.nullDataView];
            break;
        case contentTypeFailure:
            [self addSubview:self.failureView];
            break;
        case contentTypeSuccess:
            self.failureView = nil;
            self.loadingView = nil;
            self.nullDataView = nil;
            if (!self.isRemove) {
                [self removeFromSuperview];
            }
            break;
    }
}

- (void)changeContentTypeWith:(NSArray *)data
{
    if (data.count > 0) {
        [self switchContentTypeWIthType:contentTypeSuccess];
    } else {
        [self switchContentTypeWIthType:contentTypeNull];
    }
}

/**
 *  根据数据改变显示内容
 *
 */
- (void)ContentFailure
{
    [self switchContentTypeWIthType:contentTypeFailure];
}

/**
 *  重新加载
 */
- (void)failureClick
{
    if (self.tableView != nil && self.tableView.header != nil) {
        [self.tableView.header beginRefreshing];
    }
    [self switchContentTypeWIthType:contentTypeLoading];
}

- (void)dealloc
{

}

#pragma mark - lazy

- (UIImageView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[UIImageView alloc] init];
        _loadingView.image = [UIImage imageNamed:@"jiazaizhong"];
        _loadingView.frame = self.bounds;
    }
    return _loadingView;
}

- (UIImageView *)nullDataView
{
    if (!_nullDataView) {
        _nullDataView = [[UIImageView alloc] init];
        _nullDataView.image = [UIImage imageNamed:@"kong"];
        _nullDataView.frame = self.bounds;
    }
    return _nullDataView;
}

- (UIButton *)failureView
{
    if (!_failureView) {
        _failureView = [[UIButton alloc] init];
        [_failureView setBackgroundImage:[UIImage imageNamed:@"loadStatusError"] forState:UIControlStateNormal];
        [_failureView addTarget:self action:@selector(failureClick) forControlEvents:UIControlEventTouchUpInside];
        _failureView.frame = self.bounds;
    }
    return _failureView;
}





@end
