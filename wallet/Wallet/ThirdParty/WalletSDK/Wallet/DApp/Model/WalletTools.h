//
//  WalletTools.h
//  Wallet
//
//  Created by Tom on 18/4/26.
//  Copyright © VECHAIN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WalletUtils.h"
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

+ (NSString *)checksumAddress:(NSString *)inputAddress;

+ (void)checkNetwork:(void(^)(BOOL t))block;

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController;

//dapp store package
+ (NSMutableDictionary *)packageWithRequestId:(NSString *)requestId
                                         data:(id )data
                                         code:(NSInteger)code
                                      message:(NSString *)message;

+ (void)callbackWithrequestId:(NSString *)requestId
                      webView:(WKWebView *)webView
                         data:(id)data
                   callbackId:(NSString *)callbackId
                         code:(NSInteger)code;


+ (UIImage *)localImageWithName:(NSString *)name;

+ (BOOL)errorAddressAlert:(NSString *)toAddress;

+ (BOOL)checkKeystore:(NSString *)keystore;

+ (BOOL)checkHEXStr:(NSString *)hex;

+ (BOOL)checkDecimalStr:(NSString *)decimalString;

+ (BOOL)isEmpty:(id )input;

+ (NSString *)packCertParam:(NSDictionary *)param;

@end





