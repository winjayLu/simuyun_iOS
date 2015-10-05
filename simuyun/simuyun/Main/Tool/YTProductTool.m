//
//  YTProductTool.m
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2014年 winjay. All rights reserved.
//

#import "YTProductTool.h"
//#import "FMDB.h"

@implementation YTProductTool

//static FMDatabase *_db;

/**
 数据缓存
 */
+ (void)initialize
{}
//{
//    // 1.打开数据库
//    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"deal.sqlite"];
//    _db = [FMDatabase databaseWithPath:file];
//    if (![_db open]) return;
//    
//    // 2.创表
//    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
//    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_recent_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
//}
//
+ (NSArray *)collectProducts:(int)page{return nil;}
//{
//    int size = 20;
//    int pos = (page - 1) * size;
//    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_collect_deal ORDER BY id DESC LIMIT %d,%d;", pos, size];
//    NSMutableArray *deals = [NSMutableArray array];
//    while (set.next) {
//        MTDeal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"deal"]];
//        [deals addObject:deal];
//    }
//    return deals;
//}
//
//
//
+ (int)collectDealsCount{return 0;}
//{    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal;"];
//    [set next];
//    return [set intForColumn:@"deal_count"];
//}

@end
