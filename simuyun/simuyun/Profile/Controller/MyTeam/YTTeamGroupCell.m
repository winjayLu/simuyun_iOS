//
//  YTTeamGroupCell.m
//  simuyun
//
//  Created by Luwinjay on 16/5/6.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTTeamGroupCell.h"
#import "YTGroupModel.h"
#import "YTMemberModel.h"

@interface YTTeamGroupCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImageV;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *detailLable;

@end

@implementation YTTeamGroupCell


+ (instancetype)groupCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"YTTeamGroupCell" owner:nil options:nil] lastObject];
}

- (void)setGroup:(YTGroupModel *)group
{
    _group = group;
    self.titleLable.text = [NSString stringWithFormat:@"%@（%zd）", group.groupName, group.members.count];
    NSMutableString *temp = [NSMutableString string];
    for (int i = 0; i < group.members.count; i++) {
        YTMemberModel *member = group.members[i];
        if (i == 0) {
            [temp appendString:member.nickName];
        } else if(i > 20) {
            break;
        }else {
            [temp appendString:[NSString stringWithFormat:@",%@", member.nickName]];
        }
    }
    self.detailLable.text = temp;
    self.headImageV.layer.cornerRadius = self.headImageV.width * 0.5;
}


@end
