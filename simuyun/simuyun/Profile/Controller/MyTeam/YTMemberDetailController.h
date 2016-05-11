//
//  YTMemberDetailController.h
//  simuyun
//
//  Created by Luwinjay on 16/5/6.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTMemberModel;

@protocol memberDetailDelegate <NSObject>

- (void)removeMember:(YTMemberModel *)member;

@end



@interface YTMemberDetailController : UIViewController

@property (nonatomic, strong) YTMemberModel *member;

@property (nonatomic, weak) id<memberDetailDelegate> delegate;

@end
