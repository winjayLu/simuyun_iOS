//
//  YTLoginViewController.m
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//

#import "YTLoginViewController.h"
#import "UMSocial.h"
#import "UMSocialDataService.h"
#import "UMSocialWechatHandler.h"

@interface YTLoginViewController ()

/**
 *  微信登陆按钮点击
 */
@property (weak, nonatomic) IBOutlet UIButton *weChatButton;
- (IBAction)weChatClick:(id)sender;

@end

@implementation YTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  对未安装的用户隐藏微信登录按钮，只提供其他登录方式（比如手机号注册登录、游客登录等）
     */
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)weChatClick:(id)sender {
    // 请求字典
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    //  友盟微信登录
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            // 授权成功
            YTLog(@"snsAccount is %@",response);
        }
    });
    
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
        // 进入到微信
//        YTLog(@"SnsInformation is %@",response.data);
        NSLog(@"%@",response);
    }];

}


@end
