//
//  YTSendAllController.m
//  simuyun
//
//  Created by Luwinjay on 16/5/11.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTSendAllController.h"
#import "DSTextView.h"
#import "UIButton+ImageBtn.h"
#import "ShareManage.h"
#import "SVProgressHUD.h"
#import "YTResourcesTool.h"
#import "YTGroupModel.h"



@interface YTSendAllController () <UITextViewDelegate>

/**
 *  编辑框
 */
@property (nonatomic, weak) UITextView *textV;

// 是否正在切换键盘
@property (nonatomic ,assign, getter=isChangingKeyboard) BOOL ChangingKeyboard;

// 工具条
@property (nonatomic , weak) UIView *toolbar;

// 提示数字
@property (nonatomic , weak) UILabel *tiShiLable;

@end

@implementation YTSendAllController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群发信息";
    self.view.backgroundColor = [UIColor whiteColor];
    // 初始化工具条
    [self setupToolbar];
    
    // 初始化编辑框
    [self setupTextView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendClick)];
    
}

/**
 *  发送
 */
- (void)sendClick
{
    if (self.textV.text.length == 0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入群发内容"];
        return;
    } else if (self.textV.text.length > 200)
    {
        [SVProgressHUD showInfoWithStatus:@"内容超过200字"];
        return;
    }
#warning 发送请求
    
    [SVProgressHUD showSuccessWithStatus:@"发送成功"];
    [self.navigationController popViewControllerAnimated:YES];
    
    NSMutableArray *adviserIds = [NSMutableArray array];
    for (YTMemberModel *member in self.group.members) {
        [adviserIds addObject:member.adviserId];
    }
    NSString *str = [adviserIds JSONString];
}



/**
 *  初始化文本编辑框
 */
- (void)setupTextView
{
    DSTextView *textV = [[DSTextView alloc] init];
    textV.alwaysBounceVertical = YES ;//垂直方向上有弹簧效果
    textV.layoutManager.allowsNonContiguousLayout = NO;
    textV.frame = CGRectMake(15, 10, DeviceWidth - 30, DeviceHight - self.toolbar.height - 84);
    textV.delegate = self;
    [self.view addSubview:textV];
    self.textV = textV;
    
    // 设置提醒文字
    textV.placeholder = @"点击输入群发文本";
    textV.placeholderColor = YTColor(102, 102, 102);
    
    // 设置字体
    textV.font = [UIFont systemFontOfSize:15];
    
    // 监听键盘
    // 键盘的frame(位置)即将改变, 就会发出UIKeyboardWillChangeFrameNotification
    // 键盘即将弹出, 就会发出UIKeyboardWillShowNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

/**
 *  初始化工具条
 */
- (void)setupToolbar
{
    // 工具条
    UIView *tool = [[UIView alloc] init];
    tool.frame = CGRectMake(0, DeviceHight - 119, DeviceWidth, 55);
    [self.view addSubview:tool];
    self.toolbar = tool;
    
    // 分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = YTColor(208, 208, 208);
    line.frame = CGRectMake(0, 0, DeviceWidth, 1);
    [tool addSubview:line];
    
    // 字数提醒
    UILabel *tiShi = [[UILabel alloc] init];
    tiShi.text = @"还可以输入200字";
    tiShi.textAlignment = NSTextAlignmentRight;
    tiShi.textColor = YTColor(102, 102, 102);
    tiShi.font = [UIFont systemFontOfSize:11];
    tiShi.width = tool.width - 20;
    [tiShi sizeToFit];
    tiShi.frame = CGRectMake(10, 10, tool.width - 20, tiShi.height);
    [tool addSubview:tiShi];
    self.tiShiLable = tiShi;
}



#pragma mark - 键盘处理
/**
 *  键盘即将隐藏：工具条（toolbar）随着键盘移动
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    //需要判断是否自定义切换的键盘
    if (self.isChangingKeyboard) {
        self.ChangingKeyboard = NO;
        return;
    }
    
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.transform = CGAffineTransformIdentity;//回复之前的位置
        self.textV.height = DeviceHight - self.toolbar.height - 84;
    }];
}

/**
 *  键盘即将弹出
 */
- (void)keyboardWillShow:(NSNotification *)note
{
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
        self.textV.height = DeviceHight - keyboardH - 200;
    }];
    
    
}

#pragma mark - UITextViewDelegate
/**
 *  当用户开始拖拽scrollView时调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    [textView scrollRangeToVisible:textView.selectedRange];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length >= 200) {
        self.tiShiLable.textColor = YTNavBackground;
    } else {
        self.tiShiLable.textColor = YTColor(102, 102, 102);
    }
    int difference = 200 - (int)textView.text.length;
    self.tiShiLable.text = [NSString stringWithFormat:@"还可以输入%d字", difference];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
