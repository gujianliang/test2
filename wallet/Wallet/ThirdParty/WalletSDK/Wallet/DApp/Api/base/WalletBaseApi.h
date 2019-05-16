//
//  WalletBaseApi.h
//  Wallet
//
//  Created by Tom on 18/4/7.
//  Copyright © VECHAIN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WalletBaseApi.h"
#import "YYModel.h"
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger, WalletRequestStatus){
    NotAvailable = 1,
    RequestSuccess = 2,
    RequestFailed = 4,
};

typedef NS_ENUM(NSInteger,RequestMethod)
{
    RequestPostMethod = 1,      //post
    RequestGetMethod = 2,       //get
};

@class WalletBaseApi;
typedef void(^WalletLoadSuccessBlock) (WalletBaseApi *finishApi);
typedef void(^WalletLoadFailBlock) (WalletBaseApi *finishApi,NSString *errMsg);

typedef void (^requestBlock)(NSDictionary *requestDict,NSError *error);

@interface WalletBaseApi : NSObject
{
    
    
}

@property (nonatomic, copy) WalletLoadSuccessBlock successBlock;
@property (nonatomic, copy) WalletLoadFailBlock failBlock;
@property (nonatomic, copy) NSString *httpAddress; // 请求接口地址
@property (nonatomic, copy) NSMutableDictionary *requestParmas;  // 请求入参
@property (nonatomic, strong) NSError *lastError;
@property (nonatomic, assign) BOOL specialRequest; // Special request return processing
@property (nonatomic, assign) WalletRequestStatus status;
@property (nonatomic, assign) RequestMethod requestMethod;
/**
 *  请求得到的最终数据模型
 */
@property (strong, nonatomic) id resultModel;
/**
 *  请求得到的全部数据
 */
@property (strong, nonatomic) NSDictionary *resultDict;

/**
 *  请求是否支持其他数据类型，默认值 NO 表示是不支持，只支持 JSON
 */
@property (assign, nonatomic) BOOL supportOtherDataFormat;

@property (strong, nonatomic) NSDictionary *responseHeaderFields;

/**

 *  请求参数和字段
 *
 *  @return 请求参数和字段
 */
- (NSMutableDictionary *)buildRequestDict;

/**
 inject depedency outside

 @param dict depednecy
 @return dict
 */
- (NSMutableDictionary *)buildRequestDictWithDepedency:(NSDictionary *)dict;
/**
 *  请求返回
 *
 *  @param dict 服务器返回dict数据
 */
- (void)buildModelWithObjDict:(NSDictionary *)dict;
/**
 *  失败信息
 *
 *  @param error   失败
 *  @param errCode 失败code
 *  @param errMsg  失败信息
 */
- (void)buildErrorInfoWithRequestError:(NSError *)error
                     responseErrorCode:(NSNumber *)errCode
                      responseErrorMsg:(NSString *)errMsg;


/**
 * 如果 entity 直接是数组类型，提供数组内期望的对象类
 *
 */

-(Class)expectedInnerArrayClass;

/**
 *  期望的obj数据类型
 *
 *  @return 期望数据类型，默认是NSDictionary
 */
- (Class)expectedJsonObjClass;

/**
 *  期望返回的Model类型
 *
 *  @return 期望返回的Model类型, 子类需要覆盖此方法，默认为expectedJsonObjClass
 */
- (Class)expectedModelClass;

/**
 *  把obj里面的数据转换为Model，默认调用yy_modelWithDictionary转换
 *
 *  @param jsonDict 后台返回的数据
 */
- (void)convertJsonResultToModel:(NSDictionary *)jsonDict;

/**
 *  发起网络请求
 *
 *  @param success 成功block
 *  @param failure 失败block
 */
- (void)loadDataAsyncWithSuccess:(WalletLoadSuccessBlock)success
                         failure:(WalletLoadFailBlock)failure;

/**
 *  分析错误信息
 *
 *  @param requestDict 服务器返回数据
 *  @param error       error信息
 */
- (void)analyseResponseInfo:(NSDictionary *)requestDict
               headerFileds:(NSDictionary *)headerFields
                      error:(NSError *)error;

@end
