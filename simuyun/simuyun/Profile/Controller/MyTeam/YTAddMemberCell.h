//
//  YTAddMemberCell.h
//  simuyun
//
//  Created by Luwinjay on 16/5/10.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTMemberModel;

@protocol AddMemberDelegate <NSObject>


//按钮选中/取消
-(void)cellButtonClicked:(YTMemberModel *)member WithRow:(NSInteger)row isSelected:(BOOL)isSelected;

@end

@interface YTAddMemberCell : UITableViewCell

+ (instancetype)addMemberCell;

@property (nonatomic, strong) YTMemberModel *member;

@property (nonatomic, weak) id<AddMemberDelegate> addDelegate;

@property (nonatomic, assign) NSUInteger row;

@end
