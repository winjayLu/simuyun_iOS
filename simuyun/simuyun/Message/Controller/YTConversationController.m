//
//  YTConversationController.m
//  simuyun
//
//  Created by Luwinjay on 16/3/30.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTConversationController.h"
#import "UIBarButtonItem+Extension.h"
#import "CoreArchive.h"


@interface YTConversationController ()

@end

@implementation YTConversationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.conversationMessageCollectionView.backgroundColor = YTGrayBackground;
    
    [self.pluginBoardView removeItemAtIndex:2];
    
    // 拨打电话按钮
    if (self.isMobile)
    {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithBg:@"mobelPhone" highBg:nil target:self action:@selector(mobileClick)];
    }
}

// 拨打电话
- (void)mobileClick
{
    NSString *phoneNumber = nil;
    if ([self.targetId isEqualToString:CustomerService]) {
       phoneNumber = @"tel://400-188-8848";
    } else {
        phoneNumber = [NSString stringWithFormat:@"tel://%@", [CoreArchive strForKey:@"managerMobile"]];
    }
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:phoneNumber];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}


- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell
                   atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isMemberOfClass:[RCTextMessageCell class]]) {
        RCTextMessageCell *textCell = (RCTextMessageCell *)cell;

        RCMessageModel *model = textCell.model;
        if ([model.senderUserId isEqualToString:self.userId]) {
            textCell.textLabel.textColor=[UIColor whiteColor];
            textCell.textLabel.attributeDictionary=@{
                                                     @(NSTextCheckingTypeLink) : @{NSForegroundColorAttributeName : YTColor(255, 240, 1)},
                                                     @(NSTextCheckingTypePhoneNumber) : @{NSForegroundColorAttributeName : YTColor(255, 240, 1)}
                                                     };
        } else {
            textCell.textLabel.textColor=YTColor(51, 51, 51);
            textCell.textLabel.attributeDictionary=@{
                                                     @(NSTextCheckingTypeLink) : @{NSForegroundColorAttributeName : YTNavBackground},
                                                     @(NSTextCheckingTypePhoneNumber) : @{NSForegroundColorAttributeName : YTNavBackground}
                                                     };
        }
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [YTCenter postNotificationName:YTUpdateUnreadCount object:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
