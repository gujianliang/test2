//
//  WalletBaseApi.m
//  Wallet
//
//  Created by Tom on 18/4/7.
//  Copyright © VECHAIN. All rights reserved.
//

#import "WalletBaseApi.h"
#import "WalletModelFetcher.h"
#import "NSStringAdditions.h"
#import "NSObject+LKModel.h"

@implementation WalletBaseApi


- (id)init
{
    if (self  = [super init]) {
        self.httpAddress = @"";
        self.requestMethod = RequestGetMethod;
    }
    return self;
}


/**
 *  Obj attribute return type
 */
- (Class)expectedJsonObjClass
{
    return [NSDictionary class];
}

/**
 *  Obj attribute value type
 */
- (Class)expectedModelClass
{
    return [self expectedJsonObjClass];
}

- (void)convertJsonResultToModel:(NSDictionary *)jsonDict
{
    if ([self expectedModelClass] == nil ||
        [self expectedModelClass] == [self expectedJsonObjClass]) {
        self.resultModel = jsonDict;
    } else {
        self.resultModel = [[self expectedModelClass] yy_modelWithDictionary:jsonDict];
    }
}

- (NSMutableDictionary *)buildRequestDict
{
    if (!_requestParmas) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        _requestParmas = dict;
    }
    return _requestParmas;
}


-(void)loadDataAsyncWithSuccess:(WalletLoadSuccessBlock)success
                        failure:(WalletLoadFailBlock)failure
{
    _successBlock = success;
    _failBlock = failure;
    if ( _httpAddress == nil) {
        _failBlock(self,@"");
        return;
    }
    
    NSMutableDictionary *postDict = [self buildRequestDict];
    NSError *error = nil;
    switch (_requestMethod) {
        case RequestGetMethod:
        {
            [WalletModelFetcher requestGetWithUrl:_httpAddress
                                          params:postDict
                                           error:&error
                                   responseBlock:^(NSDictionary *responseDict, NSDictionary *responseHeaderFields, NSError *error)
            {
               [self analyseResponseInfo:responseDict
                            headerFileds:responseHeaderFields
                                   error:error];
            }];
        }
            break;
        
        case RequestPostMethod:
        {
            [WalletModelFetcher requestPostWithUrl:_httpAddress
                                           params:postDict
                                            error:&error
                                    responseBlock:^(NSDictionary *responseDict, NSDictionary *responseHeaderFields, NSError *error)
            {
                [self analyseResponseInfo:responseDict
                             headerFileds:responseHeaderFields
                                    error:error];
                
            }];
        }
            break;
                    
        default:
            break;
    }
}

- (void)analyseResponseInfo:(NSDictionary *)responseData
               headerFileds:(NSDictionary *)headerFields
                      error:(NSError *)error {

    NSNumber *errCode = nil;
    NSString *errMsg = nil;
    self.resultModel = responseData;
    if (responseData != nil) {
        NSDictionary *dict = responseData;
        errCode = [dict valueForKey:@"code"];
        errMsg = [dict valueForKey:@"message"];
        self.resultDict = dict;
        
        if ([responseData isKindOfClass:[NSArray class]]) {
            self.status = RequestSuccess;
            [self convertJsonResultToModel:responseData];
            self.resultModel = responseData;
            _successBlock(self);
            return;
        }
        
        if ((errCode != nil && [errCode integerValue] == 1) || (errCode.integerValue == 0)) {
            
            if ([responseData isKindOfClass:[NSString class]]) { //  3840 Return format does not match
                
                [self convertJsonResultToModel:nil];
                self.resultModel = nil;
                
                if (self.supportOtherDataFormat) { // support other data models
                    self.resultDict = nil;
                    self.status = RequestSuccess;
                    _successBlock(self);
                    return;
                    
                }else { // not support
                    errCode = @(3840);
                    
                    self.status = RequestFailed;
                }
                
            }else { //Other data models
                
                id objDict = nil;
                NSDictionary *dictEntity = [dict objectForKey:@"data"];
                if (_specialRequest) {
                    objDict = responseData;
                }else if(dictEntity != nil && dictEntity != (NSDictionary *)[NSNull null]) {
                    objDict = dictEntity;
                }else{
                    objDict = responseData;
                }
                
                if(objDict && [objDict isKindOfClass:[NSDictionary class]]){  // The return may not be dict
                    
                    self.status = RequestSuccess;
                    [self convertJsonResultToModel:objDict];
                    
                }else{
                    self.status = RequestSuccess;
                    self.resultModel = objDict;
                }
                self.status = RequestSuccess;
                _successBlock(self);
                return;
            }
            
        } else {
            self.status = RequestFailed;
        }
        
    } else {
#warning test
        if ([_httpAddress containsString:@"transactions"] && [_httpAddress hasSuffix:@"receipt"]) {
            self.status = RequestSuccess;
            _successBlock(self);
            return;
            
        }else{
            
            if (self.supportOtherDataFormat) {
                if (error.code == 3840) {
                    self.resultDict = nil;
                    self.status = RequestSuccess;
                    _successBlock(self);
                    return;
                }else{
                    self.status = RequestFailed;
                }
            }else{
                self.status = RequestFailed;
            }
        }
    }
    
    [self buildErrorInfoWithRequestError:error
                       responseErrorCode:errCode
                        responseErrorMsg:errMsg];
    
}

- (void)buildErrorInfoWithRequestError:(NSError *)error
                     responseErrorCode:(NSNumber *)errCode
                      responseErrorMsg:(NSString *)errMsg
{
    if (error) {
        // An error occurred while sending the request, and now the default is that the network is unavailable.
        NSData *errorData = error.userInfo[@"response.error.data"];
        NSString *errorInfo = [[NSString alloc]initWithData:errorData encoding:NSUTF8StringEncoding];
        
        NSDictionary *dictError = [NSJSONSerialization dictionaryWithJsonString:errorInfo];
        
        NSString *temp = dictError[@"message"];
        errMsg = temp.length > 0 ? temp : @"no network";
        errCode = dictError[@"code"];
        
        self.lastError = [NSError errorWithDomain:@"Wallet"
                                             code:errCode.integerValue
                                         userInfo:@{NSLocalizedFailureReasonErrorKey: errMsg.length > 0 ? errMsg : VCNSLocalizedBundleString(@"no_network_hint", nil)}];
        
    }
    else if (nil == errCode || [errCode intValue] != 1) {
        
        if ([errMsg isEqual:[NSNull null]]) {
            errMsg = VCNSLocalizedBundleString(@"Unknown error", nil);
        }else{
            errMsg = [errMsg length] ? errMsg : VCNSLocalizedBundleString(@"Unknown error", nil);
        }
        
        self.lastError = [NSError errorWithDomain:@"Wallet"
                                             code:[errCode integerValue]
                                         userInfo:@{NSLocalizedFailureReasonErrorKey:errMsg}];
    } else {
        self.lastError = nil;
    }
    if (self.status == RequestFailed) {
        if (_failBlock) {
            _failBlock(self,errMsg);
        }
    }
}


@end
