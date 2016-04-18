//
//  YTSnsShareViewController.m
//  simuyun
//
//  Created by Luwinjay on 16/4/12.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTSnsShareViewController.h"
#import "DSTextView.h"
#import "UIButton+ImageBtn.h"
#import "ShareManage.h"
#import "SVProgressHUD.h"
#import "YTResourcesTool.h"


// 营销短信

@interface YTSnsShareViewController () <UITextViewDelegate>


/**
 *  编辑框
 */
@property (nonatomic, weak) UITextView *textV;

// 是否正在切换键盘
@property (nonatomic ,assign, getter=isChangingKeyboard) BOOL ChangingKeyboard;

// 工具条
@property (nonatomic , weak) UIView *toolbar;

/**
 *  分享
 */
@property (nonatomic, strong) ShareManage *shareManage;


@end

@implementation YTSnsShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"营销短信";
    self.view.backgroundColor = [UIColor whiteColor];
    // 初始化工具条
    [self setupToolbar];
    
    // 审核隐藏工具条
    if ([YTResourcesTool isVersionFlag] == NO) {
        self.toolbar.hidden = YES;
    }
    
    // 初始化编辑框
    [self setupTextView];
    
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
    textV.text = self.shareText;
    [self.view addSubview:textV];
    self.textV = textV;
    
    // 设置提醒文字
    textV.placeholder = @"点击编辑文本";
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
    tool.backgroundColor = YTColor(246, 246, 246);
    tool.frame = CGRectMake(0, DeviceHight - 179, DeviceWidth, 115);
//    tool.y =  - tool.height;
    [self.view addSubview:tool];
    self.toolbar = tool;
    
    // 分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = YTColor(208, 208, 208);
    line.frame = CGRectMake(0, 0, DeviceWidth, 1);
    [tool addSubview:line];
    
    // 分享按钮
    CGFloat btnW = 41;
    CGFloat btnH = btnW + 22;
    CGFloat btnY = (tool.height - btnH) * 0.5;
    CGFloat maginx = 20;
    CGFloat paddingx = (DeviceWidth - btnW * 5 - maginx * 2) * 0.25;
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [[UIButton alloc] init];
        [btn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [btn setTitleColor:YTColor(102, 102, 102) forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [tool addSubview:btn];
        switch (i) {
            case 0:
                btn.frame = CGRectMake(maginx, btnY, btnW, btnH);
                [btn setTitle:@"微信" forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"wexin_nor"] forState:UIControlStateNormal];
                break;
            case 1:
                btn.frame = CGRectMake(maginx + btnW + paddingx, btnY, btnW, btnH);
                [btn setTitle:@"朋友圈" forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"pengyouquan_nor"] forState:UIControlStateNormal];
                break;
            case 2:
                btn.frame = CGRectMake(maginx + ((btnW + paddingx) * 2), btnY, btnW, btnH);
                [btn setTitle:@"邮件" forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"Share_mail_nor"] forState:UIControlStateNormal];
                break;
            case 3:
                btn.frame = CGRectMake(maginx + ((btnW + paddingx) * 3), btnY, btnW, btnH);
                [btn setTitle:@"短信" forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"Share_duanxin_nor"] forState:UIControlStateNormal];
                break;
            case 4:
                btn.frame = CGRectMake(maginx + ((btnW + paddingx) * 4), btnY, btnW, btnH);
                [btn setTitle:@"复制" forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"Share_fuzhi_nor"] forState:UIControlStateNormal];
                break;
        }
        [btn centerImageAndTitle];
    }
    
}

/**
 *  分享点击
 */
- (void)shareClick:(UIButton *)btn
{
    if (self.textV.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入内容后分享"];
        return;
    }
    self.shareManage.share_content = self.textV.text;
    if (btn.tag == 0) {
        [self.shareManage wxShareWithViewControll:self];
    } else if(btn.tag == 1) {
        [self.shareManage wxpyqShareWithViewControll:self];
    } else if(btn.tag == 2) {
        self.shareManage.bankNumber = self.textV.text;
        [self.shareManage displayEmailComposerSheet:self];
    } else if(btn.tag == 3) {
        self.shareManage.bankNumber = self.textV.text;
        [self.shareManage smsShareWithViewControll:self];
    } else {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.textV.text;
        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
    }

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

- (ShareManage *)shareManage
{
    if (!_shareManage) {
        ShareManage *share = [ShareManage shareManage];
        [share shareTextConfig];
        share.share_title = nil;
        share.share_image = nil;
        share.share_url = nil;
        _shareManage = share;
    }
    return _shareManage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
