//
//  YTAddMemberCell.m
//  simuyun
//
//  Created by Luwinjay on 16/5/10.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTAddMemberCell.h"
#import "YTMemberModel.h"
#import "UIImageView+SD.h"


@interface YTAddMemberCell()

- (IBAction)selectedBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@property (weak, nonatomic) IBOutlet UIImageView *headImageV;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@end

@implementation YTAddMemberCell

+ (instancetype)addMemberCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"YTAddMemberCell" owner:nil options:nil] lastObject];
}

- (IBAction)selectedBtnClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    [self.addDelegate cellButtonClicked:self.member WithRow:self.row isSelected:sender.selected];
}

- (void)setMember:(YTMemberModel *)member
{
    _member = member;
    [self.selectedBtn setBackgroundColor:[UIColor clearColor]];
    [self.headImageV imageWithUrlStr:member.headImgUrl phImage:[UIImage imageNamed:@""]];
    
    self.selectedBtn.selected = member.isSelected;
    if (member.memo.length > 0) {
        self.nameLable.text = member.memo;
    } else {
        self.nameLable.text = member.nickName;
    }
    self.headImageV.layer.cornerRadius = self.headImageV.width * 0.5;
    self.headImageV.layer.masksToBounds = YES;
    
}




@end
