//
//  YTCustomerView.h
//  QKInfoCardDemo
//
//  Created by Luwinjay on 15/12/10.
//  Copyright © 2015年 Qiankai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTCusomerModel.h"

@interface YTCustomerView : UIView

@property (nonatomic, strong) YTCusomerModel *cusomer;



+ (instancetype)customerView;
@end
