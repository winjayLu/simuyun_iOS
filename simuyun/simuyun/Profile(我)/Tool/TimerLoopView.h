//
//  TimerLoopView.h
//  simuyun
//
//  Created by Luwinjay on 15/10/10.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// 跑马灯

#import <UIKit/UIKit.h>

//loop Object
@interface LoopObj : NSObject

@property (nonatomic, copy) NSString *message_id;


@property (nonatomic,strong)NSString *title;

@end


@protocol loopViewDelegate <NSObject>

- (void)removeVIew;

- (void)pushView:(LoopObj *)loopObj;

@end



@interface TimerLoopView : UIView


- (id)initWithFrame:(CGRect)frame withitemArray:(NSArray*)teams;


@property(nonatomic,readonly) CGPoint   currentOffset;


@property(nonatomic,readonly) NSArray   *itemarray;

/**
 *  代理
 */
@property (nonatomic, weak) id loopDelegate;


//startTimer
- (void)startTimer;

//releaseTimer
-(void)releaseTimer;
@end
