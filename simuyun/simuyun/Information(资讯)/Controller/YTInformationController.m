//
//  YTInformationController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/26.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTInformationController.h"
#import "CorePagesView.h"
#import "YTIndustryViewController.h"
#import "YTObservationController.h"
#import "YTOpinionController.h"
#import "YTKnowController.h"
#import "UIImage+Extend.h"

@interface YTInformationController ()

@property (nonatomic, weak) CorePagesView *pagesView;

@end

@implementation YTInformationController

- (void)loadView
{
    self.view = self.pagesView;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"资讯中心";
    self.view.backgroundColor = YTGrayBackground;
}

#pragma mark - lazy
/**
 *  懒加载滑动视图
 *
 */
- (CorePagesView *)pagesView{
    
    if(_pagesView==nil){
        
        YTIndustryViewController *tvc1 = [[YTIndustryViewController alloc] init];
        YTObservationController *tvc2 = [[YTObservationController alloc] init];
        YTOpinionController *tvc3 = [[YTOpinionController alloc] init];
        YTKnowController *tvc4 = [[YTKnowController alloc] init];
        
        CorePageModel *model1=[CorePageModel model:tvc1 pageBarName:@"行业资讯"];
        CorePageModel *model2=[CorePageModel model:tvc2 pageBarName:@"云观察"];
        CorePageModel *model3=[CorePageModel model:tvc3 pageBarName:@"云视点"];
        CorePageModel *model4=[CorePageModel model:tvc4 pageBarName:@"早知道"];
        
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


@end
