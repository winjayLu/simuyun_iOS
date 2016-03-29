//
//  YTCloudListController.m
//  simuyun
//
//  Created by Luwinjay on 16/3/29.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

// 聊天列表界面

#import "YTCloudListController.h"

@interface YTCloudListController ()

@end

@implementation YTCloudListController


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 1.AppDelegate 中初始化融云SDK
 2.用户信息接口中获取融云Token
 3.TabBarController 中登录融云SDK
 
 
 */
@end
