//
//  YTHomeViewController.m
//  simuyun
//
//  Created by Luwinjay on 15/9/28.
//  Copyright © 2015年 winjay. All rights reserved.
//

#import "YTHomeViewController.h"
#import "YTProfileTopView.h"
#import "UIImage+Extend.h"
#import "UINavigationBar+BackgroundColor.h"
#import "UIBarButtonItem+Extension.h"
#import "YTContentView.h"
#import "YTBottomView.h"

@interface YTHomeViewController () <TopViewDelegate>

@property (nonatomic, weak) YTProfileTopView *topView;

@property (nonatomic, weak) YTContentView *todoView;

@property (nonatomic, strong) NSArray *todos;


@end

@implementation YTHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:DeviceBounds];
    mainView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    mainView.bounces = NO;
    mainView.showsVerticalScrollIndicator = NO;
    self.view = mainView;
    self.view.backgroundColor = [UIColor blackColor];
    
#warning todo 获取数据
    
    // 初始化顶部视图
    [self setupTopView];
    
    // 初始化待办事项
    [self setupTodoView];
    
    // 初始化底部菜单
    [self setupBottom];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    // 设置导航栏透明
    UIColor *color = YTColor(255, 255, 255);
    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0.000]];
}

/**
 *  初始化顶部视图
 */
- (void)setupTopView
{
    // 顶部视图
    YTProfileTopView *topView = [YTProfileTopView profileTopView];
    topView.frame = CGRectMake(0, -44, self.view.frame.size.width, 270);
    topView.delegate = self;
    [topView setIconImageWithImage:nil];
    topView.layer.masksToBounds = YES;
    topView.layer.cornerRadius = self.topView.frame.size.width * 0.5;
    topView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    topView.layer.shouldRasterize = YES;
    topView.clipsToBounds = YES;
    [self.view addSubview:topView];
    self.topView = topView;
    // 左边的item
    UIBarButtonItem *left = [UIBarButtonItem itemWithBg:@"chouti" target:self action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = left;
}
/**
 *  初始化待办事项
 */
- (void)setupTodoView
{
    // 计算todoView的高度
    
    CGFloat groupCellHeight = 42;
    CGFloat conetentCellHeight = 56;
    CGFloat todoHeight = groupCellHeight + self.todos.count * conetentCellHeight;
    CGFloat magin = 3;
    
    YTContentView *content = [[YTContentView alloc] init];
    content.frame = CGRectMake(magin, CGRectGetMaxY(self.topView.frame), self.view.width - magin * 2, todoHeight);
    content.layer.cornerRadius = 5;
    content.layer.masksToBounds = YES;
    content.todos = self.todos;
    [self.view addSubview:content];
    self.todoView = content;
}
/**
 *  初始化底部菜单
 */
- (void)setupBottom
{
    CGFloat magin = 3;
    YTBottomView *bottom = [[YTBottomView alloc] init];
    bottom.layer.cornerRadius = 5;
    bottom.layer.masksToBounds = YES;
    bottom.frame = CGRectMake(magin, CGRectGetMaxY(self.todoView.frame) + 8, self.view.width - magin * 2, 42 * 3);
    [self.view addSubview:bottom];
    // 设置滚动范围
    [(UIScrollView *)self.view setContentSize:CGSizeMake(DeviceWidth, CGRectGetMaxY(bottom.frame) + 8)];
}

/**
 *  左侧按钮的点击事件
 */
- (void)leftClick
{
    [self.delegate leftBtnClicked];
}



#pragma mark - topViewDelegate
/**
 *  切换头像
 *
 */
-(void)addPicker:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
}


- (NSArray *)todos
{
    if (!_todos) {
        _todos = @[@"诗酒风流撒娇斐林试剂氨分解",@"孙菲菲撒娇雷锋精神拉法基开了撒家乐福", @"sf氨分解撒浪费精力撒街坊邻居爱上街坊邻居街坊邻居爱上街坊邻居街坊邻居爱上街坊邻居街坊邻居爱上街坊邻居"];
    }
    return _todos;
}




@end
