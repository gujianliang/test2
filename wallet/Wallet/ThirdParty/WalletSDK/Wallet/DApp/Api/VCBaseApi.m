//
//  VCBaseApi.m
//  Wallet
//
//  Created by 曾新 on 18/4/7.
//  Copyright © VECHAIN. All rights reserved.
//

#import "NSJSONSerialization+NilDataParameter.h"
#import "VCBaseApi.h"
#import "WalletModelFetcher.h"
#import "NSStringAdditions.h"

@implementation VCBaseApi
{

}

-(NSString *)stubUrlString {
    return self->httpAddress;
}

- (id)init
{
    if (self  = [super init]) {
        _needToken = NO;
        _needEncrypt = NO;
        httpAddress = @"";
        self.requestMethod = RequestGetMethod;
    }
    return self;
}


+(instancetype)modelWithRequestAbsoluteURLString:(NSString *)absoluteString
                                          method:(RequestMethod)method
                                           parms:(NSDictionary *)parms {
    VCBaseApi *instance = [[self alloc] init];
    instance->httpAddress = absoluteString;
    instance.requestMethod = method;
    [instance buildRequestDictWithDepedency:parms];
    return instance;
}

/**
 *  obj 属性返回类型
 */
- (Class)expectedJsonObjClass
{
    return [NSDictionary class];
}

/**
 * 如果 entity 直接是数组类型，提供数组内的对象类
 *
 */

-(Class)expectedInnerArrayClass{
    return [NSDictionary class];
}

/**
 *  obj 属性值类型
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

+ (NSArray *)mergeOriginalArray:(NSArray *)orgArr withOtherArray:(NSArray *)otherArr;
{
    if (otherArr.count == 0) {
        return orgArr;
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:orgArr];
    for (int i = 0; i < otherArr.count; i++) {
        id object = [otherArr objectAtIndex:i];
        if (!orgArr || [orgArr indexOfObject:object] == NSNotFound) {
            [array addObject:object];
        }
    }
    
    return array;
}

- (NSString *)getLocalJsonStrKey
{
    return [NSStringFromClass([self class]) stringByAppendingString:@"ModelJsonKey"];
}

-(void)checkNetwork
{
    self.status = RequestSuccess;//always return ok, skip the network check step
}

- (NSMutableDictionary *)buildRequestDict
{
    if (!_requestParmas) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        _requestParmas = dict;
    }
    return _requestParmas;
}

- (NSMutableDictionary *)buildRequestDictWithDepedency:(NSDictionary *)dict {
    _requestParmas = dict.mutableCopy;
    return _requestParmas;
}

- (void)buildModelWithObjDict:(NSDictionary *)dict;
{
}

- (void)loadLocalDataAsync
{
    NSData *localJsonData = [self getLocalRespondString];
    
    if ([localJsonData length]) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithDataMayBeNil:localJsonData
                                                                     options:kNilOptions
                                                                       error:nil];
        
        if (!dict || [dict isKindOfClass:[self expectedJsonObjClass]]) {
            self.status = RequestLocalData;
            [self convertJsonResultToModel:dict];
        } else {
            self.status = RequestFailed;
            [self removeLocalRespondString];
        }
    } else {
        self.status = RequestFailed;
    }
}

-(void)loadDataAsyncWithSuccess:(WalletLoadSuccessBlock)success
                        failure:(WalletLoadFailBlock)failure
{
    _successBlock = success;
    _failBlock = failure;
    [self checkNetwork];
    if (self.status == NotAvailable || httpAddress == nil) {
        return;
    }
    
    self.isLoading = YES;
    
    NSMutableDictionary *postDict = [self buildRequestDict];
    NSError *error = nil;
    
    switch (_requestMethod) {
        case RequestGetMethod:
        {
            [WalletModelFetcher requestGetWithUrl:httpAddress
                                          params:postDict
                                      useSession:_needToken
                                     needEncrypt:_needEncrypt
                                           error:&error
                                   responseBlock:^(NSDictionary *responseDict, NSDictionary *responseHeaderFields, NSError *error) {
                                       
                                       [self analyseResponseInfo:responseDict
                                                    headerFileds:responseHeaderFields
                                                           error:error];
                                   }];
        }
            break;
        
        case RequestPostMethod:
        {
            [WalletModelFetcher requestPostWithUrl:httpAddress
                                           params:postDict
                                       useSession:_needToken
                                      needEncrypt:_needEncrypt
                                            error:&error
                                    responseBlock:^(NSDictionary *responseDict, NSDictionary *responseHeaderFields, NSError *error) {
                                        
                                        [self analyseResponseInfo:responseDict
                                                     headerFileds:responseHeaderFields
                                                            error:error];
                                    }];
        }
            break;
        case RequestPutMethod:
        {
            [WalletModelFetcher requestPutWithUrl:httpAddress
                                           params:postDict
                                       useSession:_needToken
                                     needEncrypt:_needEncrypt
                                            error:&error
                                    responseBlock:^(NSDictionary *responseDict, NSDictionary *responseHeaderFields, NSError *error) {
                                       
                                       [self analyseResponseInfo:responseDict
                                                    headerFileds:responseHeaderFields
                                                           error:error];
                                   }];
        }
            break;
        case RequestDelMethod:
        {
            [WalletModelFetcher requestDelWithUrl:httpAddress
                                          params:postDict
                                      useSession:_needToken
                                     needEncrypt:_needEncrypt
                                           error:&error
                                   responseBlock:^(NSDictionary *responseDict, NSDictionary *responseHeaderFields, NSError *error) {
                                        
                                        [self analyseResponseInfo:responseDict
                                                     headerFileds:responseHeaderFields
                                                            error:error];
                                    }];
        }
        break;
        
        case RequestRAWMethod:
        {
            [WalletModelFetcher requestRAWWithUrl:httpAddress
                                          params:postDict
                                      useSession:_needToken
                                           error:&error
                                   responseBlock:^(NSDictionary *responseDict, NSDictionary *responseHeaderFields, NSError *error) {
                                       
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

- (void)analyseResponseInfo:(NSDictionary *)responseData error:(NSError *)error
{
    [self analyseResponseInfo:responseData
                 headerFileds:nil
                        error:error];
}

- (void)analyseResponseInfo:(NSDictionary *)responseData
               headerFileds:(NSDictionary *)headerFields
                      error:(NSError *)error {
    self.responseHeaderFields = headerFields;
    NSNumber *errCode = nil;
    NSString *errMsg = nil;
    self.resultModel = responseData; //先给，后面覆盖
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
            
            if ([responseData isKindOfClass:[NSString class]]) { // 说明是 3840 返回格式不符
                
                [self convertJsonResultToModel:nil];
                self.resultModel = nil;
                
                if (self.supportOtherDataFormat) { // 支持其他数据模型
                    self.resultDict = nil;
                    self.status = RequestSuccess;
                    _successBlock(self);
                    return;
                    
                }else { // 不支持
                    errCode = @(3840);
                    
                     // 注释代码，暂且不用，下面的方法中有引用到error 对象
//                    error = [NSError errorWithDomain:NSCocoaErrorDomain
//                                                code:errCode.integerValue
//                                            userInfo:@{NSLocalizedDescriptionKey: @"不支持非json数据结构"}];
                    self.status = RequestFailed;
                }
                
            }else { //说明是其他数据模型
                
                id objDict = nil;
                NSDictionary *dictEntity = [dict objectForKey:@"data"];
                NSDictionary *dictPage = [dict objectForKey:@"page"];
                if (_specialRequest) {
                    objDict = responseData;
                }else if(dictEntity != nil && dictEntity != (NSDictionary *)[NSNull null]) {
                    objDict = dictEntity;
                }else if(dictPage != nil && dictPage != (NSDictionary *)[NSNull null]){
                    objDict = dictPage;
                }else{
                    objDict = responseData;
                }
                
                if(objDict && [objDict isKindOfClass:[NSDictionary class]]){  // 返回的有可能不是dict
                    if ([objDict objectForKey:@"pageNo"] != [NSNull null]
                        && [objDict objectForKey:@"pageNo"] !=  nil) {
                        
                        self.pageNo = [NSString stringWithFormat:@"%ld",([[objDict objectForKey:@"pageNo"] integerValue] + 1)];
                        
                    }else if ([objDict objectForKey:@"page"] != [NSNull null]
                              && [objDict objectForKey:@"page"] != nil) {
                        
                        self.pageNo = [NSString stringWithFormat:@"%ld",([[objDict objectForKey:@"page"] integerValue] + 1)];
                        
                    }
                    
                    self.status = RequestSuccess;
                    [self convertJsonResultToModel:objDict];
                    if(self.resultModel){
                        [self storeRespondStringToLocal:self.resultModel];
                    }
                }else if(objDict && [objDict isKindOfClass:[NSArray class]]){
                    self.status = RequestSuccess;
                    
                    //entity 最外层直接为数组的情况
                    self.resultModel = [NSArray yy_modelArrayWithClass:[self expectedInnerArrayClass] json:objDict];
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
        if ([httpAddress containsString:@"transactions"] && [httpAddress hasSuffix:@"receipt"]) {
            self.status = RequestSuccess;
            _successBlock(self);
            return;
            
        }else{
            self.status = RequestFailed;
        }
    }
    
    [self buildErrorInfoWithRequestError:error
                       responseErrorCode:errCode
                        responseErrorMsg:errMsg];
    
    self.isLoading = NO;
}

- (void)buildErrorInfoWithRequestError:(NSError *)error
                     responseErrorCode:(NSNumber *)errCode
                      responseErrorMsg:(NSString *)errMsg
{
    if (error) {
        // ASIHttpRequest发送请求时发生错误，现在都统一默认为网络不可用。
        NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
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

- (void)storeRespondStringToLocal:(NSData *)respondStr
{}

- (void)removeLocalRespondString
{}

- (NSData *)getLocalRespondString
{
    return nil;
}


- (void)loadLocalDataAsyncWithSuccess:(WalletLoadSuccessBlock)success
                              failure:(WalletLoadFailBlock)failure
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadLocalDataAsync];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.status == RequestLocalData && success) {
                success(self);
            }
            else if (self.status != RequestLocalData && failure) {
                failure(self, [self.lastError localizedFailureReason]);
            }
        });
    });
}

@end
