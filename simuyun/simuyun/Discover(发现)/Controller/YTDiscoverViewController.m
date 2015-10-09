//
//  YTDiscoverViewController.m
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//

#import "YTDiscoverViewController.h"
#import "CorePPTVC.h"
#import "CoreStatus.h"
#import "YTWebViewController.h"


@interface YTDiscoverViewController ()
@end

@implementation YTDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YTRandomColor;
    
    
    [self getAdvertise];
    
    PPTModel *pptModel1 = [[PPTModel alloc] init];
    pptModel1.image = [UIImage imageNamed:@"1"];
    
    
    PPTModel *pptModel2 = [[PPTModel alloc] init];
    pptModel2.image = [UIImage imageNamed:@"2"];
    
    
    PPTModel *pptModel3 = [[PPTModel alloc] init];
    pptModel3.image = [UIImage imageNamed:@"1"];
    
    
    PPTModel *pptModel4 = [[PPTModel alloc] init];
    pptModel4.image = [UIImage imageNamed:@"2"];
    
    
    PPTModel *pptModel5 = [[PPTModel alloc] init];
    pptModel5.image = [UIImage imageNamed:@"1"];
    
    PPTModel *pptModel6 = [[PPTModel alloc] init];
    pptModel6.image = [UIImage imageNamed:@"2"];
    
    
    
    
//    NSArray *pptModels = @[pptModel1,pptModel2,pptModel3,pptModel4,pptModel5,pptModel6];
//    
//    
//    CorePPTVC *pptvc = [[CorePPTVC alloc] init];
//    pptvc.pptModels = pptModels;
    //传递数据
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //            pptvc.pptModels = @[pptModel1,pptModel2,pptModel5];
    //        });
    //    });
    //
    //
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(16.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        pptvc.pptModels = pptModels;
    //    });
    
    
   
    
}
/**
 *  初始化轮播图片
 */
- (void)setupPPTVC
{
    CorePPTVC *pptvc = [[CorePPTVC alloc] init];
    pptvc.view.frame = CGRectMake(0, 0, DeviceWidth, 260);

    [self addChildViewController:pptvc];
    [self.view addSubview:pptvc.view];
    pptvc.pptItemClickBlock = ^(PPTModel *pptModel){
        [self pptVcClick:pptModel.extension_url];
    };
}

/**
 *  轮播图片的点击事件
 *
 *  @param toUrl 跳转的地址
 */
- (void)pptVcClick:(NSString *)toUrl
{
    YTWebViewController *webView = [[YTWebViewController alloc] init];
    webView.url = toUrl;
    
    [self.navigationController pushViewController:webView animated:YES];
}





/**
 *  获取广告位
 */
- (void)getAdvertise
{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"method"] = @"getAdvertise";
    dict[@"os"] = @"ios";
    dict[@"advisers_id"] = @"00a8f3d0792646c6935b6dd86dd6ef7f";
    
    [YTHttpTool post:YTServer params:[NSDictionary httpWithDictionary:dict] success:^(NSDictionary *responseObject) {
        
        YTLog(@"%@",responseObject);
        YTLog(@"ss");
    } failure:^(NSError *error) {
        NSLog(@"qq");
        YTLog(@"%@",error);
        YTLog(@"sserror");
    }];
    //https://intime.simuyun.com/api/interface/?method=checkVersion&param[insver]=0001&param[os]=ios-appstore
    //result	__NSCFString *	@"https://182.92.217.186:6060/api/interface/api"	0x00007f9b862101d0
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
