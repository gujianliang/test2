//
//  VCBaseApi.h
//  Wallet
//
//  Created by 曾新 on 18/4/7.
//  Copyright © VECHAIN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VCBaseApi.h"
#import "NSMutableDictionary+Helpers.h"
#import "YYModel.h"
#import "NSJSONSerialization+NilDataParameter.h"
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger, WalletRequestStatus){
    NotAvailable = 1,           //不可用
    RequestSuccess = 2,         //请求成功
    RequestFailed = 4,          //请求失败
    RequestLocalData = 8,       //本地请求
    RequestNoMoreContent = 16,  //没有更多数据
};

typedef NS_ENUM(NSInteger,RequestMethod)
{
    RequestPostMethod = 1,      //post  请求
    RequestGetMethod = 2,       //get 请求
    RequestPutMethod = 3,       //put  请求
    RequestDelMethod = 4,       //del  请求
    RequestRAWMethod = 5,       //RAW  请求
};

@class VCBaseApi;
typedef void(^WalletLoadSuccessBlock) (VCBaseApi *finishApi);
typedef void(^WalletLoadFailBlock) (VCBaseApi *finishApi,NSString *errMsg);

typedef void (^requestBlock)(NSDictionary *requestDict,NSError *error);

@interface VCBaseApi : NSObject
{
@protected
    NSString *httpAddress;          // 请求接口地址
    NSMutableDictionary *_requestParmas;    // 请求入参
}
@property (nonatomic, assign) BOOL needToken; // 是否需要带上token
@property (nonatomic, assign) BOOL needEncrypt; // 是否需要加密
@property (nonatomic, assign) WalletRequestStatus status;
@property (nonatomic, strong) NSError *lastError;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, copy)   NSString *pageNo; // 分页
@property (nonatomic, assign) RequestMethod requestMethod;
@property (nonatomic, copy)WalletLoadSuccessBlock successBlock;
@property (nonatomic, copy)WalletLoadFailBlock failBlock;
@property (nonatomic, assign) BOOL specialRequest;// 特殊请求返回处理
@property (nonatomic, copy, readonly) NSString *stubUrlString;      // http stub

@property (nonatomic, strong) NSError *requestError;
/**
 *  请求得到的最终数据模型
 */
@property (strong, nonatomic) id resultModel;
/**
 *  请求得到的全部数据
 */
@property (strong, nonatomic) NSDictionary *resultDict;

@property (strong, nonatomic) NSDictionary *responseHeaderFields;
/**
 *  merge 返回的数据
 *
 *  @param orgArr   原来的array
 *  @param otherArr 新返回的array
 *
 *  @return 合并后的array
 */
+ (NSArray *)mergeOriginalArray:(NSArray *)orgArr withOtherArray:(NSArray *)otherArr;
/**
 *  检查网络
 */
- (void)checkNetwork;

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

// 缓存相关方法
- (void)storeRespondStringToLocal:(NSData *)respondStr;
/**
 *  移除本地存储
 */
- (void)removeLocalRespondString;
/**
 *  获得保存在本地的服务器返回数据
 *
 *  @return NSData 数据
 */
- (NSData *)getLocalRespondString;

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
 *  发起本地存储数据请求
 *
 *  @param success 成功block
 *  @param failure 失败block
 */
- (void)loadLocalDataAsyncWithSuccess:(WalletLoadSuccessBlock)success
                              failure:(WalletLoadFailBlock)failure;
/**
 *  分析错误信息
 *
 *  @param requestDict 服务器返回数据
 *  @param error       error信息
 */
- (void)analyseResponseInfo:(NSDictionary *)requestDict error:(NSError *)error;

- (void)analyseResponseInfo:(NSDictionary *)requestDict
               headerFileds:(NSDictionary *)headerFields
                      error:(NSError *)error;



+(instancetype)modelWithRequestAbsoluteURLString:(NSString *)absoluteString
                                          method:(RequestMethod)method
                                           parms:(NSDictionary *)parms;

@end
