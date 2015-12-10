//
//  QKDimInfoView.m
//  SHLink
//
//  Created by 钱凯 on 15/2/26.
//  Copyright (c) 2015年 Qiankai. All rights reserved.
//

#import "QKInfoCard.h"
#import "UIView+Extension.h"
#import "YTCustomerView.h"


@interface QKInfoCardContainerView : UIView <UIScrollViewDelegate>

@property (assign, nonatomic) CGFloat cornerRadius;

@property (strong, nonatomic) UIColor *containerBackgroundColor;

@property (strong, nonatomic) UIColor *closeButtonTintColor;

@property (strong, nonatomic) UIColor *closeButtonBackgroundColor;

@property (strong, nonatomic) NSArray *containtViews;
// 左侧按钮
@property (nonatomic, weak) UIButton *leftBtn;
// 右侧按钮
@property (nonatomic, weak) UIButton *rightBtn;
// 提示图片
@property (nonatomic, weak) UIImageView *logoView;
// 选中的下标
@property (nonatomic, assign) int selectIndex;

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation QKInfoCardContainerView {
//    QKInfoCardCloseButton *_closeButton;
    UIView *_containerView;
}

#pragma mark - Lifecycle
#pragma mark -

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

-(instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (void)setUp {
    self.backgroundColor = [UIColor clearColor];
    
    _containerView = [[UIView alloc] init];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.delegate = self;
    _containerView.layer.cornerRadius = _cornerRadius;
    _containerView.backgroundColor = _containerBackgroundColor;
    _containerView.layer.masksToBounds = YES;
    [_containerView addSubview:scrollView];
    self.scrollView = scrollView;
    [self addSubview:_containerView];
    
    // 左侧按钮
    UIButton *left = [[UIButton alloc] init];
    [left setBackgroundImage:[UIImage imageNamed:@"cusmertxiangzuo"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [left sizeToFit];
    left.hidden = YES;
    [_containerView addSubview:left];
    self.leftBtn = left;
    // 右侧按钮
    UIButton *right = [[UIButton alloc] init];
    [right setBackgroundImage:[UIImage imageNamed:@"cusmertxiangyou"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(rigthtClick) forControlEvents:UIControlEventTouchUpInside];
    [right sizeToFit];
    [_containerView addSubview:right];
    self.rightBtn = right;
    // 中间logo图片
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.image = [UIImage imageNamed:@"cusmertbaobei"];
    [logoView sizeToFit];
    [_containerView addSubview:logoView];
    self.logoView = logoView;
}

#pragma mark - Layout
#pragma mark -

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    unsigned long subviewCount = _containtViews.count;
    
    CGRect containerFrame = self.bounds;
    _containerView.frame = containerFrame;
    _containerView.layer.cornerRadius = _cornerRadius;
    _containerView.backgroundColor = _containerBackgroundColor;
    
    self.leftBtn.center = _containerView.center;
    self.leftBtn.x = 5;
    self.rightBtn.center = _containerView.center;
    self.rightBtn.x = _containerView.width - self.leftBtn.width - 5;
    
    _scrollView.frame = CGRectInset(_containerView.bounds, 25, 100);
    
    self.logoView.center = _scrollView.center;
    self.logoView.y = _scrollView.center.y - _scrollView.height * 0.5 - self.logoView.height * 0.5;
    
    _scrollView.layer.cornerRadius = 5;
    _scrollView.layer.shadowOffset = CGSizeMake(0, 5);
    _scrollView.layer.shadowOpacity = 0.3f;
    _scrollView.layer.shadowRadius = 20.0f;
    _scrollView.bounces = NO;
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame) * subviewCount, CGRectGetHeight(_scrollView.frame));
    
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (unsigned int i = 0; i < subviewCount; i++) {
        UIView *viewToAdd = [_containtViews objectAtIndex:i];
        viewToAdd.frame = CGRectMake(i * CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
        [_scrollView addSubview:viewToAdd];
    }
    if (_scrollView.subviews.count <= 1) {
        self.rightBtn.hidden = YES;
    }
    
    _scrollView.contentOffset = CGPointZero;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = _scrollView.contentOffset;
    if (offset.x <= 0)
    {
        self.leftBtn.hidden = YES;
        if (_scrollView.subviews.count > 1) {
            self.rightBtn.hidden = NO;
        }
    } else if (offset.x >= (_containtViews.count - 1) * _scrollView.width)
    {
        self.rightBtn.hidden = YES;
        self.leftBtn.hidden = YES;
        if (_scrollView.subviews.count > 1) {
            self.leftBtn.hidden = NO;
        }
    } else {
        self.leftBtn.hidden = NO;
        self.rightBtn.hidden = NO;
    }
    
}

- (void)leftClick
{
    self.rightBtn.hidden = NO;
    CGPoint oldOffset = _scrollView.contentOffset;
    [UIView animateWithDuration:0.25 animations:^{
        _scrollView.contentOffset = CGPointMake(oldOffset.x - _scrollView.width, 0);
    } completion:^(BOOL finished) {
        if (_scrollView.contentOffset.x == 0)
        {
            self.leftBtn.hidden = YES;
        }
    }];
    
}

- (void)rigthtClick
{
    self.leftBtn.hidden = NO;
    CGPoint oldOffset = _scrollView.contentOffset;
    [UIView animateWithDuration:0.25 animations:^{
        
        _scrollView.contentOffset = CGPointMake(oldOffset.x + _scrollView.width, 0);
    } completion:^(BOOL finished) {
        if (_scrollView.contentOffset.x >= (_containtViews.count - 1) * _scrollView.width)
        {
            self.rightBtn.hidden = YES;
        }
    }];

}

@end

////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
@implementation QKInfoCard {
    QKInfoCardContainerView *_containerView;
}

- (YTCusomerModel *)selectCusomer
{
    UIScrollView *scrollView = _containerView.scrollView;
    int selectedIndex = scrollView.contentOffset.x / scrollView.width;
    YTCustomerView *customerView = (YTCustomerView *)_containerSubviews[selectedIndex];
    return customerView.cusomer;
}

#pragma mark - Lifecycle
#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithView:(UIView *)view {
    NSAssert(view, @"View must not be nil.");
    return [self initWithFrame:view.bounds];
}

- (id)initWithWindow:(UIWindow *)window {
    return [self initWithView:window];
}

- (void)setUp {
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0.0f;
    
    _cardBackgroundColor = [UIColor clearColor];
    _closeButtonTintColor = [UIColor colorWithRed:0 green:183.0/255.0 blue:238.0/255.0 alpha:1.000];
    _closeButtonBackgroundColor = [UIColor blackColor];
    _cornerRadius = 5.f;
    _dimBackground = YES;
    _minHorizontalPadding = 5.0f;
    _minVertalPadding = 10.f;
    _proportion = 3.0/4.0f;
    
    _containerView = [[QKInfoCardContainerView alloc] init];
    
    [self addSubview:_containerView];
    
    [self registerForKVO];
    [self registerForNotifications];
}

- (void)dealloc {
    [self unregisterFromKVO];
    [self unregisterFromNotifications];
}

#pragma mark - APIs
#pragma mark -

- (void)show {
    [self showUsingAnimation:YES];
}

- (void)hide {
    [self hideUsingAnimation:YES];
}

#pragma mark - Tools
#pragma mark -

- (void)hideUsingAnimation:(BOOL)animated {

    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
        }];
    }
    else {
        self.alpha = 0.0f;
    }
}

- (void)showUsingAnimation:(BOOL)animated {

    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1.0f;
        } completion:^(BOOL finished) {
        }];
    }
    else {
        self.alpha = 1.0f;
    }
}

#pragma mark - KVO
#pragma mark -

- (void)registerForKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)unregisterFromKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

- (NSArray *)observableKeypaths {
    return [NSArray arrayWithObjects:@"containerSubviews", @"cardBackgroundColor", @"closeButtonTintColor", @"closeButtonBackgroundColor", @"cornerRadius", @"dimBackground", @"minHorizontalPadding", @"minVertalPadding", @"proportion", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
    } else {
        [self updateUIForKeypath:keyPath];
    }
}

- (void)updateUIForKeypath:(NSString *)keyPath {
    if ([keyPath isEqualToString:@"containerSubviews"]) {
        _containerView.containtViews = self.containerSubviews;
    }
    [self setNeedsLayout];
    [self setNeedsDisplay];
    
    for (UIView *subView in self.subviews) {
        [subView setNeedsLayout];
        [subView setNeedsDisplay];
    }
}

#pragma mark - Notifications
#pragma mark -

- (void)registerForNotifications {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(statusBarOrientationDidChange:)
               name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)unregisterFromNotifications {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)statusBarOrientationDidChange:(NSNotification *)notification {
    UIView *superview = self.superview;
    if (!superview) {
        return;
    }else {
        self.frame = self.superview.bounds;
        [self setNeedsDisplay];
    }
}

#pragma mark - Properties
#pragma mark -

#pragma mark - Layout
#pragma mark -

- (void)drawRect:(CGRect)rect {
    //Draw dim background
    if (_dimBackground) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65].CGColor);
        CGContextFillRect(context, rect);
    }
}

- (void)layoutSubviews {
    CGFloat kWidthPadding = _minHorizontalPadding;
    CGFloat kHeightPadding = _minVertalPadding;

    CGFloat kProportion = _proportion;
    
    _containerView.containerBackgroundColor = _cardBackgroundColor;
    _containerView.closeButtonBackgroundColor = _closeButtonBackgroundColor;
    _containerView.closeButtonTintColor = _closeButtonTintColor;
    _containerView.cornerRadius = _cornerRadius;
    
    if (CGRectGetWidth(self.bounds) > CGRectGetHeight(self.bounds)) {
        
        CGFloat containerHeight = CGRectGetHeight(self.bounds) - kHeightPadding * 2.0;
        
        _containerView.bounds = CGRectMake(0, 0, containerHeight * kProportion, containerHeight);
    } else {
        
        CGFloat containerWidth = CGRectGetWidth(self.bounds) - kWidthPadding * 2.0;
        
        _containerView.bounds = CGRectMake(0, 0, containerWidth, containerWidth / kProportion);
    }
    
    _containerView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

@end
