//
//  NSObject+JsonCategory.h
//  simuyun
//
//  Created by Luwinjay on 16/1/29.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JsonCategory)
/**
 *  将NSDictionary/NSArray转换为json
 *
 */
- (NSString *)JsonToString;
@end
