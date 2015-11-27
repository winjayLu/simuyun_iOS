//
//  TimerLoopView.m
//  simuyun
//
//  Created by Luwinjay on 15/10/10.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// 跑马灯

#import "TimerLoopView.h"



@implementation LoopObj

@synthesize LabelName=_LabelName;

@end

@interface TimerLoopView()
{
    UIScrollView *abstractScrollview;
    
    CGPoint _offsetpy;
    
    NSInteger autoIndex;
    
    NSArray *_itemarray;
    
    
    
    CGFloat _height;
    
    CGFloat _width;
    
    
     NSTimer *m_timer;
}

-(void)makeselfUI;

@end

@implementation TimerLoopView

@synthesize currentOffset;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeselfUI];
    }
    return self;
}


-(void)makeselfUI
{
    autoIndex=0;
    //for test
    abstractScrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,_width , _height)];
    [self addSubview:abstractScrollview];
    
    //contentSize
    [abstractScrollview setContentSize:CGSizeMake(self.frame.size.width, ([_itemarray count]+1)*_height)];
    
    //add subviews
    
    for (int i=0; i<[_itemarray count]; i++)
    {
        
        //loop obj
        LoopObj *obj=(LoopObj*)[_itemarray objectAtIndex:i];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, _height*i, _width, _height)];
        [label setText:obj.LabelName];
        label.textColor = [UIColor whiteColor];
        label.tag=10+i;
        [abstractScrollview addSubview:label];
        
        if (i==[_itemarray count]-1) {
            
            LoopObj *obj=(LoopObj*)[_itemarray objectAtIndex:0];
            UILabel *labelLast=[[UILabel alloc]initWithFrame:CGRectMake(0, _height*(i+1), _width, _height)];
            labelLast.textColor = [UIColor whiteColor];
            [labelLast setText:obj.LabelName];
            labelLast.tag=10+i+1;
            [abstractScrollview addSubview:labelLast];
        }
    }
    
    //abstract!!
    abstractScrollview.contentOffset=CGPointMake(0, 0);
    
    
    // 创建一个可以接受事件的Button
    UIButton *button = [[UIButton alloc] init];
    button.frame = self.bounds;
    [button addTarget:self action:@selector(titleClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

-(CGPoint)currentOffset
{
    return _offsetpy;
}

-(NSArray*)itemarray
{
    return _itemarray;
}


- (id)initWithFrame:(CGRect)frame withitemArray:(NSArray*)teams
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        //item
        _itemarray=teams;
        //offset
        _offsetpy=CGPointMake(0, 0);
        
        _width=self.frame.size.width;
        
        _height=self.frame.size.height;
        
        assert([teams count]!=0);
        // Initialization code
         [self makeselfUI];
        
        [self startTimer];
        
    }
    return self;
}
//startTimer
- (void)startTimer
{
    if (m_timer == nil) {
        m_timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(updateTitle) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:m_timer forMode:NSRunLoopCommonModes];
    }
}
//stop Timer
- (void)releaseTimer
{
    if ([m_timer isValid]) {
        [m_timer invalidate];
        m_timer = nil;
    }
   
}
/**
 *  title点击
 */
- (void)titleClick
{
    [self releaseTimer];
}

- (void)updateTitle
{
    //起始位置
    UIView *topLabel = (UIView *)[abstractScrollview viewWithTag:10];
    CGPoint point1 = CGPointMake(0, 0);
    point1.y = topLabel.frame.origin.y;
    
    //最后标签位置
    UIView *lastlabel=(UIView *)[abstractScrollview viewWithTag:10+[_itemarray count]];
    
    //当前标签位置
    CGPoint point = [abstractScrollview contentOffset];
    
    if (point.y >=lastlabel.frame.origin.y) {
        
        autoIndex=0;
        
        abstractScrollview.contentOffset = point1;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    
    
    UIView *view=(UIView*)[abstractScrollview viewWithTag:autoIndex+10+1];
    
    CGPoint pointmiddle=CGPointMake(0, view.frame.origin.y);
    
    autoIndex +=1;
    
    abstractScrollview.contentOffset = pointmiddle;
    
    [UIView commitAnimations];
    
}

-(void)dealloc
{
    [self releaseTimer];
}


@end
