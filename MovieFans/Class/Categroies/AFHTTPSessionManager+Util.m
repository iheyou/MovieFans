//
//  AFHTTPSessionManager+Util.m
//  CD1505Weibo
//
//  Created by hy on 15/12/31.
//  Copyright (c) 2015年 hy. All rights reserved.
//

#import "AFHTTPSessionManager+Util.h"

@implementation AFHTTPSessionManager (Util)


+ (void)requestWithType:(AFHTTPSessionManagerRequestType)type URLString:(NSString *)urlStr parmaeters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain", nil];
    manager.requestSerializer.timeoutInterval = 10;
    if (type == AFHTTPSessionManagerRequestTypeGET) {
        [manager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(task, responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(task, error);
        }];
        
    }else if (type == AFHTTPSessionManagerRequestTypePOST) {
        [manager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(task,responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(task,error);
        }];
//        [manager POST:urlStr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            success(task, responseObject);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            failure(task, error);
//        }];
    }
}


@end
