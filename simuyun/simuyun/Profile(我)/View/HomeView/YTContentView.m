//
//  YTContentView.m
//  simuyun
//
//  Created by Luwinjay on 15/10/10.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// Profile中间的待办事项

#import "YTContentView.h"
#import "YTGroupCell.h"
#import "YTContentCell.h"


@interface YTContentView() <UITableViewDataSource, UITableViewDelegate>

@end

@implementation YTContentView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.showsVerticalScrollIndicator = NO;
        // 禁用tableView滚动
        self.scrollEnabled =NO;
    }
    return self;
}

- (void)setTodos:(NSArray *)todos
{
    _todos = todos;
    [self reloadData];

}




#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.todos.count + 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        YTGroupCell *groupCell = [[[NSBundle mainBundle] loadNibNamed:@"YTGroupCell" owner:nil options:nil] lastObject];
        groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return groupCell;
    }

    static NSString *identifier = @"contentCell";
    YTContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YTContentCell" owner:nil options:nil] lastObject];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.todoTitle = self.todos[indexPath.row - 1];
    
    return cell;
}


#pragma mark - tableView Delegate

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    YTLog(@"%zd", indexPath.row);
//    if (indexPath.row != 0) {
//        if ([self.daili respondsToSelector:@selector(selectedTodo:)]) {
//            [self.daili selectedTodo:indexPath.row];
//        }
//    }
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTLog(@"%zd", indexPath.row);
    if (indexPath.row != 0) {
        if ([self.daili respondsToSelector:@selector(selectedTodo:)]) {
            [self.daili selectedTodo:indexPath.row];
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0)
    {
        return 42;
    }
    
    return 56;
}
@end
