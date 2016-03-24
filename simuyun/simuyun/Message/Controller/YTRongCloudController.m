//
//  YTRongCloudController.m
//  simuyun
//
//  Created by Luwinjay on 16/3/23.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTRongCloudController.h"
#import <RongIMKit/RongIMKit.h>

@interface YTRongCloudController ()

@end

@implementation YTRongCloudController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[RCIM sharedRCIM] initWithAppKey:@"tdrvipksrbgn5"];
    
    [[RCIM sharedRCIM] connectWithToken:@"UO+YUszUvQiMmL1gfgTNR2iFZ82izPgGx/14T5ZrkrWPLqd87z1pDlKO9bw7WSlwR2P6hz6vxWe0H/UuHBgqOR0r57XbNOLOuDswa5xDazQZD5pfNhAW5Aj5ZYrWYvDs93zvldjQG7g=" success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%zd", status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
