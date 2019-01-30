//
//  FFBMSModelFetcher.m
//  FFBMS
//
//  Created by 曾新 on 16/4/7.
//  Copyright © 2016年 Eagle. All rights reserved.
//

#import "FFBMSModelFetcher.h"
#import "NSStringAdditions.h"
#import "AFNetworking.h"
#import "NSMutableDictionary+Helpers.h"


@interface FFBMSModelFetcher()

@end

@implementation FFBMSModelFetcher
+ (void)requestGetWithUrl:(NSString*)aUrl
                   params:(NSMutableDictionary*)dict
               useSession:(BOOL)useSession
              needEncrypt:(BOOL)needEncrypt
                    error:(NSError *__autoreleasing *)error
            responseBlock:(responseBlock)block
{
    NSString *urlString = [NSString stringWithString:aUrl];
    AFHTTPSessionManager *httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    if (needEncrypt) {
        dict = [FFBMSModelFetcher encryptParaDict:dict method:@"GET"];
    }
    
    httpManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
//    [FFBMSModelFetcher setHeaderInfo:httpManager useSession:useSession];
    [httpManager GET:urlString parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [FFBMSModelFetcher debugLog:responseObject andUrl:urlString];
        
        NSDictionary *headerFields = [(NSHTTPURLResponse *)task.response allHeaderFields];
//        if (error) {
//            block(nil, headerFields,nil);
//        } else {
            block(responseObject,headerFields,nil);
//        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [FFBMSModelFetcher debugError:error andUrl:urlString];
        
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
    httpManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    if (![aUrl containsString:@"/transactions"]) {
        [FFBMSModelFetcher setHeaderInfo:httpManager useSession:useSession];
    }
//
    
//    if (needEncrypt) {
//        dict = [FFBMSModelFetcher encryptParaDict:dict  method:@"POST"];
//    }
    
    [httpManager POST:urlString parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [FFBMSModelFetcher debugLog:responseObject andUrl:urlString];
        
        NSDictionary *headerFields = [(NSHTTPURLResponse *)task.response allHeaderFields];
//        if (error) {
//            block(nil, headerFields,nil);
//        } else {
//            block(responseObject,headerFields,nil);
//        }
        block(responseObject,headerFields,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [FFBMSModelFetcher debugError:error andUrl:urlString];
        
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
    httpManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    [FFBMSModelFetcher setHeaderInfo:httpManager useSession:useSession];
    
    if (needEncrypt) {
        dict = [FFBMSModelFetcher encryptParaDict:dict method:@"PUT"];
    }
    
    [httpManager PUT:urlString parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [FFBMSModelFetcher debugLog:responseObject andUrl:urlString];
        
        NSDictionary *headerFields = [(NSHTTPURLResponse *)task.response allHeaderFields];
        if (error) {
            block(nil, headerFields,nil);
        } else {
            block(responseObject,headerFields,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [FFBMSModelFetcher debugError:error andUrl:urlString];
        
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
    httpManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    httpManager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"HEAD",@"GET",nil];
    [FFBMSModelFetcher setHeaderInfo:httpManager useSession:useSession];
    
    if (needEncrypt) {
        dict = [FFBMSModelFetcher encryptParaDict:dict method:@"DEL"];
    }
    
    [httpManager DELETE:urlString parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [FFBMSModelFetcher debugLog:responseObject andUrl:urlString];
        
        NSDictionary *headerFields = [(NSHTTPURLResponse *)task.response allHeaderFields];
        if (error) {
            block(nil, headerFields,nil);
        } else {
            block(responseObject,headerFields,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [FFBMSModelFetcher debugError:error andUrl:urlString];
        
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
    httpManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    //    httpManager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"HEAD",@"GET",nil];
    [FFBMSModelFetcher setHeaderInfo:httpManager useSession:useSession];
    
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
                    completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                        if (error) {
                            [FFBMSModelFetcher debugError:error andUrl:request.URL];
                            
                            block(nil, nil, error);
                            
                        }else{
                            
                            [FFBMSModelFetcher debugLog:responseObject andUrl:request.URL];
                            
                            block(responseObject,nil,nil);
                        }
                    }] resume] ;
}

+ (void)setHeaderInfo:(AFHTTPSessionManager *)httpManager useSession:(BOOL)useSession
{
    
//    if ([httpManager.baseURL.absoluteString.lowercaseString hasPrefix:@"https"]) {
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//        [securityPolicy setAllowInvalidCertificates:NO];
//        [securityPolicy setValidatesDomainName:YES];
//        httpManager.securityPolicy = securityPolicy;
//    }
    
    [httpManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
//    [httpManager.requestSerializer setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"] forHTTPHeaderField:@"softwareVersion"];
//    [httpManager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"platformType"];
//
//    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
//    [httpManager.requestSerializer setValue:phoneVersion forHTTPHeaderField:@"osVersion"];
//
//    NSString *idvf = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    [httpManager.requestSerializer setValue:idvf forHTTPHeaderField:@"deviceId"];
}

+ (NSMutableDictionary *)encryptParaDict:(NSMutableDictionary *)dict method:(NSString *)method {
    if (dict && 0 != dict.count)
    {
        NSError *error = nil;
        NSString *origString;
        if ([method isEqualToString:@"GET"]) {
            origString = AFQueryStringFromParameters(dict);
        } else {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
            origString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
       

    }
    return nil;
}

+ (void)debugLog:(id)responseObject andUrl:(id)url{
#ifdef DEBUG
    NSLog(@"\n\n请求地址：%@  decode -- >%@  \n\n", url, responseObject);
#endif
}

+ (void)debugError:(id)responseObject andUrl:(id)url{
#ifdef DEBUG
    NSLog(@"\n\n请求地址：%@  error -- >%@  \n\n", url, responseObject);
#endif
}

@end
