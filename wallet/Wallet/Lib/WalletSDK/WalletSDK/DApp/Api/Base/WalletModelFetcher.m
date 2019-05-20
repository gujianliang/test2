//
//  WalletModelFetcher.m
//  Wallet
//
//  Created by Tom on 18/4/7.
//  Copyright © VECHAIN. All rights reserved.
//

#import "WalletModelFetcher.h"
#import "NSStringAdditions.h"
#import "AFNetworking.h"
#import "NSMutableDictionary+Helpers.h"

@interface WalletModelFetcher()

@end

@implementation WalletModelFetcher

+ (void)requestGetWithUrl:(NSString*)aUrl
                   params:(NSMutableDictionary*)dict
            responseBlock:(responseBlock)block
{
    NSString *urlString = [NSString stringWithString:aUrl];
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    httpManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [httpManager GET:urlString parameters:dict  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *headerFields = [(NSHTTPURLResponse *)task.response allHeaderFields];

        block(responseObject,headerFields,nil);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSDictionary *headerFields = [(NSHTTPURLResponse *)task.response allHeaderFields];
        block(nil,headerFields,error);
    }];
    
}

+ (void)requestPostWithUrl:(NSString*)aUrl
                    params:(NSMutableDictionary*)dict
             responseBlock:(responseBlock)block
{
    NSString *urlString = [NSString stringWithString:aUrl];
    
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    httpManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;

    [WalletModelFetcher setHeaderInfo:httpManager];
    
    [httpManager POST:urlString parameters:dict  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *headerFields = [(NSHTTPURLResponse *)task.response allHeaderFields];
        block(responseObject,headerFields,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *headerFields = [(NSHTTPURLResponse *)task.response allHeaderFields];
        block(nil,headerFields,error);
    }];
}


+ (void)setHeaderInfo:(AFHTTPSessionManager *)httpManager
{
    [httpManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
}


@end
