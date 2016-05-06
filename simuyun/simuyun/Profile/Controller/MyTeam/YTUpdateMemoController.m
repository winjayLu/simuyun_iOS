//
//  YTUpdateMemoController.m
//  simuyun
//
//  Created by Luwinjay on 16/5/6.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTUpdateMemoController.h"
#import "UIBarButtonItem+Extension.h"

@interface YTUpdateMemoController ()
@property (weak, nonatomic) IBOutlet UITextField *memoField;

@property (weak, nonatomic) IBOutlet UIButton *clearClick;
@end

@implementation YTUpdateMemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"备注";
    self.memoField.text = self.memo;
    
    // 初始化左侧返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithBg:@"fanhui" target:self action:@selector(blackClick)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.memoField becomeFirstResponder];
}

- (void)blackClick
{
    if ([self.memo isEqualToString:self.memoField.text]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
#warning 发送请求修改
    }
}
#warning 修改详情和列表的数据


@end
