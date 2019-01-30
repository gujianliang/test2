//
//  VCBaseApi.m
//  FFBMS
//
//  Created by 曾新 on 16/4/7.
//  Copyright © 2016年 Eagle. All rights reserved.
//

#import "NSJSONSerialization+NilDataParameter.h"
#import "FFBMSError.h"
#import "VCBaseApi.h"
#import "FFBMSModelFetcher.h"
#import "NSStringAdditions.h"
//#import <JMEncryptBox/JMEncryptBox.h>
//#import "WalletHandle.h"
//#import "NSDate+InternetDateTime.h"

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

-(void)loadDataAsyncWithSuccess:(FFBMSLoadSuccessBlock)success
                        failure:(FFBMSLoadFailBlock)failure
{
    _successBlock = success;
    _failBlock = failure;
    [self checkNetwork];
    if (self.status == NotAvailable || httpAddress == nil) {
        return;
    }
    
    self.isLoading = YES;

#ifdef DEBUG
//    if ([[WalletUserDefaultManager getSaveServerType] intValue] == DEVELOP_SERVER) {
//        self.needEncrypt = NO;
//    }
#endif
    
    NSMutableDictionary *postDict = [self buildRequestDict];
    NSError *error = nil;
    
    switch (_requestMethod) {
        case RequestGetMethod:
        {
            [FFBMSModelFetcher requestGetWithUrl:httpAddress
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
            [FFBMSModelFetcher requestPostWithUrl:httpAddress
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
            [FFBMSModelFetcher requestPutWithUrl:httpAddress
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
            [FFBMSModelFetcher requestDelWithUrl:httpAddress
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
            [FFBMSModelFetcher requestRAWWithUrl:httpAddress
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
    [self saveResponseTime]; //核对服务器时间使用
    NSNumber *errCode = nil;
    NSString *errMsg = nil;
    self.resultModel = responseData; //先给，后面覆盖
    if (responseData != nil) {
        NSDictionary *dict = responseData;
        errCode = [dict valueForKey:@"code"];
        errMsg = [dict valueForKey:@"detail"];
        self.resultDict = dict;
        
        if ([responseData isKindOfClass:[NSArray class]]) {
            self.status = RequestSuccess;
            [self convertJsonResultToModel:responseData];
            self.resultModel = responseData;
            _successBlock(self);
            return;
        }
        
        if ((errCode != nil && [errCode integerValue] == FFBMS_ERROR_OK) || (errCode.integerValue == 0)) {
            
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
            
        } else {
            self.status = RequestFailed;
        }
    } else {
        if ([httpAddress containString:@"transactions"] && [httpAddress hasSuffix:@"receipt"]) {
            self.status = RequestSuccess;
            _successBlock(self);
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
        
        
        switch (errCode.integerValue) {
            case 20001:
                errMsg = NSLocalizedString(@"token_swap_thor_format_error",nil);
                break;
            case 20002:
                errMsg = NSLocalizedString(@"ETH地址不合法",nil);
                break;
            case 20003:
                errMsg = NSLocalizedString(@"关联地址不合法",nil);
                break;
            case 20004:
                errMsg = NSLocalizedString(@"token_swap_thor_binded_error",nil);
                break;
            case 20005:
                errMsg = NSLocalizedString(@"ETH地址已被其他地址绑定",nil);
                break;
            case 20007:
                errMsg = NSLocalizedString(@"VeChainThor地址还未进行过绑定",nil);
                break;
            case 20010:
            {
                
                errMsg = NSLocalizedString(@"token_swap_function_closed",nil);

            }
                break;

            case 30000:
                errMsg = NSLocalizedString(@"企业鉴权信息无效",nil);
                break;
            case 30001:
                errMsg = NSLocalizedString(@"授权回调地址无效",nil);
                break;
            case 30002:
                errMsg = NSLocalizedString(@"授权等级参数无效",nil);
                break;
            case 30003:
                errMsg = NSLocalizedString(@"authorized_error_qr_invalid",nil);
                break;
            case 30004:
                errMsg = NSLocalizedString(@"authorized_address_invalid",nil);
                break;
            case 30005:
                errMsg = NSLocalizedString(@"authorized_signature_invalid",nil);
                break;
            case 30006:
                errMsg = NSLocalizedString(@"authorized_error_qr_invalid",nil);
                break;
            case 30007:
                errMsg = NSLocalizedString(@"白盒加密失败",nil);
                break;
            case 90000:
                errMsg = NSLocalizedString(@"sessiontoken已存在",nil);
                break;
            case 90001:
                errMsg = NSLocalizedString(@"qrcode超时",nil);
                break;
            case 90002:
                errMsg = NSLocalizedString(@"签名校验超时",nil);
                break;
            case 90003:
                errMsg = NSLocalizedString(@"签名校验时间戳不合法",nil);
                break;
                
            default:
                break;
        }
        
        self.lastError = [NSError errorWithDomain:kFFBMSErrorDomain
                                             code:errCode.integerValue
                                         userInfo:@{NSLocalizedFailureReasonErrorKey: errMsg.length > 0 ? errMsg : FFBMS_MSG_ASIHTTP}];
        
    }
    else if (nil == errCode || [errCode intValue] != FFBMS_ERROR_OK) {
        
        if ([errMsg isEqual:[NSNull null]]) {
            errMsg = NSLocalizedString(@"Unknown error", nil);
        }else{
            errMsg = [errMsg length] ? errMsg : NSLocalizedString(@"Unknown error", nil);
        }
        
        self.lastError = [NSError errorWithDomain:kFFBMSErrorDomain
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


- (void)loadLocalDataAsyncWithSuccess:(FFBMSLoadSuccessBlock)success
                              failure:(FFBMSLoadFailBlock)failure
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

- (void)saveResponseTime
{
//    NSString *serverTime = self.responseHeaderFields[@"Date"];
//    if (serverTime.length == 0) {
//        [WalletHandle shareWalletHandle].responseOffset = [NSString stringWithFormat:@"%d",0];
//        return;
//    }
//
//    // 转换方法
//    NSDate *serverData = [NSDate dateFromInternetDateTimeString:serverTime formatHint:DateFormatHintRFC822];
//    NSLog(@"dateString == %@ serverTime == %@ ",serverData,serverTime);
//
//    // 服务器时间 - 当前时间
//    NSTimeInterval offset = [serverData timeIntervalSinceDate:[NSDate date]];
//    NSLog(@"offset === %f",offset);
//
//    [WalletHandle shareWalletHandle].responseOffset = [NSString stringWithFormat:@"%f",offset];
}

@end
