//
//  HttpTool.m
//  change2app
//
//  Created by jam on 17/4/11.
//  Copyright © 2017年 jam. All rights reserved.
//

#import "HttpTool.h"
#import "ApiTool.h"

#define xSiginatureVideos @"F0q61aB6GG6ZkcAN5/VI//wVjTPlNanQ6QmDWrU8FRU="
#define xSiginatureSearch @"BWza7nTl1CrRV2eKaZLOs5NXZZY4n+3NzebRZXBclgg="

@implementation HttpTool

+ (AFHTTPSessionManager*)manager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 18;
    [manager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setValue:@"F0q61aB6GG6ZkcAN5/VI//wVjTPlNanQ6QmDWrU8FRU=" forHTTPHeaderField:@"X-Signature"];
    [manager.requestSerializer setValue:@"Token token=" forHTTPHeaderField:@"Authorization"];
    return manager;
}

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    if (url.length==0){
        return;
    }
    AFHTTPSessionManager* manager=[HttpTool manager];
    
    if ([url isEqualToString:[ApiTool videoJSON]]) {
        [manager.requestSerializer setValue:xSiginatureVideos forHTTPHeaderField:@"X-Signature"];
    }
    else if([url isEqualToString:[ApiTool searchJSON]])
    {
        [manager.requestSerializer setValue:xSiginatureSearch forHTTPHeaderField:@"X-Signature"];
    }
    
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
            NSLog(@"%@",responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


@end
