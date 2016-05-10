//
//  YTAddMemberController.h
//  simuyun
//
//  Created by Luwinjay on 16/5/9.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol addMemberDelegate <NSObject>

- (void)didSelectedMembers:(NSArray *)members;

@end

@interface YTAddMemberController : UITableViewController

// 所有的成员数组
@property (nonatomic, strong) NSMutableArray *members;


@property (nonatomic, weak) id<addMemberDelegate> addDelegate;

@end
