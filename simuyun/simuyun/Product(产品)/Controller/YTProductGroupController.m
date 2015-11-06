//
//  YTProductGroupController.m
//  simuyun
//
//  Created by Luwinjay on 15/11/3.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// 产品分类

#import "YTProductGroupController.h"
#import "YTProductViewController.h"
#import "YTUserInfoTool.h"

#define TitleHeight 70
#define ItemMagin 3
#define ItemWidth (DeviceWidth * 0.5 - ItemMagin * 0.5)
// 系列高度
#define GroupHeig (ItemWidth * 2 + 3 + TitleHeight)


@interface YTProductGroupController ()

// 最后一个标题
@property (nonatomic, weak) UIView *lastTitle;

@end

@implementation YTProductGroupController

- (void)loadView
{
    // 将控制器的View替换为ScrollView
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:DeviceBounds];
    mainView.showsVerticalScrollIndicator = NO;
    mainView.contentSize = CGSizeMake(DeviceWidth, GroupHeig * 2 + TitleHeight + ItemWidth );
    self.view = mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品";
    self.view.backgroundColor = YTGrayBackground;
    [MobClick event:@"nav_click" attributes:@{@"按钮" : @"产品"}];
    
    // 名山系列
    self.lastTitle = [self creatTitleImage:0];
    [self creatButtonItem:@[@(ProductItemTypeTaiShan), @(ProductItemTypeHenShan), @(ProductItemTypeSongShan), @(ProductItemTypeHuangShan)]];
    // 大川系列
    self.lastTitle = [self creatTitleImage:1];
    [self creatButtonItem:@[@(ProductItemTypeHuangHe), @(ProductItemTypeChangJiang), @(ProductItemTypeLanCangJiang), @(ProductItemTypeYaMaXun)]];
    
    // 其他
    self.lastTitle = [self creatTitleImage:2];
    
    // 全部产品
    UIButton *button = [[UIButton alloc] init];
    button.tag = ProductItemTypeAll;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"productItem%zd",ProductItemTypeAll]];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *imageHighl = [UIImage imageNamed:[NSString stringWithFormat:@"productItemanxia%zd",ProductItemTypeAll]];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:imageHighl forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, CGRectGetMaxY(self.lastTitle.frame), DeviceWidth, ItemWidth);
    [self.view addSubview:button];

}

// 创建标题
- (UIView *)creatTitleImage:(int)groupIndex
{
    // 标题容器
    UIView *content = [[UIView alloc] init];
    content.frame = CGRectMake(0, groupIndex * GroupHeig, DeviceWidth, TitleHeight);
    content.backgroundColor = YTGrayBackground;

    
    // 标题图片
    UIImageView *titleImage = [[UIImageView alloc] init];
    titleImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"GroupTitle%d",groupIndex + 1]];
    titleImage.size = titleImage.image.size;
    titleImage.center = content.center;
    [self.view addSubview:content];
    [self.view addSubview:titleImage];
    return content;
}


// 创建四个按钮
- (void)creatButtonItem:(NSArray *)itemType
{
    for (int i = 0 ; i < itemType.count; i ++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = [itemType[i] intValue];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        int index = [itemType[i] intValue] ;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"productItem%zd",index]];
        UIImage *imageHighl = [UIImage imageNamed:[NSString stringWithFormat:@"productItemanxia%zd",index]];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:imageHighl forState:UIControlStateHighlighted];
        
        CGFloat itemY = CGRectGetMaxY(self.lastTitle.frame);
        switch (i) {
            case 0:
                button.frame = CGRectMake(0, itemY, ItemWidth, ItemWidth);
                break;
            case 1:
                button.frame = CGRectMake(ItemWidth + ItemMagin, itemY, ItemWidth, ItemWidth);
                break;
            case 2:
                button.frame = CGRectMake(0, itemY + ItemMagin + ItemWidth, ItemWidth, ItemWidth);
                break;
            case 3:
                button.frame = CGRectMake(ItemWidth + ItemMagin, itemY + ItemMagin + ItemWidth, ItemWidth, ItemWidth);
                break;

        }
        [self.view addSubview:button];
    }
}
// 类别点击
- (void)buttonClick:(UIButton *)button
{
    YTProductViewController *productList = [[YTProductViewController alloc] init];
    productList.series = (int)button.tag;
    productList.title = [self titleWithItemType:(int)button.tag];
    productList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:productList animated:YES];
}

// 设置标题
- (NSString *)titleWithItemType:(ProductItemType)type
{
    NSString *title = nil;
    switch (type) {
        case ProductItemTypeTaiShan:
            title = @"泰山系列";
            
            [MobClick event:@"proRecommand_click" attributes:@{@"类型" : @"泰山", @"机构" : [YTUserInfoTool userInfo].organizationName}];
            break;
        case ProductItemTypeHuangShan:
            title = @"黄山系列";
            [MobClick event:@"proRecommand_click" attributes:@{@"类型" : @"黄山", @"机构" : [YTUserInfoTool userInfo].organizationName}];
            break;
        case ProductItemTypeSongShan:
            title = @"嵩山系列";
            [MobClick event:@"proRecommand_click" attributes:@{@"类型" : @"嵩山", @"机构" : [YTUserInfoTool userInfo].organizationName}];
            break;
        case ProductItemTypeHenShan:
            title = @"恒山系列";
            [MobClick event:@"proRecommand_click" attributes:@{@"类型" : @"恒山", @"机构" : [YTUserInfoTool userInfo].organizationName}];
            break;
        case ProductItemTypeHuangHe:
            title = @"黄河系列";
            [MobClick event:@"proRecommand_click" attributes:@{@"类型" : @"黄河", @"机构" : [YTUserInfoTool userInfo].organizationName}];
            break;
        case ProductItemTypeChangJiang:
            title = @"长江系列";
            [MobClick event:@"proRecommand_click" attributes:@{@"类型" : @"长江", @"机构" : [YTUserInfoTool userInfo].organizationName}];
            break;
        case ProductItemTypeLanCangJiang:
            title = @"澜沧江系列";
            [MobClick event:@"proRecommand_click" attributes:@{@"类型" : @"澜沧江", @"机构" : [YTUserInfoTool userInfo].organizationName}];
            break;
        case ProductItemTypeYaMaXun:
            title = @"亚马逊系列";
            [MobClick event:@"proRecommand_click" attributes:@{@"类型" : @"亚马逊", @"机构" : [YTUserInfoTool userInfo].organizationName}];
            break;case ProductItemTypeAll:
            title = @"全部产品";
            [MobClick event:@"proRecommand_click" attributes:@{@"类型" : @"全部", @"机构" : [YTUserInfoTool userInfo].organizationName}];
            break;
    }
    return title;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
