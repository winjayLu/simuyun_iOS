//
//  NSObject+JsonCategory.m
//  simuyun
//
//  Created by Luwinjay on 16/1/29.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "NSObject+JsonCategory.h"

@implementation NSObject (JsonCategory)


/**
 *  将NSDictionary/NSArray转换为json
 *
 */
- (NSString *)JsonToString
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];;
}

@end
