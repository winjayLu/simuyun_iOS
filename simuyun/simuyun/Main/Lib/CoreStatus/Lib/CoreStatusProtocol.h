//
//  CoreCoreNetWorkStatus.m
//  simuyun
//
//  Created by Luwinjay on 15/10/6.
//  Copyright (c) 2015年 YTWealth. All rights reserved.
//

#ifndef CoreStatus_CoreStatusProtocol_h
#define CoreStatus_CoreStatusProtocol_h
#import "CoreNetworkStatus.h"

@protocol CoreStatusProtocol <NSObject>

@property (nonatomic,assign) NetworkStatus currentStatus;

@optional

/** 网络状态变更 */
-(void)coreNetworkChangeNoti:(NSNotification *)noti;

@end

#endif
