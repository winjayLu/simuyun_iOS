//
//  YTTeamMemberCell.m
//  simuyun
//
//  Created by Luwinjay on 16/5/6.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTTeamMemberCell.h"
#import "UIImageView+SD.h"
#import "YTMemberModel.h"

@interface YTTeamMemberCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImageV;


@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *joinTimeLable;

@property (weak, nonatomic) IBOutlet UILabel *lastTimeLable;

@property (weak, nonatomic) IBOutlet UIImageView *fatherIconV;

@end


@implementation YTTeamMemberCell


+ (instancetype)memberCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"YTTeamMemberCell" owner:nil options:nil] lastObject];
}

- (void)setMember:(YTMemberModel *)member
{
    _member = member;
    [self.headImageV imageWithUrlStr:member.headImgUrl phImage:[UIImage imageNamed:@"avatar_default_big"]];
    if (member.memo.length > 0) {
        self.titleLable.text = member.memo;
    } else {
        self.titleLable.text = member.nickName;
    }
    if (member.isFather == 0) {
        self.fatherIconV.hidden = YES;
    } else {
        self.fatherIconV.hidden = NO;
    }
    
    self.joinTimeLable.text = [NSString stringWithFormat:@"加入时间:%@", member.joinTeamTime];
    self.lastTimeLable.text = [NSString stringWithFormat:@"最近登录:%@", member.lastLoginTime];
    
    self.headImageV.layer.cornerRadius = self.headImageV.width * 0.5;
    self.headImageV.layer.masksToBounds = YES;
}


@end
