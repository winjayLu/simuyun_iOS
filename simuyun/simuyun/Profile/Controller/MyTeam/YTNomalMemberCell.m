//
//  YTNomalMemberCell.m
//  simuyun
//
//  Created by Luwinjay on 16/5/10.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTNomalMemberCell.h"
#import "YTMemberModel.h"
#import "UIImageView+SD.h"

@interface YTNomalMemberCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@end

@implementation YTNomalMemberCell


+ (instancetype)nomalMemberCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"YTNomalMemberCell" owner:nil options:nil] lastObject];
}

- (void)setMember:(YTMemberModel *)member
{
    _member = member;
    [self.headImageV imageWithUrlStr:member.headImgUrl phImage:[UIImage imageNamed:@""]];
    
    if (member.memo.length > 0) {
        self.nameLable.text = member.memo;
    } else {
        self.nameLable.text = member.nickName;
    }
    self.headImageV.layer.cornerRadius = self.headImageV.width * 0.5;
    self.headImageV.layer.masksToBounds = YES;
}

@end
