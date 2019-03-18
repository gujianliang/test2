//
//  WalletTools.h
//  Wallet
//
//  Created by 曾新 on 18/4/26.
//  Copyright © VECHAIN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WalletUtils.h"
#import "WalletAddressAuthModel.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>
#import <WebKit/WebKit.h>
#import "BigNumber.h"


#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

@interface WalletTools : NSObject

+ (UIViewController*)getCurrentVC;

+ (UIViewController*)getCurrentNavVC;

+ (NSString*)localeStringWithKey:(NSString*)key; // 去本地包key
+ (NSString *)localStringBundlekey:(NSString *)key; // 取bundle key

+ (NSString *)tokenBalanceData:(NSString *)toAddress;

+ (NSString *)signData:(NSString *)address
                 value:(NSString *)value;

+ (NSString *)checksumAddress:(NSString *)inputAddress;

+ (void)checkNetwork:(void(^)(BOOL t))block;

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController;

//合约签名，data 数据准备
+ (NSString *)contractMethodId:(NSString *)methodId params:(NSArray *)params;

// 10进制转千分符格式， decimals 是否保留小数 结尾 甚至【.00】
+ (NSString *)thousandSeparator:(NSString *)inputStr decimals:(BOOL)decimals;

//dapp store package
+ (NSMutableDictionary *)packageWithRequestId:(NSString *)requestId
                                         data:(id )data
                                         code:(NSInteger)code
                                      message:(NSString *)message;

// 十六进制转换为普通字符串的
+ (NSString *)stringFromHexString:(NSString *)hexString;

// abi decode
+ (NSString *)abiDecodeString:(NSString *)input;

+ (void)callbackWithrequestId:(NSString *)requestId
                      webView:(WKWebView *)webView
                         data:(id)data
                   callbackId:(NSString *)callbackId
                         code:(NSInteger)code;

+ (void)jsErrorAlert:(NSString *)message;

+ (UIImage *)localImageWithName:(NSString *)name;

+ (BOOL)fromISToAddress:(NSString *)from to:(NSString *)to;

+ (BigNumber *)calcThorNeeded:(float)gasPriceCoef gas:(NSNumber *)gas;

+ (BOOL)errorAddressAlert:(NSString *)toAddress;

+ (BOOL)checkKeystore:(NSString *)keystore;

+ (BOOL)checkHEXStr:(NSString *)hex;

+ (NSString *)getAmountFromClause:(NSString *)clauseStr to:(NSString **)to;

+ (BOOL)checkDecimalStr:(NSString *)decimalString;

+ (BOOL)checkClauseDataFormat:(NSString *)clauseStr toAddress:(NSString *)toAddress bToken:(BOOL)bToken;

+ (NSString *)errorMessageWith:(NSInteger)code;

@end





