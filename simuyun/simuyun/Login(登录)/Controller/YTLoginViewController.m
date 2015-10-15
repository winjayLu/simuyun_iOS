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
#import "YTTabBarController.h"
#import "CALayer+Transition.h"
#import "NSString+Password.h"
#import "SVProgressHUD.h"

@interface YTLoginViewController ()

/**
 *  微信按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *weChatButton;

/**
 *  微信登录单击事件
 */
- (IBAction)weChatClick:(id)sender;

/**
 *  登录按钮单击事件
 *
 */
- (IBAction)loginClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

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

/**
 *  微信登录单击事件
 */
- (IBAction)weChatClick:(id)sender {

    
    //  友盟微信登录
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *account = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            // 授权成功
            YTLog(@"snsAccount is %@",account);
            [self transitionTabBarVC];
        }
    });
    
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
        // 进入到微信
        YTLog(@"SnsInformation is %@",response.data);
        NSLog(@"%@",response);
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
    
}

/**
 *  登录按钮单击事件
 *
 */
- (IBAction)loginClick:(UIButton *)sender {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"username"] = self.userName.text;
    dict[@"password"] = [NSString md5:self.passWord.text];
    [YTHttpTool post:YTSession params:dict success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [self transitionTabBarVC];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"用户名或密码不正确"];
    }];
}
/**
 *  转场到主界面
 */
- (void)transitionTabBarVC
{
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    mainWindow.rootViewController = [[YTTabBarController alloc] init];
    [mainWindow.layer transitionWithAnimType:TransitionAnimTypeCube subType:TransitionSubtypesFromRight curve:TransitionCurveEaseOut duration:0.75f];
//    [mainWindow.layer transitionWithAnimType:TransitionAnimTypeReveal subType:TransitionSubtypesFromRight curve:TransitionCurveEaseIn duration:0.75f];
}




@end
