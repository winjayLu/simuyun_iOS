//
//  NSString+JsonCategory.m
//  simuyun
//
//  Created by Luwinjay on 16/1/29.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "NSString+JsonCategory.h"

@implementation NSString (JsonCategory)

/**
 *  将json转换为NSDictionary/NSArray
 *
 */
- (id)JsonToValue
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

@end
