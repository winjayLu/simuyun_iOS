//
//  YTSenMailView.h
//  simuyun
//
//  Created by Luwinjay on 15/11/2.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol senMailViewDelegate <NSObject>

@required

- (void)sendMail:(NSString *)mail;

@end

@interface YTSenMailView : UIView

/**
 *  代理
 */
@property(nonatomic,retain)id <senMailViewDelegate> sendDelegate;

- (instancetype)initWithViewController:(UIViewController *)vc;

@end
