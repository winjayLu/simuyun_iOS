//
//  BFNavigationBarDrawer.m
//  BFNavigationBarDrawer
//
//  Created by Balázs Faludi on 04.03.14.
//  Copyright (c) 2014 Balazs Faludi. All rights reserved.
//

#import "BFNavigationBarDrawer.h"

#define kAnimationDuration 0.3

typedef NS_ENUM(NSInteger, BFNavigationBarDrawerState) {
	BFNavigationBarDrawerStateHidden,	// The drawer is currently hidden behind the navigation bar, or not added to a view hierarchy yet.
	BFNavigationBarDrawerStateShowing,	// The drawer is sliding onto screen, from below the navigation bar.
	BFNavigationBarDrawerStateShown,	// The drawer is visible below the navigation bar and is not currently animating.
	BFNavigationBarDrawerStateHiding,	// The drawer is sliding off screen, back under the navigation drawer.
};

@interface BFNavigationBarDrawer()

@property (nonatomic, strong)  UIButton *selectBtn;

@property (nonatomic, assign) BOOL isShow;


@end

@implementation BFNavigationBarDrawer {
	BFNavigationBarDrawerState state;
	UINavigationBar *parentBar;
	NSLayoutConstraint *verticalDrawerConstraint;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}

- (id)init
{
    self = [self initWithFrame:CGRectMake(0, 0, DeviceWidth, 46)];
    self.userInteractionEnabled = YES;
    return self;
}

- (void)setup {
    self.userInteractionEnabled = YES;
    self.hidden = NO;
    [self setupBtn];
}

- (void)setScrollView:(UIScrollView *)scrollView {
	if (_scrollView != scrollView) {
		_scrollView = scrollView;

	}
}

- (void)setupConstraintsWithNavigationBar:(UINavigationBar *)bar {
	NSLayoutConstraint *constraint;
	constraint = [NSLayoutConstraint constraintWithItem:self
											  attribute:NSLayoutAttributeLeft
											  relatedBy:NSLayoutRelationEqual
												 toItem:bar
											  attribute:NSLayoutAttributeLeft
											 multiplier:1
											   constant:0];
	[self.superview addConstraint:constraint];
	
	constraint = [NSLayoutConstraint constraintWithItem:self
											  attribute:NSLayoutAttributeRight
											  relatedBy:NSLayoutRelationEqual
												 toItem:bar
											  attribute:NSLayoutAttributeRight
											 multiplier:1
											   constant:0];
	[self.superview addConstraint:constraint];
	
	constraint = [NSLayoutConstraint constraintWithItem:self
											  attribute:NSLayoutAttributeHeight
											  relatedBy:NSLayoutRelationEqual
												 toItem:nil
											  attribute:NSLayoutAttributeNotAnAttribute
											 multiplier:1
											   constant:44];
	[self addConstraint:constraint];
}

- (void)constrainBehindNavigationBar:(UINavigationBar *)bar {
	[self.superview removeConstraint:verticalDrawerConstraint];
	verticalDrawerConstraint = [NSLayoutConstraint constraintWithItem:self
															attribute:NSLayoutAttributeBottom
															relatedBy:NSLayoutRelationEqual
															   toItem:bar
															attribute:NSLayoutAttributeBottom
														   multiplier:1
															 constant:0];
	[self.superview addConstraint:verticalDrawerConstraint];
}


- (void)constrainBelowNavigationBar:(UINavigationBar *)bar {
	[self.superview removeConstraint:verticalDrawerConstraint];
	verticalDrawerConstraint = [NSLayoutConstraint constraintWithItem:self
															attribute:NSLayoutAttributeTop
															relatedBy:NSLayoutRelationEqual
															   toItem:bar
															attribute:NSLayoutAttributeBottom
														   multiplier:1
															 constant:0];
	[self.superview addConstraint:verticalDrawerConstraint];
}

- (void)showFromNavigationBar:(UINavigationBar *)bar animated:(BOOL)animated {
	
    
    if (self.isShow) {
        self.isShow = NO;
        [self hideAnimated:YES];
        return;
    } else {
        self.isShow = YES;
    }
	parentBar = bar;
    
	[bar.superview insertSubview:self belowSubview:bar];
	[self setupConstraintsWithNavigationBar:bar];
	if (animated && state == BFNavigationBarDrawerStateHidden) {
		[self constrainBehindNavigationBar:bar];
	}
	[self.superview layoutIfNeeded];
	[self constrainBelowNavigationBar:bar];
	void (^animations)() = ^void() {
		state = BFNavigationBarDrawerStateShowing;
		[self.superview layoutIfNeeded];
		_scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x, _scrollView.contentOffset.y - 46);
	};
	void (^completion)(BOOL) = ^void(BOOL finished) {
		if (state == BFNavigationBarDrawerStateShowing) {
			state = BFNavigationBarDrawerStateShown;
		}
	};
	
	if (animated) {
		[UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:animations completion:completion];
	} else {
		animations();
		completion(YES);
	}

    
    self.userInteractionEnabled = YES;
    self.frame = CGRectMake(0, 0, DeviceWidth, 110);
    self.backgroundColor = YTNavBackground;
    self.hidden = NO;
    
}

- (void)setupBtn
{
    CGFloat btnW = 60;
    CGFloat btnH = 25;
    CGFloat maginTop = 64 + (46 - btnH) * 0.5;
    CGFloat maginLeft = (DeviceWidth - 300) / 6;
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundImage:[UIImage imageNamed:@"xuankuang"] forState:UIControlStateSelected];
        NSString *title = @"";
        switch (i) {
            case 0:
                title = @"全部";
                btn.selected = YES;
                btn.tag = btnTypeQuanBu;
                self.selectBtn = btn;
                break;
            case 1:
                title = @"待报备";
                btn.tag = btnTypeDaiBaoBei;
                break;
            case 2:
                title = @"确认中";
                btn.tag = btnTypeQueRenZhong;
                break;
            case 3:
                title = @"已确认";
                btn.tag = btnTypeYiQueRen;
                break;
            case 4:
                title = @"已失效";
                btn.tag = btnTypeYiShiXiao;
                break;
        }
        [btn setTitle:title forState:UIControlStateNormal];
        btn.frame = CGRectMake(maginLeft + i * (maginLeft + btnW), maginTop , btnW, btnH);
        [btn addTarget:self action:@selector(btnClcik:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    
    }
}

- (void)btnClcik:(UIButton *)button
{
    self.selectBtn.selected = NO;
    button.selected = YES;
    self.selectBtn = button;
    self.isShow = NO;
    [self hideAnimated:YES];
    [self.delegate selectedBtnWithType:(int)button.tag];
}

- (void)hideAnimated:(BOOL)animated {
	
	if (state == BFNavigationBarDrawerStateHiding || state == BFNavigationBarDrawerStateHidden) {
		NSLog(@"BFNavigationBarDrawer: Inconsistency warning. Drawer is already hiding or is hidden.");
		return;
	}
	
	if (!parentBar) {
		NSLog(@"BFNavigationBarDrawer: Navigation bar should not be released while drawer is visible.");
		return;
	}
	


	CGFloat fix = 46;

	[self constrainBehindNavigationBar:parentBar];
    
	
    void (^animations)() = ^void() {
        state = BFNavigationBarDrawerStateHiding;
        [self.superview layoutIfNeeded];
        state = BFNavigationBarDrawerStateHidden;
        _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x, _scrollView.contentOffset.y + fix);
        
    };
	
	
	void (^completion)(BOOL) = ^void(BOOL finished) {
        parentBar = nil;
        [self removeFromSuperview];

	};
    
	
	if (animated) {
		[UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:animations completion:completion];
	} else {
		animations();
		completion(YES);
	}
    
}

@end
