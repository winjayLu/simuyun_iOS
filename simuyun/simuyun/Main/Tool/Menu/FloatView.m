//
//  FloatView.m
//  FloatMenu
//
//  Created by Johnny on 14/9/6.
//  Copyright (c) 2014年 Johnny. All rights reserved.
//

#import "FloatView.h"
#import "YTTabBarController.h"
#import "CustomMaskViewController.h"
#import "YTNavigationController.h"

#define  windowWidth ([UIScreen mainScreen].bounds.size.width)
#define  windowHight ([UIScreen mainScreen].bounds.size.height)

typedef NS_ENUM (NSUInteger, LocationTag)
{
    kLocationTag_top = 1,
    kLocationTag_left,
    kLocationTag_bottom,
    kLocationTag_right
};

static const NSTimeInterval kAnimationDuration = 0.25f;
static FloatView *__floatView = nil;

@interface FloatView ()
{
    UIView          *_boardView;                 //底部view
    UIImageView     *_floatImageView;            //漂浮的menu按钮

    BOOL            _showAnimation;              //animation动画展示
    BOOL            _showKeyBoard;               //键盘是否展开
    LocationTag     _locationTag;                //menu贴在哪个方向
    
    CGRect          _moveWindowRect;             //移动后window.frame
    CGRect          _showKeyBoardWindowRect;     //键盘展开后的window.frame
    CGSize          _keyBoardSize;               //键盘的尺寸
}
@end

@implementation FloatView

- (void)removeFloatView
{
    [_boardView removeFromSuperview];
    [_floatImageView removeFromSuperview];
    _boardView = nil;
    _floatImageView = nil;
    _boardWindow = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    _buttonArray = nil;
//    _buttonImgArray = nil;
    _boardWindow = nil;
    _boardView = nil;
    _floatImageView = nil;
}

- (id)initWithButton
{
    self = [super init];
    if (self) {

        _showAnimation = NO;
        _showKeyBoard = NO;
        _locationTag = kLocationTag_left;
        
        //初始化背景window
        _boardWindow = [[UIWindow alloc] initWithFrame:CGRectMake(DeviceWidth - 60,DeviceHight - 120, 60, 60)];
        _boardWindow.backgroundColor = [UIColor clearColor];
        _boardWindow.windowLevel = 3000;
        _boardWindow.clipsToBounds = YES;
        [_boardWindow makeKeyAndVisible];
        
        //初始化背景view
        _boardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        _boardView.backgroundColor = [UIColor clearColor];
        [_boardWindow addSubview:_boardView];
        
        //初始化漂浮menu
        _floatImageView = [[UIImageView alloc]init];
        [self setImgaeNameWithMove:NO];
        [_floatImageView setUserInteractionEnabled:YES];
        [_floatImageView setFrame:CGRectMake(0, 0, 60, 60)];
        [_boardView addSubview:_floatImageView];
        
        //手势
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImgV:)];
        [_floatImageView addGestureRecognizer:panGestureRecognizer];
        
        UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImgV:)];
        [_floatImageView addGestureRecognizer:tapGestureRecognizer];
        
        //键盘
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

+ (FloatView *)defaultFloatViewWithButton{
 
    __floatView = [[FloatView alloc] initWithButton];
    return __floatView;
}

#pragma mark - GestureRecognizer
#pragma mark UIPanGestureRecognizer
- (void)panImgV:(UIPanGestureRecognizer*)panGestureRecognizer
{

    UIView * moveView = panGestureRecognizer.view.superview.superview;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
            CGPoint translation = [panGestureRecognizer translationInView:moveView.superview];
            [moveView setCenter:(CGPoint){moveView.center.x + translation.x, moveView.center.y + translation.y}];
            [panGestureRecognizer setTranslation:CGPointZero inView:moveView.superview];
            [self setImgaeNameWithMove:YES];
        }
        if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            if (_boardWindow.frame.origin.y + _boardWindow.frame.size.height > windowHight - _keyBoardSize.height) {
                if (_showKeyBoard) {
                    if (moveView.frame.origin.x < 0) {
                        [moveView setCenter:(CGPoint){moveView.frame.size.width/2,windowHight - _keyBoardSize.height - _boardWindow.frame.size.height/2}];
                    }else if (moveView.frame.origin.x + moveView.frame.size.width > windowWidth)
                    {
                        [moveView setCenter:(CGPoint){windowWidth - moveView.frame.size.width/2,windowHight - _keyBoardSize.height - _boardWindow.frame.size.height/2}];
                    }else
                    {
                        [moveView setCenter:(CGPoint){moveView.center.x,windowHight - _keyBoardSize.height - _boardWindow.frame.size.height/2}];
                    }
                    _showKeyBoardWindowRect = CGRectMake(_boardWindow.frame.origin.x, windowHight - moveView.frame.size.height, 60, 60);
                    _locationTag = kLocationTag_bottom;
                }else
                {
                    [self moveEndWithMoveView:moveView];
                    _showKeyBoardWindowRect = _boardWindow.frame;
                }
            }else
            {
                [self moveEndWithMoveView:moveView];
                _showKeyBoardWindowRect = _boardWindow.frame;
            }
            [self setImgaeNameWithMove:NO];
        }
    }];
}

- (void)moveEndWithMoveView:(UIView*)moveView
{
    if (moveView.frame.origin.y <= 40) {
        if (moveView.frame.origin.x < 0) {
            [moveView setCenter:(CGPoint){moveView.frame.size.width/2,moveView.frame.size.height/2}];
            _locationTag = kLocationTag_left;
        }else if (moveView.frame.origin.x + moveView.frame.size.width > windowWidth) {
            [moveView setCenter:(CGPoint){windowWidth - moveView.frame.size.width/2,moveView.frame.size.height/2}];
            _locationTag = kLocationTag_right;
        }else
        {
            [moveView setCenter:(CGPoint){moveView.center.x,moveView.frame.size.height/2}];
            _locationTag = kLocationTag_top;
        }
    }else if (moveView.frame.origin.y + moveView.frame.size.height >= windowHight - 40)
    {
        if (moveView.frame.origin.x < 0) {
            [moveView setCenter:(CGPoint){moveView.frame.size.width/2,windowHight - moveView.frame.size.height/2}];
            _locationTag = kLocationTag_left;
        }else if (moveView.frame.origin.x + moveView.frame.size.width > windowWidth) {
            [moveView setCenter:(CGPoint){windowWidth - moveView.frame.size.width/2,windowHight - moveView.frame.size.height/2}];
            _locationTag = kLocationTag_right;
        }else
        {
            [moveView setCenter:(CGPoint){moveView.center.x,windowHight - moveView.frame.size.height/2}];
            _locationTag = kLocationTag_bottom;
        }
    }else
    {
        if (moveView.frame.origin.x + moveView.frame.size.width/2 < windowWidth/2) {
            if (moveView.frame.origin.x !=0) {
                [moveView setCenter:(CGPoint){moveView.frame.size.width/2,moveView.center.y}];
            }
            _locationTag = kLocationTag_left;
        }else
        {
            if (moveView.frame.origin.x + moveView.frame.size.width != windowWidth) {
                [moveView setCenter:(CGPoint){windowWidth - moveView.frame.size.width/2,moveView.center.y}];
            }
            _locationTag = kLocationTag_right;
        }
    }
}

#pragma mark UITapGestureRecognizer
- (void)tapImgV:(UITapGestureRecognizer*)tapGestureRecognizer
{
    UIWindow *keyWindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            keyWindow = window;
            break;
        }
    }
    UIViewController *appRootVC = keyWindow.rootViewController;
    if ([appRootVC isKindOfClass:[YTTabBarController class]]) {
        YTTabBarController *tabBar = ((YTTabBarController *)appRootVC);
        CustomMaskViewController *player = tabBar.playerVc;
        UIViewController *keyVc = ((UITabBarController *)appRootVC).selectedViewController;
        if (keyVc != nil) {
            [((YTNavigationController *)keyVc) pushViewController:player animated:YES];
            [self removeFloatView];
            tabBar.floatView = nil;
        }
    }
}


#pragma mark - 移动和停止menu图片
- (void)setImgaeNameWithMove:(BOOL)isMove
{
    if (isMove) {
        [_floatImageView setImage:[UIImage imageNamed:@"weixinlogin"]];
    }else
    {
        [_floatImageView setImage:[UIImage imageNamed:@"yunjian"]];
    }
}

#pragma mark - KeyBoard Notification
-(void)keyboardFrameWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    _keyBoardSize = kbSize;
    _showKeyBoard = YES;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        if (_boardWindow.frame.origin.y + _boardWindow.frame.size.height > windowHight - kbSize.height) {
            [_boardWindow setFrame:CGRectMake(_boardWindow.frame.origin.x, windowHight - kbSize.height - _boardWindow.frame.size.height, 60, 60)];
        }
    }];
}

-(void)keyboardFrameWillHide:(NSNotification *)notification
{
    _showKeyBoard = NO;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        if (_showKeyBoardWindowRect.origin.x != 0 && _showKeyBoardWindowRect.origin.y !=0) {
            [_boardWindow setFrame:_showKeyBoardWindowRect];
        } else {
            [_boardWindow setFrame:CGRectMake(0, 0, 60, 60)];
        }
    }];
}
@end

