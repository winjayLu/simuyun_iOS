//
//  YTContentView.h
//  simuyun
//
//  Created by Luwinjay on 15/10/10.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ContentViewDelegate <NSObject>

@optional

/**
 *  选中待办事项
 *
 */
- (void)selectedTodo:(NSUInteger)row;
// 传递待办事项模型
//- (void)selectedTodo:(YTTodoModel *)todo;

@end

@interface YTContentView : UITableView

/**
 *  代理
 */
@property (nonatomic, weak) id<ContentViewDelegate> daili;

/**
 *  待办事项
 */
@property (nonatomic, strong) NSArray *todos;

@end
