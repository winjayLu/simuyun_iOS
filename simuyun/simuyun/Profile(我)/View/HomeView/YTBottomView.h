//
//  YTBottomView.h
//  simuyun
//
//  Created by Luwinjay on 15/10/10.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomViewDelegate <NSObject>

- (void)didSelectedRow:(int)row;

@end


@interface YTBottomView : UITableView

@property (nonatomic, weak) id<BottomViewDelegate> BottomDelegate;

@end
