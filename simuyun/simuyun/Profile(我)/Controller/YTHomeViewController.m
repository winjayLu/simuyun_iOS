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
#import "YTOtherViewController.h"
#import "YTUserInfoTool.h"
#import "SVProgressHUD.h"

@interface YTHomeViewController () <TopViewDelegate, ContentViewDelegate>

/**
 *  顶部视图
 */
@property (nonatomic, weak) YTProfileTopView *topView;

/**
 *  待办事项
 */
@property (nonatomic, weak) YTContentView *todoView;

/**
 *  待办事项数据
 */
@property (nonatomic, strong) NSArray *todos;


@end

@implementation YTHomeViewController


- (void)loadView
{
    // 将控制器的View替换为ScrollView
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:DeviceBounds];
    mainView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    mainView.bounces = NO;
    mainView.showsVerticalScrollIndicator = NO;
    self.view = mainView;
    self.view.backgroundColor = YTViewBackground;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化顶部视图
    [self setupTopView];
    
    // 初始化待办事项
    [self setupTodoView];
    
    // 初始化底部菜单
    [self setupBottom];
    
    // 监听左侧菜单通知
    [self leftMenuNotification];
    
    // 获取用户信息
    if ([YTUserInfoTool userInfo] == nil) {
        [SVProgressHUD showWithStatus:@"正在加载" maskType:SVProgressHUDMaskTypeClear];
        [YTUserInfoTool loadUserInfoWithresult:^(BOOL result) {
            if (result) {
                [SVProgressHUD dismiss];
                self.topView.userInfo = [YTUserInfoTool userInfo];
            } else {
                [SVProgressHUD showErrorWithStatus:@"请检查您的网络链接"];
            }
        }];
    }
}


#pragma mark - 初始化
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
    content.daili = self;
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
    [(UIScrollView *)self.view setContentSize:CGSizeMake(DeviceWidth, CGRectGetMaxY(bottom.frame))];
}

#pragma makr - 监听通知
/**
 *  监听左侧菜单通知
 */
- (void)leftMenuNotification
{
    [YTCenter addObserver:self selector:@selector(leftMenuClick:) name:YTLeftMenuNotification object:nil];

}


#pragma mark - 响应事件
/**
 *  左侧菜单选中事件
 *
 */
- (void)leftMenuClick:(NSNotification *)note
{
    NSString *btnTitle = note.userInfo[YTLeftMenuSelectBtn];
    YTLog(@"%@",btnTitle);
    // 判断点击了哪个按钮
    if ([btnTitle isEqualToString:@"用户资料"]) {
        
    } else if([btnTitle isEqualToString:@"关联微信"]){
        
    } else if([btnTitle isEqualToString:@"邮寄地址"]){
        
    } else if([btnTitle isEqualToString:@"推荐私募云给好友"]){
        
    } else if([btnTitle isEqualToString:@"帮助"]){
        
    } else if([btnTitle isEqualToString:@"关于私募云"]){
        
    } else {
        
    }
    // 调用代理方法
    if ([self.delegate respondsToSelector:@selector(leftMenuClicked)]) {
        [self.delegate leftMenuClicked];
    }
    // 跳转对应控制器
    YTOtherViewController *other = [[YTOtherViewController alloc] init];
    other.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:other animated:NO];
    

}
/**
 *  待办事项选中事件
 *
 */
- (void)selectedTodo:(NSUInteger)row
{
    YTLog(@"%zd", row);
    // 跳转对应控制器
    YTOtherViewController *other = [[YTOtherViewController alloc] init];

    [self.navigationController pushViewController:other animated:YES];

}


/**
 *  导航栏左侧按钮的点击事件
 */
- (void)leftClick
{
    [self.delegate leftBtnClicked];
}



#pragma mark - 顶部视图代理方法
/**
 *  切换头像
 *
 */
-(void)addPicker:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
}
/**
 *  按钮点击事件
 *
 *  @param type 按钮类型
 */
- (void)topBtnClicked:(TopButtonType)type
{
    NSLog(@"%zd", type);
    switch (type) {
        case TopButtonTypeRenzhen:  // 认证
            
            break;
        case TopButtonTypeQiandao:  // 签到
            
            break;
        case TopButtonTypeYundou:   // 云豆
            
            break;
        case TopButtonTypeKehu:     // 客户
            
            break;
        case TopButtonTypeDindan:   // 订单
            
            break;
        case TopButtonTypeYeji:     // 业绩
            
            break;
    }
    // 跳转对应控制器
    YTOtherViewController *other = [[YTOtherViewController alloc] init];
    other.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:other animated:YES];
}


#pragma mark - 获取数据

#pragma mark - 懒加载
- (NSArray *)todos
{
    if (!_todos) {
        _todos = @[@"诗酒风流撒娇斐林试剂氨分解",@"孙菲菲撒娇雷锋精神拉法基开了撒家乐福法基开了撒家乐福法基开了撒家乐福法基开了撒家乐福法基开了撒家乐福法基开了撒家乐福法基开了撒家乐福", @"sf氨分解撒浪费精力撒街坊邻居爱上街坊邻居街坊邻居爱上街坊邻居街坊邻居爱上街坊邻居街坊邻居爱上街坊邻居"];
    }
    return _todos;
}


- (void)dealloc
{
    [YTCenter removeObserver:self];
}

@end
