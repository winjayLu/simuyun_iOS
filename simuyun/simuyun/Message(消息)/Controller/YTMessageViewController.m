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
#import "YTTodoListViewController.h"
#import "YTProductNewsController.h"
#import "YTSystemCenterController.h"


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

- (void)viewDidLoad {
    [super viewDidLoad];
    [YTCenter addObserver:self selector:@selector(jump) name:YTJumpToTodoList object:nil];
    
    // 获取是否有新消息
    [self loadNewStatus];
}
/**
 *  获取是否有新消息
 *
 */
- (void)loadNewStatus
{
    self.status = @[@(0), @(1), @(1), @(1)];
//    __weak int i = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateBtn];
    });
}


// 修改按钮
- (void)updateBtn
{
    int i = 0;
    for (UIView *view in self.pagesView.pagesBarView.subviews) {
        if ([view isKindOfClass:[CorePagesBarBtn class]]) {
            BOOL isShow = NO;
            if ([self.status[i]  isEqual: @1]) {
                isShow = YES;
            }
            [(CorePagesBarBtn *)view isShow:isShow];
            i++;
        }
    }

}

- (void)jump
{
    [self.pagesView jumpToPage:1];
}



#pragma mark - lazy
/**
 *  懒加载滑动视图
 *
 */
- (CorePagesView *)pagesView{
    
    if(_pagesView==nil){
        
        YTCloudObserveController *tvc1 = [[YTCloudObserveController alloc] init];
        YTTodoListViewController *tvc2 = [[YTTodoListViewController alloc] init];
        YTProductNewsController *tvc3 = [[YTProductNewsController alloc] init];
        YTSystemCenterController *tvc4 = [[YTSystemCenterController alloc] init];
        
        
        CorePageModel *model1=[CorePageModel model:tvc1 pageBarName:@"消息"];
        CorePageModel *model2=[CorePageModel model:tvc2 pageBarName:@"待办事项"];
        CorePageModel *model3=[CorePageModel model:tvc3 pageBarName:@"产品动态"];
        CorePageModel *model4=[CorePageModel model:tvc4 pageBarName:@"系统通知"];
        
        NSArray *pageModels=@[model1,model2,model3,model4];
        
        
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
