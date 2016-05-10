//
//  YTAddMemberController.m
//  simuyun
//
//  Created by Luwinjay on 16/5/9.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTAddMemberController.h"
#import "YTAddMemberCell.h"
#import "YTMemberModel.h"

@interface YTAddMemberController () <AddMemberDelegate>

// 选中的成员数组
@property (nonatomic, strong) NSMutableArray *selectedMembers;

@end

@implementation YTAddMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加组员";
    // 设置颜色
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = YTGrayBackground;
    // 去掉下划线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 右侧按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
}

/**
 *  保存组员
 */
- (void)saveClick
{
    [self.addDelegate didSelectedMembers:self.selectedMembers];

    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTAddMemberCell *cell = nil;
    static NSString *memberCell = @"AddMember";
    cell = [tableView dequeueReusableCellWithIdentifier:memberCell];
    YTMemberModel *member = self.members[indexPath.row];
    if (cell==nil) {
        cell = [YTAddMemberCell addMemberCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.addDelegate = self;
    }
    cell.row = indexPath.row;
    cell.member = member;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}


- (void)cellButtonClicked:(YTMemberModel *)member WithRow:(NSInteger)row isSelected:(BOOL)isSelected
{
    ((YTMemberModel *)self.members[row]).isSelected = isSelected;
    
    if (isSelected) {
        [self.selectedMembers addObject:member];
    } else {
        [self.selectedMembers removeObject:member];
    }
    
    if (self.selectedMembers.count == 0) {
        [self.navigationItem.rightBarButtonItem setTitle:@"确定"];
    } else {
        [self.navigationItem.rightBarButtonItem setTitle:[NSString stringWithFormat:@"确定(%zd)", self.selectedMembers.count]];
    }
}

- (NSMutableArray *)selectedMembers
{
    if (!_selectedMembers) {
        _selectedMembers = [[NSMutableArray alloc] init];
    }
    return _selectedMembers;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
