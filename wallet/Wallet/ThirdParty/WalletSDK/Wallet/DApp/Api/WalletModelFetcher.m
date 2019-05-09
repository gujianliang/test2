//
//  WalletModelFetcher.m
//  Wallet
//
//  Created by 曾新 on 18/4/7.
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
               useSession:(BOOL)useSession
              needEncrypt:(BOOL)needEncrypt
                    error:(NSError *__autoreleasing *)error
            responseBlock:(responseBlock)block
{
    NSString *urlString = [NSString stringWithString:aUrl];
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    httpManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [httpManager GET:urlString parameters:dict  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [WalletModelFetcher debugLog:responseObject andUrl:urlString];
        
        NSDictionary *headerFields = [(NSHTTPURLResponse *)task.response allHeaderFields];

        block(responseObject,headerFields,nil);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [WalletModelFetcher debugError:error andUrl:urlString];
        
        NSDictionary *headerFields = [(NSHTTPURLResponse *)task.response allHeaderFields];
        block(nil,headerFields,error);
    }];
    
}

+ (void)requestPostWithUrl:(NSString*)aUrl
                    params:(NSMutableDictionary*)dict
                useSession:(BOOL)useSession
               needEncrypt:(BOOL)needEncrypt
                     error:(NSError *__autoreleasing *)error
             responseBlock:(responseBlock)block
{
    NSString *urlString = [NSString stringWithString:aUrl];
    
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    httpManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;

    [WalletModelFetcher setHeaderInfo:httpManager useSession:useSession];
    
    [httpManager POST:urlString parameters:dict  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [WalletModelFetcher debugLog:responseObject andUrl:urlString];
        
        NSDictionary *headerFields = [(NSHTTPURLResponse *)task.response allHeaderFields];
        block(responseObject,headerFields,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [WalletModelFetcher debugError:error andUrl:urlString];
        
        NSDictionary *headerFields = [(NSHTTPURLResponse *)task.response allHeaderFields];
        block(nil,headerFields,error);
    }];
}

+ (void)requestPutWithUrl:(NSString*)aUrl
                   params:(NSMutableDictionary*)dict
               useSession:(BOOL)useSession
              needEncrypt:(BOOL)needEncrypt
                    error:(NSError *__autoreleasing *)error
            responseBlock:(responseBlock)block
{
    NSString *urlString = [NSString stringWithString:aUrl];
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    httpManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [WalletModelFetcher setHeaderInfo:httpManager useSession:useSession];
    
    [httpManager PUT:urlString parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [WalletModelFetcher debugLog:responseObject andUrl:urlString];
        
        NSDictionary *headerFields = [(NSHTTPURLResponse *)task.response allHeaderFields];
        if (error) {
            block(nil, headerFields,nil);
        } else {
            block(responseObject,headerFields,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [WalletModelFetcher debugError:error andUrl:urlString];
        
        NSDictionary *headerFields = [(NSHTTPURLResponse *)task.response allHeaderFields];
        block(nil,headerFields,error);
    }];
}

+ (void)requestDelWithUrl:(NSString*)aUrl
                   params:(NSMutableDictionary*)dict
               useSession:(BOOL)useSession
              needEncrypt:(BOOL)needEncrypt
                    error:(NSError *__autoreleasing *)error
            responseBlock:(responseBlock)block
{
    NSString *urlString = [NSString stringWithString:aUrl];
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    httpManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    httpManager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"HEAD",@"GET",nil];
    [WalletModelFetcher setHeaderInfo:httpManager useSession:useSession];
    
    [httpManager DELETE:urlString parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [WalletModelFetcher debugLog:responseObject andUrl:urlString];
        
        NSDictionary *headerFields = [(NSHTTPURLResponse *)task.response allHeaderFields];
        if (error) {
            block(nil, headerFields,nil);
        } else {
            block(responseObject,headerFields,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [WalletModelFetcher debugError:error andUrl:urlString];
        
        NSDictionary *headerFields = [(NSHTTPURLResponse *)task.response allHeaderFields];
        block(nil,headerFields,error);
    }];
}

+ (void)requestRAWWithUrl:(NSString*)aUrl
                   params:(NSMutableDictionary*)dict
               useSession:(BOOL)useSession
                    error:(NSError *__autoreleasing *)error
            responseBlock:(responseBlock)block{
    
    NSString *urlString = [NSString stringWithString:aUrl];
    
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    httpManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;

    [WalletModelFetcher setHeaderInfo:httpManager useSession:useSession];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSData *postBody = [dict[@"RAW"] dataUsingEncoding:NSUTF8StringEncoding];
    // Add Content-Length header if your server needs it
    unsigned long long postLength = postBody.length;
    NSString *contentLength = [NSString stringWithFormat:@"%llu", postLength];
    [request addValue:contentLength forHTTPHeaderField:@"Content-Length"];
    
    // This should all look familiar...
    request.timeoutInterval = 10;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPMethod = @"POST";
    [request setHTTPBody:postBody];
    
    [[httpManager dataTaskWithRequest:request
                    completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
    {
                        if (error) {
                            [WalletModelFetcher debugError:error andUrl:request.URL];
                            
                            block(nil, nil, error);
                            
                        }else{
                            
                            [WalletModelFetcher debugLog:responseObject andUrl:request.URL];
                            
                            block(responseObject,nil,nil);
                        }
                    }] resume] ;
}

+ (void)setHeaderInfo:(AFHTTPSessionManager *)httpManager useSession:(BOOL)useSession
{
    [httpManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
}

+ (void)debugLog:(id)responseObject andUrl:(id)url{
#if ReleaseVersion
//    NSLog(@"\n\n请求地址：%@  decode -- >%@  \n\n", url, responseObject);
#endif
}

+ (void)debugError:(id)responseObject andUrl:(id)url{
#if ReleaseVersion
//    NSLog(@"\n\n请求地址：%@  error -- >%@  \n\n", url, responseObject);
#endif
}

@end
