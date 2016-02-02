//
//  ShareManage.m
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//
//  分享平台管理工具类


#import "ShareManage.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "WXApi.h"
#import <MessageUI/MessageUI.h>
#import "YTTabBarController.h"


@interface ShareManage() <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate, UMSocialUIDelegate>

/**
 *  邮件控制器
 */
@property (nonatomic, strong) MFMailComposeViewController *mailVc;

@end

@implementation ShareManage {
    UIViewController *_viewC;
}

#pragma mark 新浪微博分享
/**
 *  下个版本考虑
 */
//- (void)wbShareWithViewControll:(UIViewController *)viewC
//{
//    _viewC = viewC;
//    [[UMSocialControllerService defaultControllerService] setShareText:share_content shareImage:nil socialUIDelegate:nil];
//    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
//}


static ShareManage *shareManage;

+ (ShareManage *)shareManage
{
    @synchronized(self)
    {
        if (shareManage == nil) {
            shareManage = [[self alloc] init];
        }
        return shareManage;
    }
}

#pragma mark 注册友盟分享微信
- (void)shareConfig
{
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppKey];
    [UMSocialData openLog:NO];
    // 关闭分享提示
    [UMSocialConfig setFinishToastIsHidden:YES  position:UMSocialiToastPositionCenter];
    //注册微信
    [WXApi registerApp:WXAppID];
    //设置图文分享
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
}

#pragma mark 微信分享
- (void)wxShareWithViewControll:(UIViewController *)viewC
{
    _viewC = viewC;
    //  设置内容和图片
    [[UMSocialControllerService defaultControllerService] setShareText:self.share_content shareImage:self.share_image socialUIDelegate:self];
    //  设置标题
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.share_title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.share_title;
    //  设置url
    [UMSocialWechatHandler setWXAppId:WXAppID appSecret:WXAppSecret url:self.share_url];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
}

- (void)hiddenFloatMenu
{
    // 隐藏悬浮按钮
    UIWindow *keyWindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            keyWindow = window;
            break;
        }
    }
    UIViewController *appRootVC = keyWindow.rootViewController;
    if ([appRootVC isKindOfClass:[YTTabBarController class]]) {
        YTTabBarController *tabBar = ((YTTabBarController *)appRootVC);
        tabBar.floatView.boardWindow.hidden = YES;
    }
}

- (void)showFloatMenu
{
    UIWindow *keyWindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            keyWindow = window;
            break;
        }
    }
    UIViewController *appRootVC = keyWindow.rootViewController;
    if ([appRootVC isKindOfClass:[YTTabBarController class]]) {
        YTTabBarController *tabBar = ((YTTabBarController *)appRootVC);
        tabBar.floatView.boardWindow.hidden = NO;
    }
}

#pragma mark 微信朋友圈分享
- (void)wxpyqShareWithViewControll:(UIViewController *)viewC
{
    _viewC = viewC;
    //  设置内容和图片
    [[UMSocialControllerService defaultControllerService] setShareText:self.share_content shareImage:self.share_image socialUIDelegate:self];
    //  设置标题
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.share_title;
    //  设置url
    [UMSocialWechatHandler setWXAppId:WXAppID appSecret:WXAppSecret url:self.share_url];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
}


#pragma mark 邮件分享
- (void)displayEmailComposerSheet:(UIViewController *)vc
{
    [self hiddenFloatMenu];
    _viewC = vc;
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail]) {
        mailPicker.mailComposeDelegate = self;
        self.mailVc = mailPicker;
        //设置主题
        [mailPicker setSubject:self.share_title];
//        // 添加一张图片
//        UIImage *addPic = [UIImage imageNamed: @"maillogo"];
//        NSData *imageData = UIImagePNGRepresentation(addPic);
//        [mailPicker addAttachmentData: imageData mimeType: @"image/png" fileName: @"Icon.png"];
        // 设置正文
        NSString *emailBody = nil;
        if (self.bankNumber.length > 0) {
            emailBody = self.bankNumber;
        } else {
            emailBody =[NSString stringWithFormat:@"%@\n%@",self.share_title, self.share_url];
        }
        [mailPicker setMessageBody:emailBody isHTML:YES];
        [_viewC presentViewController:mailPicker animated:YES completion:nil];
    }
}
/**
 *  发送邮件代理方法
 */
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    [self showFloatMenu];
    [controller dismissViewControllerAnimated:YES completion:nil];
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"邮件未发送";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            break;
    }
    YTLog(@"%@",msg);
}

#pragma mark 短信分享
- (void)smsShareWithViewControll:(UIViewController *)viewC
{
    _viewC = viewC;
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        }
        else {
            // @"设备没有短信功能"
        }
    }
}
- (void)displaySMSComposerSheet
{
    [self hiddenFloatMenu];
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.navigationBar.tintColor = [UIColor blackColor];
    if (self.bankNumber.length > 0) {
        picker.body = self.bankNumber;
    } else {
        picker.body = [NSString stringWithFormat:@"%@\n%@",self.share_title,self.share_url];
    }
    [_viewC presentViewController:picker animated:YES completion:nil];
}

#pragma mark 短信的代理方法
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self showFloatMenu];
    [_viewC dismissViewControllerAnimated:YES completion:nil];
    switch (result)
    {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultSent:
            // 分享成功
            break;
        case MessageComposeResultFailed:
            break;
        default:
            break;
    }
}
/**
 *  分享完成的回掉方法
 */
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
        [self showFloatMenu];
//    if (response.responseCode == UMSResponseCodeSuccess) {
//        [MBProgressHUD showSuccess:@"分享成功"];
//        
//    } else
//    {
//        [MBProgressHUD showError:@"分享失败"];
//    }
    
}


@end
