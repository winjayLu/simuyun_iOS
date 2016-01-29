//
//  NSString+JsonCategory.h
//  simuyun
//
//  Created by Luwinjay on 16/1/29.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JsonCategory)
/**
 *  将json转换为NSDictionary/NSArray
 *
 */
- (id)JsonToValue;
@end
