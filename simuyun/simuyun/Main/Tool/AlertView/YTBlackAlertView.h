//
//  YTBlackAlertView.h
//  simuyun
//
//  Created by Luwinjay on 15/10/25.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^titleClcik)();

@interface YTBlackAlertView : UIView

+ (instancetype)shared;
- (void)showAlertWithTitle:(NSString *)title detail:(NSString *)detail;
- (void)showAlertSignWithTitle:(NSString *)title date:(NSString *)date yunDou:(int)yunDou block:(titleClcik)block;
@end
