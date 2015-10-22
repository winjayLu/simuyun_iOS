//
//  WJHttpTool.m
//
//  Created by apple on 14/12/25.
//  Copyright (c) 2014年 winjay. All rights reserved.
//
//  网络请求工具类

#import "YTHttpTool.h"
#import "AFNetworking.h"
#import "NSDictionary+Extension.h"

@implementation YTHttpTool

/**
 *  post请求
 *
 */
+ (void)post:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建一个请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];

    // 2.发送一个POST请求
    NSString *newUrl = [NSString stringWithFormat:@"%@%@",YTServer, url];
//    NSLog(@"%@", newUrl);
//    NSLog(@"%@", [NSDictionary httpWithDictionary:params]);
    [mgr POST:newUrl parameters:[NSDictionary httpWithDictionary:params]
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (success) {
              success(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
    }];

}
/**
 *  get请求
 *
 */
+ (void)get:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建一个请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    // 2.发送一个GET请求
    NSString *newUrl = [NSString stringWithFormat:@"%@%@",YTServer, url];
//    YTLog(@"%@",newUrl);
//    YTLog(@"%@", [NSDictionary httpWithDictionary:params]);
    [mgr GET:newUrl parameters:[NSDictionary httpWithDictionary:params]
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"ss");
          NSLog(@"%@",operation);
          if (success) {
              success(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}


/**
 *  文件上传
 *
 */
+ (void)post:(NSString *)url params:(id)params files:(NSArray *)files success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建一个请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (YTHttpFile *file in files) {
            [formData appendPartWithFileData:file.data name:file.name fileName:file.filename mimeType:file.mimeType];
        }
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}



@end

@implementation YTHttpFile

+ (instancetype)fileWithName:(NSString *)name data:(NSData *)data mimeType:(NSString *)mimeType filename:(NSString *)filename
{
    YTHttpFile *file = [[self alloc] init];
    file.name = name;
    file.data = data;
    file.mimeType = mimeType;
    file.filename = filename;
    return file;
}
@end
