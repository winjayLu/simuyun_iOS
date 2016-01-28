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


#define menuBtnWidth    50  //按钮宽度
#define menuBtnHeight   50  //按钮高度
#define btnxDistance    60 //按钮之间x的距离
#define btnyDistance    40 //按钮之间y的距离

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

@property(nonatomic,retain)UIImageView *whiteBg;

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

    CGFloat shareMenuViewH = 170;
    if (self.titleArr.count > 4) {
        shareMenuViewH = 260;
    } else if(self.isHeight)
    {
        shareMenuViewH = 200;
    }
    
    shareMenuView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceHight, DeviceWidth, shareMenuViewH)];
    [self addSubview:shareMenuView];

    [UIView animateWithDuration:0.4 animations:^{
        shareMenuView.frame =CGRectMake(0,DeviceHight - shareMenuViewH, DeviceWidth,shareMenuViewH);
        mainGrayBg.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    _whiteBg = [[UIImageView alloc] initWithFrame:shareMenuView.bounds];
    [_whiteBg  setUserInteractionEnabled:YES];
    _whiteBg.backgroundColor = [UIColor whiteColor];
    [shareMenuView addSubview:_whiteBg];
    [self creatShareBtnView];
    
}

- (void)creatShareBtnView
{
    int cloumsNum = 4;              //按钮列数
    NSInteger rowsNum = (self.titleArr.count + cloumsNum - 1) / cloumsNum;                //按钮行数
    
    float viewWidth = DeviceWidth - 30;//cloumsNum * menuBtnWidth + (cloumsNum - 1) * btnxDistance;
    float viewHeight = rowsNum * menuBtnHeight + (rowsNum - 1) * btnyDistance;
    UIView *buttonsView = [[UIView alloc] init];
    buttonsView.frame = CGRectMake(15,20, viewWidth, viewHeight);
    buttonsView.backgroundColor = [UIColor clearColor];
    [_whiteBg  addSubview:buttonsView];
    
    for(int i = 0; i < rowsNum; i++)
    {
        for(int j = 0; j<cloumsNum; j++)
        {
            int num = i * cloumsNum + j;
            if(num >= [self.titleArr count])
            {
                break ;
            }
            float btnX = j * menuBtnWidth + j * ((viewWidth - menuBtnWidth * cloumsNum) / (cloumsNum - 1));
            float btnY = i * DeviceWidth / cloumsNum;
            //  创建按钮
            UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            menuBtn.frame = CGRectMake(btnX, btnY, menuBtnWidth, menuBtnHeight);
            NSString *image = [self.imageArr objectAtIndex:num];
            [menuBtn setImage:[UIImage imageNamed:[self.imageArr objectAtIndex:num]] forState:UIControlStateNormal];
            [menuBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            buttonsView.backgroundColor = [UIColor clearColor];
            [buttonsView addSubview:menuBtn];
            //  设置文字
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 12)];
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = [UIColor grayColor];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.text = [self.titleArr objectAtIndex:num];
            [buttonsView addSubview:titleLabel];
            [titleLabel sizeToFit];
            titleLabel.center = CGPointMake(menuBtn.center.x, menuBtn.center.y + 40);
            
            //  设置按钮的tag
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
            menuBtn.tag = buttonType;
        }
    }

}

#pragma mark 选择分享按钮点击
- (void)shareBtnClick:(UIButton *)sender
{
    if (_shareDelegate  &&[_shareDelegate   respondsToSelector:@selector(shareBtnClickWithIndex:)]) {
        [_shareDelegate  shareBtnClickWithIndex:sender.tag];
    }
    
}
#pragma mark 取消分享
- (void)cancelBtnClick:(UIImageView *)sender
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