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


+ (NSString *)dateConvertString:(NSDate *)date format:(NSString *)format;

+(NSString*)dateStringFrommSecondString:(NSString*)mSecond format:(NSString *)format;

+ (UIViewController*)getCurrentVC;

+ (void) restoreTabNavToRoot;

+ (BOOL)IsIdentityCard:(NSString *)IDCardNumber;

+(BOOL)isNoNull:(id)Obj;

+(NSString*)appVersion;

+ (BOOL)checkQRcode:(NSString *)code;

+ (NSString*)localeStringWithKey:(NSString*)key; // 去本地包key
+ (NSString *)localStringBundlekey:(NSString *)key; // 取bundle key

+ (UIImage *)walletAddreeConvertImage:(NSString *)address;

+ (NSString *)tokenBalanceData:(NSString *)toAddress;

+ (NSString *)signData:(NSString *)address
                 value:(NSString *)value;

// 1 天以内显示时分，1天以后显示具体年月日时分
+ (NSString *) compareDayTime:(NSString *)str;

+ (NSTimeInterval) compareTimeSpace:(NSString *)str;

+ (NSString *)checksumAddress:(NSString *)inputAddress;

+ (NSString *)getSwapAddress:(NSString *)ethAddress
                thorAddress:(NSString *)thorAddress;
+(UIViewController *)getPresentedViewConreoller;

+ (BOOL)InputCapitalAndLowercaseLetter:(NSString*)string;

+ (void)circualarView:(UIView *)view Radius:(CGFloat)radius;

+ (void)checkNetwork:(void(^)(BOOL t))block;

+(NSString *)keep4Decimal:(NSString *)input;

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController;

+ (NSString *)conventTimeSec:(NSString *)input; // MM/dd/yyyy HH:mm:ss

+ (NSString *)conventTime:(NSString *)input;    // yyyy-MM-dd HH:mm:ss

+ (NSString *)conventInvalidTime:(NSString *)input; // MM/dd/yyyy HH:mm

+ (UIImage*) createImageWithColor: (UIColor*) color;

+ (NSString *)serviceRuleHostWithContent:(NSString *)content;

+ (UIViewController *)viewControllerSupportView:(UIView *)view;

+ (BOOL)addressChecksum:(NSString *)address;

+ (BOOL)checkHasToken:(NSString *)tokenSymbol;

+(BOOL)hasSpecialWord:(NSString *)words;


//查询block节点信息 交易信息
+ (NSString *)blockWtihMethod:(NSString *)methodId tokenID:(NSString *)tokenID;

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

+ (NSString *)removeExtraZeroAtBegin:(NSString *)valueFormated;

+ (BOOL)fromISToAddress:(NSString *)from to:(NSString *)to;

+ (BigNumber *)calcThorNeeded:(float)gasPriceCoef gas:(NSNumber *)gas;

+ (BOOL)errorAddressAlert:(NSString *)toAddress;

+ (BOOL)checkKeystore:(NSString *)keystore;

+ (BOOL)checkHEXStr:(NSString *)hex;

@end





