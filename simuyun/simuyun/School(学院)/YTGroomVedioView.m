//
//  YTGroomVedioController.m
//  simuyun
//
//  Created by Luwinjay on 16/1/27.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTGroomVedioView.h"
#import "YTVedioModel.h"
#import "UIImageView+SD.h"
#import "YTSchoolCollectionCell.h"

@interface YTGroomVedioView()

/**
 *  推荐视频标题栏
 */
@property (nonatomic, weak) UIView *groomView;

@property (nonatomic, assign) CGFloat vedioMaxY;

@end

@implementation YTGroomVedioView


- (instancetype)initWithVedios:(NSArray *)vedios
{
    self = [self init];
    if (self) {
        _vedios = vedios;
        [self setup];
    }
    return self;
}


/**
 *  初始化方法
 */
- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    UIView *titleView =[self setupTitleViewWithTitle:@"推荐视频" tag:20];
    titleView.frame = CGRectMake(0, 0, DeviceWidth, 35);

    // 创建视频模块
    [self groomVedios];
    
    // 创建其它视频标题
    UIView *otherView =[self setupTitleViewWithTitle:@"其他视频" tag:21];
    otherView.frame = CGRectMake(0, self.vedioMaxY, DeviceWidth, 35);
}

- (void)setVedios:(NSArray *)vedios
{
    _vedios = vedios;
    YTSchoolCollectionCell *vedioView = nil;
    for (UIView *view in self.subviews) {
        switch (view.tag) {
            case 1:
            case 2:
            case 3:
            case 4:
                vedioView = (YTSchoolCollectionCell *)view;
                vedioView.vedio = vedios[view.tag];
                break;
            default:
                continue;
        }
    }
}

- (void)groomVedios
{
    CGFloat vedioWidth = (DeviceWidth - 32) * 0.5;
    CGFloat vedioHeight = 146;
    // 右侧的vedioX
    CGFloat vedioX = DeviceWidth - 8 - vedioWidth;
    // 第二行的vedioY
    CGFloat vedioY = CGRectGetMaxY(self.groomView.frame) + 25 + vedioHeight;
    for (int i = 0; i < self.vedios.count; i++) {
        if(i == 0) continue;
        YTSchoolCollectionCell *vedioView = [self createVedioViewWithVedio:self.vedios[i] tag:i];
        switch (i) {
            case 1:
                vedioView.frame = CGRectMake(10, CGRectGetMaxY(self.groomView.frame) + 10, vedioWidth, vedioHeight);
                break;
            case 2:
                vedioView.frame = CGRectMake(vedioX, CGRectGetMaxY(self.groomView.frame) + 10, vedioWidth, vedioHeight);
                break;
            case 3:
                vedioView.frame = CGRectMake(10, vedioY, vedioWidth, vedioHeight);
                break;
            case 4:
                vedioView.frame = CGRectMake(vedioX, vedioY, vedioWidth, vedioHeight);
                self.vedioMaxY = vedioY + vedioHeight + 15;
                break;
        }
    }
}

- (YTSchoolCollectionCell *)createVedioViewWithVedio:(YTVedioModel *)vedio tag:(int)tag
{
    YTSchoolCollectionCell *vedioView = [[YTSchoolCollectionCell alloc] init];
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(vedioClick:)];
    [vedioView addGestureRecognizer:tapGestureRecognizer];
    vedioView.vedio = vedio;
    vedioView.tag = tag;
    [self addSubview:vedioView];
    return vedioView;

}

- (void)vedioClick:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if ([self.groomDelegate respondsToSelector:@selector(playVedioWithVedio:)]) {
        [self.groomDelegate playVedioWithVedio:self.vedios[tapGestureRecognizer.view.tag]];
    }
}

/**
 *  创建视频列表标题栏
 */
- (UIView *)setupTitleViewWithTitle:(NSString *)titleText tag:(int)tag
{
    // 容器
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = YTGrayBackground;
    // 标题栏
    UIView *content = [[UIView alloc] init];
    content.backgroundColor = [UIColor whiteColor];
    content.frame = CGRectMake(0, 10, DeviceWidth, 25);
    [titleView addSubview:content];
    CGFloat magin = 10;
    
    // 竖条图片
    UIImageView *imagView = [[UIImageView alloc] init];
    imagView.image = [UIImage imageNamed:@"shuxian"];
    imagView.frame = CGRectMake(magin, magin, 2, 15);
    [content addSubview:imagView];
    // 标题
    UILabel *title = [[UILabel alloc] init];
    title.text = titleText;
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = YTColor(51, 51, 51);
    [title sizeToFit];
    title.origin = CGPointMake(CGRectGetMaxX(imagView.frame) + 5, imagView.y);
    title.center = CGPointMake(title.center.x, imagView.center.y);
    [content addSubview:title];
    
    [self addSubview:titleView];

    if (tag == 21) { // 其他视频
        // 更多
        UIButton *more = [[UIButton alloc] init];
        [more setTitle:@"更多" forState:UIControlStateNormal];
        [more.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [more setTitleColor:YTColor(102, 102, 102) forState:UIControlStateNormal];
        [more addTarget:self action:@selector(moreClcik) forControlEvents:UIControlEventTouchUpInside];
        more.tag = tag;
        CGFloat moreW = 40;
        more.frame = CGRectMake(DeviceWidth - magin - moreW, imagView.y, moreW, title.height);
        more.center = CGPointMake(more.center.x, title.center.y);
        [content addSubview:more];
    } else {
        self.groomView = titleView;
    }
    return titleView;
}


/**
 *  更多按钮点击
 */
- (void)moreClcik
{
    if ([self.groomDelegate respondsToSelector:@selector(plusList)]) {
        [self.groomDelegate plusList];
    }
}


@end


