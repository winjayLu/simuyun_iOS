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
#import "YTOrderCenterController.h"
#import "YTBlackAlertView.h"
#import "YTInformationController.h"
#import "YTTabBarController.h"
#import "YTAccountTool.h"
#import "YTAuthenticationViewController.h"
#import "YTAuthenticationStatusController.h"

@interface YTHomeViewController () <TopViewDelegate, ContentViewDelegate, BottomViewDelegate>

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
    } else
    {
        self.topView.userInfo = [YTUserInfoTool userInfo];
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
    bottom.BottomDelegate = self;
    [self.view addSubview:bottom];
    // 设置滚动范围
    [(UIScrollView *)self.view setContentSize:CGSizeMake(DeviceWidth, CGRectGetMaxY(bottom.frame) + 3)];
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
    UIViewController *vc = nil;
    // 判断点击了哪个按钮
    if ([btnTitle isEqualToString:@"用户资料"]) {
        vc = [[YTOtherViewController alloc] init];
    } else if([btnTitle isEqualToString:@"关联微信"]){
        vc = [[YTOtherViewController alloc] init];
    } else if([btnTitle isEqualToString:@"邮寄地址"]){
        vc = [[YTOtherViewController alloc] init];
    } else if([btnTitle isEqualToString:@"推荐私募云给好友"]){
        vc = [[YTOtherViewController alloc] init];
    } else if([btnTitle isEqualToString:@"帮助"]){
        vc = [[YTOtherViewController alloc] init];
    } else if([btnTitle isEqualToString:@"关于私募云"]){
        vc = [[YTOtherViewController alloc] init];
    } else if([btnTitle isEqualToString:@"400-188-8848"]){
        UIWebView*callWebview =[[UIWebView alloc] init];
        NSURL *telURL =[NSURL URLWithString:@"tel://400-188-8848"];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.view addSubview:callWebview];
    }
    // 调用代理方法
    if ([self.delegate respondsToSelector:@selector(leftMenuClicked)]) {
        [self.delegate leftMenuClicked];
    }
    // 跳转对应控制器
    if (vc != nil) {
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:NO];
    }
}
/**
 *  待办事项选中事件
 *
 */
- (void)selectedTodo:(NSUInteger)row
{
    UIViewController *vc = nil;
    if (row == 0) {
        // 获取根控制器
        [YTCenter postNotificationName:YTJumpToTodoList object:nil];
        YTTabBarController *appRootVC = (YTTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [appRootVC setSelectedIndex:0];
    } else {
        vc = [[YTOtherViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:NO];
    }
}
/**
 *  底部菜单选中
 *
 */
- (void)didSelectedRow:(int)row
{
    YTOrderCenterController *order = [[YTOrderCenterController alloc] init];
    order.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:order animated:NO];
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
}
/**
 *  按钮点击事件
 *
 *  @param type 按钮类型
 */
- (void)topBtnClicked:(TopButtonType)type
{
    NSLog(@"%zd", type);
    UIViewController *pushVc = nil;
    YTBlackAlertView *alert = [YTBlackAlertView shared];
    switch (type) {
        case TopButtonTypeRenzhen:  // 认证
            [self Authentication];
            break;
        case TopButtonTypeQiandao:  // 签到
            [self signIn];
            break;
        case TopButtonTypeYundou:   // 云豆
            
            break;
        case TopButtonTypeKehu:     // 客户

            break;
        case TopButtonTypeDindan:   // 订单
            pushVc = [[YTOrderCenterController alloc] init];
            
            break;
        case TopButtonTypeYeji:     // 业绩
            [alert showAlertWithTitle:@"sjladljasdlj" detail:@"sdjlksafljaaaaaaaaaaaaaaaaaaaaaaaaaaaaakkfslkfjkdsjfljdskfdskljjfljdsljf"];
            
            break;
    }
    // 跳转对应控制器
    pushVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pushVc animated:YES];
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
#warning 修改了侧滑手势
//    [self.navigationController pushViewController:pushVc animated:NO];
}
/**
 *  签到
 *
 */
- (void)signIn
{
    YTBlackAlertView *alert = [YTBlackAlertView shared];
    // 发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"adviserId"] = [YTAccountTool account].userId;
    [YTHttpTool post:YTSignIn params:params success:^(id responseObject) {
        // 修改数据

        YTUserInfo *userInfo = [YTUserInfoTool userInfo];
        userInfo.isSingIn = 1;
        NSLog(@"%@",responseObject);
        userInfo.myPoint = (int)responseObject[@"totalPoint"];
        [YTUserInfoTool saveUserInfo:userInfo];
        self.topView.userInfo = userInfo;
        // 资讯id
        NSString *infoId = responseObject[@"infoId"];
        // 弹出提醒
        [alert showAlertSignWithTitle:responseObject[@"infoTitle"] date:responseObject[@"signInDate"] yunDou:(int)responseObject[@"todayPoint"] block:^{
            if (infoId != nil && infoId.length > 0) {
                YTOtherViewController *other = [[YTOtherViewController alloc] init];
                other.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:other animated:NO];
            }
        }];
    } failure:^(NSError *error) {
        
    }];
}
/**
 *  认证
 *
 */
- (void)Authentication
{
#warning TODO 判断状态
    if([YTUserInfoTool userInfo].adviserStatus == 1)
    {
        YTAuthenticationViewController *authen = [[YTAuthenticationViewController alloc] init];
        authen.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:authen animated:NO];
    } else if ([YTUserInfoTool userInfo].adviserStatus == 2)
    {
    
    }
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
