//
//  YTUpdateMemoController.h
//  simuyun
//
//  Created by Luwinjay on 16/5/6.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTMemberModel;

@protocol updateMemoDelegate <NSObject>

- (void)updateMemoSuccess;

@end

@interface YTUpdateMemoController : UIViewController

@property (nonatomic, strong) YTMemberModel *member;


@property (nonatomic, weak) id<updateMemoDelegate> updateDelegate;
@end
