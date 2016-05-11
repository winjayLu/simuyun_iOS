//
//  YTProductTypeModel.h
//  simuyun
//
//  Created by Luwinjay on 16/5/11.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTProductTypeModel : NSObject

@property (nonatomic, assign) int type;

@property (nonatomic, copy) NSString *name;

- (instancetype)initWithName:(NSString *)name type:(int)type;

@end
