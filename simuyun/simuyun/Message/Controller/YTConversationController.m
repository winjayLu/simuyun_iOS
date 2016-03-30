//
//  YTConversationController.m
//  simuyun
//
//  Created by Luwinjay on 16/3/30.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTConversationController.h"


@interface YTConversationController ()

@end

@implementation YTConversationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.conversationMessageCollectionView.backgroundColor = YTGrayBackground;
    
    [self.pluginBoardView removeItemAtIndex:2];
}


- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell
                   atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isMemberOfClass:[RCTextMessageCell class]]) {
        RCTextMessageCell *textCell = (RCTextMessageCell *)cell;

        RCMessageModel *model = textCell.model;
        if ([model.senderUserId isEqualToString:self.userId]) {
            textCell.textLabel.textColor=[UIColor whiteColor];
        } else {
            textCell.textLabel.textColor=YTColor(51, 51, 51);
        }
        textCell.textLabel.attributeDictionary=@{
                                               @(NSTextCheckingTypeLink) : @{NSForegroundColorAttributeName : [UIColor redColor]},
                                               @(NSTextCheckingTypePhoneNumber) : @{NSForegroundColorAttributeName : [UIColor redColor]}
                                               };
        
    }
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
