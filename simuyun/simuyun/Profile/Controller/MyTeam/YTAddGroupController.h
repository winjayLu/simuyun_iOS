//
//  YTAddGroupController.h
//  simuyun
//
//  Created by Luwinjay on 16/5/9.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTGroupModel;


@interface YTAddGroupController : UIViewController

/**
 *  组模型
 *  编辑组时有值
 *  新建组时没有
 */
@property (nonatomic, strong) YTGroupModel *groupModel;

/**
 *  是否是编辑组
 */
@property (nonatomic, assign) BOOL isEdit;

// 所有的成员数组
@property (nonatomic, strong) NSMutableArray *members;

// 选中的成员数组
@property (nonatomic, strong) NSMutableArray *selectedMembers;

@end
