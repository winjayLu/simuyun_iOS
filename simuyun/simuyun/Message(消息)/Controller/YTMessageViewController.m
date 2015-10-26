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


@interface YTMessageViewController ()

@property (nonatomic, weak) CorePagesView *pagesView;
@end

@implementation YTMessageViewController

- (void)loadView
{
    self.view = self.pagesView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [YTCenter addObserver:self selector:@selector(jump) name:YTJumpToTodoList object:nil];
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
        YTCloudObserveController *tvc2 = [[YTCloudObserveController alloc] init];
        YTCloudObserveController *tvc3 = [[YTCloudObserveController alloc] init];
        YTCloudObserveController *tvc4 = [[YTCloudObserveController alloc] init];
        
        
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
