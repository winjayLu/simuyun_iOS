//
//  YTGroomVedioController.m
//  simuyun
//
//  Created by Luwinjay on 16/1/27.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTGroomVedioView.h"
#import "YTVedioModel.h"

@interface YTGroomVedioView()

/**
 *  推荐视频标题栏
 */
//@property (nonatomic, weak) UILabel *titleLable;
@property (nonatomic, weak) UIView *groomView;

@property (nonatomic, assign) CGFloat vedioMaxY;

@end

@implementation YTGroomVedioView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
    UIView *titleView =[self setupTitleViewWithTitle:@"推荐视频" tag:1];
    titleView.frame = CGRectMake(0, 0, DeviceWidth, 35);
    
    // 创建推荐视频
    [self groomVedioWithVedioArray:@[@"1", @"1", @"1", @"1", @"1",]];
    
    // 创建其它视频标题
    UIView *otherView =[self setupTitleViewWithTitle:@"其他视频" tag:2];
    otherView.frame = CGRectMake(0, self.vedioMaxY, DeviceWidth, 35);
}

- (void)groomVedioWithVedioArray:(NSArray *)array
{
    CGFloat vedioWidth = (DeviceWidth - 32) * 0.5;
    CGFloat vedioHeight = 146;
    // 右侧的vedioX
    CGFloat vedioX = DeviceWidth - 8 - vedioWidth;
    // 第二行的vedioY
    CGFloat vedioY = CGRectGetMaxY(self.groomView.frame) + 25 + vedioHeight;
    for (int i = 0; i < array.count; i++) {
        if(i == 0) continue;
        UIView *vedioView = [self createVedioViewWithVedio:[[YTVedioModel alloc] init]];
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

- (UIView *)createVedioViewWithVedio:(YTVedioModel *)vedio
{
    CGFloat vedioWidth = (DeviceWidth - 32) * 0.5;
    // 容器
    UIView *vedioView = [[UIView alloc] init];
    
    // 图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"SchoolBanner"];
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 1.0f;
    imageView.layer.borderColor = YTColor(208, 208, 208).CGColor;
    imageView.frame = CGRectMake(0, 0, vedioWidth, 96);
    [vedioView addSubview:imageView];
    // 标题
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.text = @"我是标题";
    titleLable.textColor = YTColor(51, 51, 51);
    titleLable.font = [UIFont systemFontOfSize:13];
    [titleLable sizeToFit];
    titleLable.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 5, titleLable.width, titleLable.height);
    [vedioView addSubview:titleLable];
    // 子标题
    UILabel *detailLable = [[UILabel alloc] init];
    detailLable.text = @"聚合财富管理力量！聚合财富管理力量！聚合财富管理力量！聚合财富管理力量！聚合财富管理力量！聚合财富管理力量！聚合财富管理力量！聚合财富管理力量！聚合财富管理力量！聚合财富管理力量！聚合财富管理力量！";
    detailLable.textColor = YTColor(102, 102, 102);
    detailLable.font = [UIFont systemFontOfSize:12];
    detailLable.width = vedioWidth;
    detailLable.numberOfLines = 2;
    [detailLable sizeToFit];
    detailLable.frame = CGRectMake(0, CGRectGetMaxY(titleLable.frame) + 5, detailLable.width, detailLable.height);
    [vedioView addSubview:detailLable];
    [self addSubview:vedioView];
    return vedioView;
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
    title.text = @"推荐视频";
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = YTColor(51, 51, 51);
    [title sizeToFit];
    title.origin = CGPointMake(CGRectGetMaxX(imagView.frame) + 5, imagView.y);
    title.center = CGPointMake(title.center.x, imagView.center.y);
    [content addSubview:title];
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
    [self addSubview:titleView];
    
    if (tag == 1) { // 推荐视频
        self.groomView = titleView;
    }
    return titleView;
}


/**
 *  更多按钮点击
 */
- (void)moreClcik
{
    NSLog(@"更多");
}

@end
