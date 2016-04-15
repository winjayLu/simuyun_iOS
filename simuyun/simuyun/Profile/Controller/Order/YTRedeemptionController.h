//
//  YTRedeemptionController.h
//  simuyun
//
//  Created by Luwinjay on 16/4/12.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RedeemViewDelegate <NSObject>

@optional

/**
 *  提交赎回成功
 */
-(void)redeemSuccess;


@end


// 赎回申请

@interface YTRedeemptionController : UIViewController

/**
 *  订单id
 */
@property (nonatomic, copy) NSString *orderId;


/**
 *  代理
 */
@property (nonatomic, weak) id<RedeemViewDelegate> delegate;
@end
