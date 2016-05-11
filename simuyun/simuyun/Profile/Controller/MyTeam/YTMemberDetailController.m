//
//  YTMemberDetailController.m
//  simuyun
//
//  Created by Luwinjay on 16/5/6.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTMemberDetailController.h"
#import "YTMemberModel.h"
#import "UIImage+Extend.h"
#import "UIImageView+SD.h"
#import "YTConversationController.h"
#import "YTAccountTool.h"
#import "YTUpdateMemoController.h"

@interface YTMemberDetailController () <updateMemoDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UIImageView *headImageV;

@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

@property (weak, nonatomic) IBOutlet UIButton *memoBtn;

@property (weak, nonatomic) IBOutlet UIButton *chatBtn;

@property (weak, nonatomic) IBOutlet UIButton *moveTeamBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

- (IBAction)chatBtnClick:(UIButton *)sender;

- (IBAction)moveTeamClick:(UIButton *)sender;

- (IBAction)phonClick:(UIButton *)sender;

- (IBAction)memoClick:(UIButton *)sender;

@end

@implementation YTMemberDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置按钮背景图片及圆角
    [self.chatBtn setBackgroundImage:[UIImage imageWithColor:YTColor(91, 168, 243)] forState:UIControlStateNormal];
    [self.chatBtn setBackgroundImage:[UIImage imageWithColor:YTColor(65, 133, 197)] forState:UIControlStateHighlighted];
    [self.moveTeamBtn setBackgroundImage:[UIImage imageWithColor:YTNavBackground] forState:UIControlStateNormal];
    [self.moveTeamBtn setBackgroundImage:[UIImage imageWithColor:YTColor(210, 36, 20)] forState:UIControlStateHighlighted];
    self.chatBtn.layer.cornerRadius = 5;
    self.chatBtn.layer.masksToBounds = YES;
    self.moveTeamBtn.layer.cornerRadius = 5;
    self.moveTeamBtn.layer.masksToBounds = YES;
    self.headImageV.layer.cornerRadius = self.headImageV.width * 0.5;
    self.headImageV.layer.masksToBounds = YES;
    
    // 设置数据
#warning 缺少占位图片
    [self.headImageV imageWithUrlStr:self.member.headImgUrl phImage:[UIImage imageNamed:@""]];
    self.nameLable.text = self.member.nickName;
    [self.phoneBtn setTitle:self.member.phoneNum forState:UIControlStateNormal];
    [self.memoBtn setTitle:self.member.memo forState:UIControlStateNormal];
    if (self.member.memo.length > 0) {
        self.title = self.member.memo;
    } else {
        self.title = self.member.nickName;
    }
    
    // 推荐人
    if (self.member.isFather == 1) {
        self.moveTeamBtn.hidden = YES;
        self.bottomConstraint.constant = -self.moveTeamBtn.height;
    }
}


/**
 *  对话
 *
 */
- (IBAction)chatBtnClick:(UIButton *)sender {
    
    //新建一个聊天会话View Controller对象
    YTConversationController *chat = [[YTConversationController alloc]init];
    chat.conversationType = ConversationType_PRIVATE;
    chat.targetId = self.member.adviserId;
    chat.title = self.title;
    chat.displayUserNameInCell = NO;
    [chat setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    [chat setMessagePortraitSize:CGSizeMake(37, 37)];
    chat.userId = [YTAccountTool account].userId;
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
}

/**
 *  移出团队
 *
 */
- (IBAction)moveTeamClick:(UIButton *)sender {
#warning 待调用接口
}

/**
 *  拨打电话
 *
 */
- (IBAction)phonClick:(UIButton *)sender {
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.member.phoneNum]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}
/**
 *  修改备注
 *
 */
- (IBAction)memoClick:(UIButton *)sender {
    YTUpdateMemoController *update = [[YTUpdateMemoController alloc] init];
    update.member = self.member;
    update.updateDelegate = self;
    [self.navigationController pushViewController:update animated:YES];
}

/**
 *  备注修改成功
 */
- (void)updateMemoSuccess
{
    [self.memoBtn setTitle:self.member.memo forState:UIControlStateNormal];
    
#warning 发送通知刷新列表
    
}

@end
