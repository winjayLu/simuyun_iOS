//
//  YTMessageViewController.m
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//

#import "YTMessageViewController.h"
#import "CorePagesView.h"
#import "YTCloudObserveController.h"
#import "YTHttpTool.h"
#import "CorePagesBarBtn.h"
#import "YTProductNewsController.h"
#import "YTSystemCenterController.h"
#import "YTAccountTool.h"
#import "YTMessageNumTool.h"
#import "YTOperationCenterController.h"
#import "CoreArchive.h"


@interface YTMessageViewController ()

@property (nonatomic, weak) CorePagesView *pagesView;

// 分类消息的状态
@property (nonatomic, strong) NSArray *status;

@end

@implementation YTMessageViewController

- (void)loadView
{
    self.view = self.pagesView;
}
static UIWindow *_window;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YTGrayBackground;
    // 监听客服消息数字变化
    [YTCenter addObserver:self selector:@selector(loadNewStatus) name:YTUpdateChatContent object:nil];
    [MobClick event:@"nav_click" attributes:@{@"按钮" : @"消息"}];
    
    // 新手指引
    if ([CoreArchive strForKey:@"firstMessage"] == nil && [CoreArchive strForKey:@"firstMessage"].length == 0) {
        _window = [[UIWindow alloc] initWithFrame:DeviceBounds];
        _window.backgroundColor = [UIColor clearColor];
        [_window makeKeyAndVisible];
        
        [CoreArchive setStr:@"firstMessage" key:@"firstMessage"];
        UIButton *newGuidelines = [[UIButton alloc] initWithFrame:_window.bounds];
        newGuidelines.backgroundColor = [UIColor clearColor];
        [newGuidelines setBackgroundImage:[UIImage imageNamed:@"xiaoxizhiyin"] forState:UIControlStateNormal];
        [newGuidelines addTarget:self action:@selector(newGuidelinesClick:) forControlEvents:UIControlEventTouchUpInside];
        [_window addSubview:newGuidelines];
    }
    
}
/**
 *  新特性指引
 *
 */
- (void)newGuidelinesClick:(UIButton *)newGuidelines
{
    [newGuidelines removeFromSuperview];
    _window.hidden = YES;
    _window = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 获取是否有新消息
    [self loadNewStatus];
}

/**
 *  获取是否有新消息
 *
 */
- (void)loadNewStatus
{
    // 消息数量
    YTMessageNum *messageNum = [YTMessageNumTool messageNum];
    
    self.status = @[@(messageNum.unreadNoticeNum), @(messageNum.unreadProductNum), @(messageNum.unreadGoodNewsNum), @(messageNum.unreadTalkNum)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self updateBtn];
    });
}


// 修改按钮
- (void)updateBtn
{
    int i = 0;
    for (UIView *view in self.pagesView.pagesBarView.subviews) {
        if ([view isKindOfClass:[CorePagesBarBtn class]]) {
            BOOL isShow = YES;
            if ([self.status[i]  isEqual: @0]) {
                isShow = NO;
            }
            [(CorePagesBarBtn *)view isShow:isShow];
            i++;
        }
    }
}



#pragma mark - lazy
/**
 *  懒加载滑动视图
 *
 */
- (CorePagesView *)pagesView{
    
    if(_pagesView==nil){
        
        YTCloudObserveController *tvc1 = [[YTCloudObserveController alloc] init];
        tvc1.superVc = self;
        YTOperationCenterController *tvc2 = [[YTOperationCenterController alloc] init];
        YTProductNewsController *tvc3 = [[YTProductNewsController alloc] init];
        YTSystemCenterController *tvc4 = [[YTSystemCenterController alloc] init];
        
        CorePageModel *model1=[CorePageModel model:tvc2 pageBarName:@"运营公告"];
        CorePageModel *model2=[CorePageModel model:tvc3 pageBarName:@"产品动态"];
        CorePageModel *model3=[CorePageModel model:tvc4 pageBarName:@"营销喜报"];
        CorePageModel *model4=[CorePageModel model:tvc1 pageBarName:@"客服消息"];
        NSArray *pageModels=@[model1, model2, model3,model4];
        
        
        //自定义配置
        CorePagesViewConfig *config = [[CorePagesViewConfig alloc] init];
        config.barBtnFontPoint = 12;
        config.barBtnWidth = DeviceWidth * 0.25;
        config.barScrollMargin = 0;
        config.barBtnMargin = 0;
        config.mainViewMargin = 0;
        config.barBtnExtraWidth = 0;
        config.barLineViewPadding = 0;
        config.barViewH = 34;
        config.isBarBtnUseCustomWidth = YES;
        
        
        _pagesView=[CorePagesView viewWithOwnerVC:self pageModels:pageModels config:config];
    }
    
    return _pagesView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [YTCenter removeObserver:self];
}
@end
