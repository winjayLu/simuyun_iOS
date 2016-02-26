//
//  ShareCustomView.m
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//
//  自定义分享视图

#import "ShareCustomView.h"
#import "UIImage+Extend.h"
#import "YTResourcesTool.h"


#define menuBtnWidth    40  //按钮宽度
#define menuBtnHeight   40  //按钮高度
#define btnxDistance    24 //按钮之间x的距离

@interface ShareCustomView ()
{
    UIView *shareMenuView;
    UIImageView *mainGrayBg;
    UILabel *shareToLabel1;
    UILabel *shareTolabel2;
    UIButton *cancelBtn;
    UILabel  *titleLabel;
    BOOL   isNight;
    
    
}
/**
 *  所有分享平台的标题
 */
@property (nonatomic, strong) NSArray *titleArr;
/**
 *  所有分享平台的图片
 */
@property (nonatomic, strong) NSArray *imageArr;

@end

@implementation ShareCustomView


- (instancetype)initWithTitleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray
{
    self = [self init];
    if (self) {
        //  设置要分享的平台
        if([YTResourcesTool isVersionFlag] == NO)
        {
            self.titleArr = [NSArray arrayWithObjects:@"邮件",@"短信",@"复制链接", nil];
            self.imageArr = [NSArray arrayWithObjects:@"ShareButtonTypeEmail",@"ShareButtonTypeSms",@"ShareButtonTypeCopy", nil];
        } else {
            self.titleArr = titleArray;
            self.imageArr = imageArray;
        }
        //  创建子控件
        [self creatMainShareView];
    }
    return self;
}

- (instancetype)initWithTitleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray isHeight:(BOOL)isHeight
{
    self = [self init];
    if (self) {
        self.isHeight = isHeight;
        //  设置要分享的平台
        self.titleArr = titleArray;
        self.imageArr = imageArray;
        if([YTResourcesTool isVersionFlag] == NO)
        {
            self.titleArr = [NSArray arrayWithObjects:@"邮件",@"短信", nil];
            self.imageArr = [NSArray arrayWithObjects:@"ShareButtonTypeEmail",@"ShareButtonTypeSms", nil];
        }
        //  创建子控件
        [self creatMainShareView];
        
    }
    return self;

}


- (void)creatMainShareView
{
    
    
    mainGrayBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHight)];
    [mainGrayBg setImage:[UIImage imageWithColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]]];

    [mainGrayBg  setUserInteractionEnabled:YES];
    mainGrayBg.alpha = 0.0;
    [self addSubview:mainGrayBg];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelBtnClick:)];

    mainGrayBg.tag = ShareButtonTypeCancel;
    [mainGrayBg  addGestureRecognizer:tapGR];

    CGFloat shareMenuViewH = 200;
    
    shareMenuView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceHight, DeviceWidth, shareMenuViewH)];
    shareMenuView.backgroundColor = [UIColor whiteColor];
    [self addSubview:shareMenuView];

    [UIView animateWithDuration:0.4 animations:^{
        CGFloat y = DeviceHight - shareMenuViewH - 64;
        if (self.isHeight) {
            y = DeviceHight - shareMenuViewH - 54;
        }
        shareMenuView.frame =CGRectMake(0, y, DeviceWidth,shareMenuViewH);
        mainGrayBg.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    [self creatShareBtnView];
    
}

- (void)creatShareBtnView
{
    // 标题
    UILabel *lable = [[UILabel alloc] init];
    lable.text = @"分享";
    lable.textColor = YTColor(51, 51, 51);
    lable.font = [UIFont systemFontOfSize:17];
    lable.frame = CGRectMake(0, 0, DeviceWidth, 56);
    lable.textAlignment = NSTextAlignmentCenter;
    [shareMenuView addSubview:lable];
    
    // 分割线1
    UIView *lineOne = [[UIView alloc] init];
    lineOne.backgroundColor = YTColor(208, 208, 208);
    lineOne.frame = CGRectMake(0, CGRectGetMaxY(lable.frame), DeviceWidth, 1);
    [shareMenuView addSubview:lineOne];
    
    // 按钮容器
    UIView *buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineOne.frame), menuBtnWidth * self.imageArr.count + (self.imageArr.count - 1) * 24, 88)];
    buttonsView.center = CGPointMake(DeviceWidth * 0.5, buttonsView.center.y);
    buttonsView.backgroundColor = [UIColor clearColor];
    [shareMenuView addSubview:buttonsView];

    // 创建按钮
    for (int i = 0; i < self.titleArr.count; i++) {
        
        //  设置按钮的tag
        NSString *image = [self.imageArr objectAtIndex:i];
        int buttonType = 0;
        if ([image isEqualToString:@"ShareButtonTypeWxShare"]) {
            buttonType = ShareButtonTypeWxShare;
        } else if([image isEqualToString:@"ShareButtonTypeWxPyq"]){
            buttonType = ShareButtonTypeWxPyq;
        } else if([image isEqualToString:@"ShareButtonTypeEmail"]){
            buttonType = ShareButtonTypeEmail;
        } else if([image isEqualToString:@"ShareButtonTypeSms"]){
            buttonType = ShareButtonTypeSms;
        } else if([image isEqualToString:@"ShareButtonTypeCopy"]){
            buttonType = ShareButtonTypeCopy;
        }
        //  创建按钮
        UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        menuBtn.tag = buttonType;
        menuBtn.frame = CGRectMake(menuBtnWidth, menuBtnHeight, menuBtnWidth, menuBtnHeight);
        [menuBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [menuBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttonsView addSubview:menuBtn];
        //  设置文字
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 12)];
        titleLabel.font = [UIFont systemFontOfSize:10];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = YTColor(102, 102, 102);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = [self.titleArr objectAtIndex:i];
        [buttonsView addSubview:titleLabel];
        [titleLabel sizeToFit];
        menuBtn.frame = CGRectMake((menuBtnWidth + 24) * i, 15, menuBtnWidth, menuBtnHeight);
        titleLabel.center = CGPointMake(menuBtn.center.x, menuBtn.center.y + 30);
    }
    
    // 分割线1
    UIView *lineTwo = [[UIView alloc] init];
    lineTwo.backgroundColor = YTColor(208, 208, 208);
    lineTwo.frame = CGRectMake(0, CGRectGetMaxY(buttonsView.frame), DeviceWidth, 1);
    [shareMenuView addSubview:lineTwo];
    
    // 取消按钮
    UIButton *qxBtn = [[UIButton alloc] init];
    qxBtn.frame = CGRectMake(0, CGRectGetMaxY(lineTwo.frame) + 1, DeviceWidth, 200 - CGRectGetMaxY(lineTwo.frame));
    [qxBtn setTitle:@"取消" forState:UIControlStateNormal];
    [qxBtn setTitleColor:YTColor(153, 153, 153) forState:UIControlStateNormal];
    [qxBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [qxBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [shareMenuView addSubview:qxBtn];
    
}

#pragma mark 选择分享按钮点击
- (void)shareBtnClick:(UIImageView *)sender
{
    if (_shareDelegate  &&[_shareDelegate   respondsToSelector:@selector(shareBtnClickWithIndex:)]) {
        [_shareDelegate  shareBtnClickWithIndex:sender.tag];
    }
    
}
#pragma mark 取消分享
- (void)cancelBtnClick:(UIImageView *)sende
{
    [UIView animateWithDuration:0.4 animations:^{
        shareMenuView.frame =CGRectMake(0, DeviceHight - 20, DeviceHight, 150);
        mainGrayBg.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (_shareDelegate  &&[_shareDelegate   respondsToSelector:@selector(shareBtnClickWithIndex:)]) {
            [_shareDelegate  shareBtnClickWithIndex:ShareButtonTypeCancel];
        }
        [self removeFromSuperview];
    }];
}
/**
 *  退出分享菜单
 */
- (void)cancelMenu
{
    [self cancelBtnClick:nil];
}


@end