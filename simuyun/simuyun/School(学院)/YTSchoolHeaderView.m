//
//  YTSchoolHeaderView.m
//  simuyun
//
//  Created by Luwinjay on 16/1/27.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTSchoolHeaderView.h"
#import "UIButton+SD.h"


@interface YTSchoolHeaderView()

/**
 *  顶部视频banner
 */
@property (nonatomic, weak) UIButton *bannerBtn;
/**
 *  标题lable
 */
@property (nonatomic, weak) UILabel *titleLable;

@end

@implementation YTSchoolHeaderView

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
    // 顶部推荐视频
    UIButton *hotVideo = [[UIButton alloc] init];
    hotVideo.frame = CGRectMake(0, 0, DeviceWidth,  DeviceWidth * 0.5625);
//    [hotVideo setBackgroundImage:[UIImage imageNamed:@"SchoolBanner"] forState:UIControlStateNormal];
    [self addSubview:hotVideo];
    self.bannerBtn = hotVideo;
    
    // 推荐视频标题容器
    UIView *titleContent = [[UIView alloc] init];
    CGFloat contentHeight = 20;
    titleContent.frame = CGRectMake(0, hotVideo.height - contentHeight, DeviceWidth, contentHeight);
    titleContent.backgroundColor = YTRGBA(0, 0, 0, 0.4);
    [self addSubview:titleContent];
    
    // 推荐视频标题
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(10, 0, titleContent.width, contentHeight);
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:14];
    [titleContent addSubview:title];
    self.titleLable = title;
    
    // 创建分类按钮
    CGFloat categoryBtnW = (DeviceWidth - 35) * 0.25;
    // 产品培训
    UIButton *produt = [self createCategoryButtonWithTitle:@"产品培训" imageName:@"cppx" highliImage:@"cppxanxia" tag:0 width:categoryBtnW];
    produt.origin = CGPointMake(10, CGRectGetMaxY(hotVideo.frame));
    // 财富前沿
    UIButton *wealth = [self createCategoryButtonWithTitle:@"财富前沿" imageName:@"xyld" highliImage:@"xyldanxia" tag:1 width:categoryBtnW];
    wealth.origin = CGPointMake(CGRectGetMaxX(produt.frame) + 5, produt.y);
    // 管理培训
    UIButton *sale = [self createCategoryButtonWithTitle:@"管理培训" imageName:@"xsjq" highliImage:@"xsjqanxia" tag:2 width:categoryBtnW];
    sale.origin = CGPointMake(CGRectGetMaxX(wealth.frame) + 5, produt.y);
    // 金融知识
    UIButton *know = [self createCategoryButtonWithTitle:@"管理培训" imageName:@"glpx" highliImage:@"glpxanxia" tag:3 width:categoryBtnW];
    know.origin = CGPointMake(CGRectGetMaxX(sale.frame) + 5, produt.y);
    
}

/**
 *  创建视频分类按钮
 *
 */
- (UIButton *)createCategoryButtonWithTitle:(NSString *)title imageName:(NSString *)imageName highliImage:(NSString *)highliImage tag:(int)tag width:(CGFloat)width
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//button的类型
    button.tag = tag;
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highliImage] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:11];//title字体大小
    button.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    [button setTitleColor:YTColor(102, 102, 102) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(categoryClick:) forControlEvents:UIControlEventTouchUpInside];
    
    button.size = CGSizeMake(width, width - 10);
    button.contentEdgeInsets = UIEdgeInsetsMake(-20,0,0,0);
    CGFloat imageMaginLeft = (width - button.currentImage.size.width) * 0.5;
    button.imageEdgeInsets = UIEdgeInsetsMake(0,imageMaginLeft,0,imageMaginLeft);
    
    button.titleEdgeInsets = UIEdgeInsetsMake(65, -button.currentImage.size.width, 0, 0);
    [self addSubview:button];
    return button;
}

- (void)setVedio:(YTVedioModel *)vedio
{
    self.titleLable.text = vedio.shortName;
    if (vedio.image) {
        [self.bannerBtn setImage:vedio.image forState:UIControlStateNormal];
        return;
    }
    [self.bannerBtn imageWithUrlStr:vedio.coverImageUrl phImage:[UIImage imageNamed:@"SchoolBanner"]];
}

/**
 *  分类按钮点击
 */
- (void)categoryClick:(UIButton *)btn
{
    NSLog(@"%zd", btn.tag);
}


@end
