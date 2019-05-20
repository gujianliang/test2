//
//  WalletTools.m
//  Wallet
//
//  Created by Tom on 18/4/26.
//  Copyright © VECHAIN. All rights reserved.
//

#import "WalletTools.h"
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "WalletUtils.h"
#import "NSMutableDictionary+Helpers.h"
#import "AFNetworkReachabilityManager.h"
#import "WalletMBProgressShower.h"
#import "WalletDAppHead.h"

@implementation WalletTools


+ (UIViewController*)getCurrentVC {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

+ (NSString *)localStringBundlekey:(NSString *)key{
    NSString *pathString = [[NSBundle mainBundle] pathForResource:@"WalletSDKBundle" ofType:@"bundle"];
    if(!pathString){
        return key;
    }
        
    NSBundle *resourceBundle = [NSBundle bundleWithPath:pathString];
    
    // Get current device language
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    
    NSString *languageCode = @"en";
    if([languageName containsString:@"zh"]){
        languageCode = @"zh-Hans"; 
    }
    NSString *bundlePath = [resourceBundle pathForResource:languageCode ofType:@"lproj"];
    NSBundle *languageBundle = [NSBundle bundleWithPath:bundlePath];
    NSString *translatedString = NSLocalizedStringWithDefaultValue(key, nil, languageBundle, key, key);
    
    return translatedString;
}

+ (UIImage *)localImageWithName:(NSString *)name{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"WalletSDKBundle" ofType:@"bundle"];
    if(!bundlePath){
        return nil;
    }
    
    NSString *imageName = [NSString stringWithFormat:@"%@/%@.png", bundlePath, name];
    UIImage *image = [UIImage imageWithContentsOfFile:imageName];
    if (!image) {
        imageName = [NSString stringWithFormat:@"%@/%@.tiff", bundlePath, name];
        image = [UIImage imageWithContentsOfFile:imageName];
    }
    
    return image;
}

+ (NSString *)checksumAddress:(NSString *)inputAddress
{
    Address *a = [Address addressWithString:inputAddress.lowercaseString];
    if (a) {
        return a.checksumAddress;
    }
    return inputAddress;
}


+ (NSString *)splitLongStr:(NSString *)inputStr
{
    NSMutableArray *strList = [NSMutableArray array];
    for (NSInteger i = inputStr.length; i > 0; i = i - 3) {
        NSString *tmp = @"";
        if (i - 3 <= 0) {
            tmp = [inputStr substringWithRange:NSMakeRange(0 , i)];
        }else{
            tmp = [inputStr substringWithRange:NSMakeRange(i - 3, 3)];
        }
        [strList addObject:tmp];
    }
    
    return [[strList reverseObjectEnumerator].allObjects componentsJoinedByString:@","];
}

+ (NSMutableDictionary *)packageWithRequestId:(NSString *)requestId
                                         data:(id )data
                                         code:(NSInteger)code
                                      message:(NSString *)message
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValueIfNotNil:@(code) forKey:@"code"];
    [paramDict setValueIfNotNil:data forKey:@"data"];
    if (requestId.length > 0) {
        [paramDict setValueIfNotNil:requestId forKey:@"requestId"];
    }
    [paramDict setValueIfNotNil:message forKey:@"message"];
    return paramDict;
}


+ (void)callbackWithrequestId:(NSString *)requestId
                      webView:(WKWebView *)webView
                         data:(id)data
                   callbackId:(NSString *)callbackId
                         code:(NSInteger)code
{
    NSString *message = [self errorMessageWith:code];
    NSDictionary *packageDict = [WalletTools packageWithRequestId:requestId
                                                            data:data
                                                            code:code
                                                         message:message];
    NSString *injectJS = [NSString stringWithFormat:@"%@('%@')",callbackId,[packageDict yy_modelToJSONString]];

    injectJS = [injectJS stringByReplacingOccurrencesOfString:@"\"nu&*ll\"" withString:@"null"];
#if ReleaseVersion
    NSLog(@"injectJS == %@",injectJS);
#endif
    
    [webView evaluateJavaScript:injectJS completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        if (error) {
            #if ReleaseVersion
            NSLog(@"injectJS error == %@",error);
            #endif
        }else {
            #if ReleaseVersion
            NSLog(@"injectJS success");
            #endif
        }
    }];
    
}


+ (NSString *)errorMessageWith:(NSInteger)code
{
    switch (code) {
        case 400:
            return ERROR_NETWORK_MSG;
            break;
        case 500:
            return ERROR_CANCEL_MSG;
            break;
            
        default:
            break;
    }
   return @"";
}

+ (BOOL)checkHEXStr:(NSString *)hex
{
    if (![hex isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if (hex.length == 0) {
        return NO;
    }
    if ([hex.lowercaseString hasPrefix:@"0x"] && hex.length >= 2) {
        NSString *regex =@"[0-9a-fA-F]*";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        return [predicate evaluateWithObject:[hex substringFromIndex:2]];
    }else{
       
        return NO;
    }
}

+ (BOOL)checkDecimalStr:(NSString *)decimalString
{
    if (![decimalString isKindOfClass:[NSString class]]) {
        return NO;
    }
    if (decimalString.length == 0) {
        return NO;
    }
    NSString *regex =@"[0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:decimalString];
}

+ (BOOL)errorAddressAlert:(NSString *)toAddress
{
    if ([toAddress isKindOfClass:[NSNull class]]) {
        return NO;
    }
    
    if (![toAddress isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    BOOL isOK = YES;
    if (toAddress.length != 42) {
        isOK = NO;
        
    }else if (![toAddress.uppercaseString hasPrefix:@"0X"]) {
        isOK = NO;
        
    }else if ([[toAddress substringFromIndex:2].lowercaseString isEqualToString:[toAddress substringFromIndex:2]]) {
        
    }else{ //不是全小写，就验证checksum
        NSString *checksumAddress = [WalletTools checksumAddress:toAddress.lowercaseString];
        if (![[toAddress substringFromIndex:2] isEqualToString:[checksumAddress substringFromIndex:2]]) {
            return NO;
        }
        return YES;
    }
    
    NSString *regex = @"^(0x|0X){1}[0-9A-Fa-f]{40}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL allAreValidChar = [predicate evaluateWithObject:toAddress];
    if (!allAreValidChar) {
        
        return NO;
    }
    return YES;
}

+ (BOOL)checkKeystore:(NSString *)keystore
{
    if (keystore.length == 0) {
        return NO;
    }
    NSDictionary *dictKS = [NSJSONSerialization dictionaryWithJsonString:[keystore lowercaseString]];
    
    NSDictionary *crypto = dictKS[@"crypto"];
    NSString *_id = dictKS[@"id"];
    NSString *version = dictKS[@"version"];
    
    BOOL isOK = NO;
    if ( crypto && _id && version) {
        if ([crypto isKindOfClass:[NSDictionary class]]) {
            NSString *cipher = crypto[@"cipher"];
            NSString *ciphertext = crypto[@"ciphertext"];
            NSDictionary *cipherparams = crypto[@"cipherparams"];
            NSString *kdf = crypto[@"kdf"];
            NSDictionary *kdfparams = crypto[@"kdfparams"];
            NSString *mac = crypto[@"mac"];
            if (cipher && ciphertext && cipherparams && kdf && kdfparams && mac) {
                if ([cipherparams isKindOfClass:[NSDictionary class]] && [kdfparams isKindOfClass:[NSDictionary class]]) {
                    isOK = YES;
                }
            }
        }else{
        }
    }
    return isOK;
}

+ (BOOL)isEmpty:(id )input
{
    if ([input isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if (input == nil) {
        return YES;
    }
    
    if ([input isKindOfClass:[NSString class]] ) {
        NSString *tempInput = (NSString *)input;
        
        if ([tempInput length] == 0) {
            return YES;
        }
        
        if ([tempInput isEqualToString:@"(null)"]) {
            return YES;
        }
    }
    
    return NO;
}

+ (NSString *)packCertParam:(NSDictionary *)param
{
    NSMutableDictionary *dictOrigin = [NSMutableDictionary dictionaryWithDictionary:param];
    
    NSArray *keys = [dictOrigin allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSMutableArray *keyAndValueList = [NSMutableArray array];
    for (NSString *key in sortedArray) {
        NSString *value = dictOrigin[key];
        NSString *keyValue = nil;
        if ([value isKindOfClass:[NSNumber class]]) {
            NSNumber *num = (NSNumber *)value;
            value = ((NSNumber *)num).stringValue;
            
            keyValue = [NSString stringWithFormat:@"\"%@\":%@",key,value];
        }else if([value isKindOfClass:[NSDictionary class]])
        {
            keyValue = [NSString stringWithFormat:@"\"%@\":%@",key, [self packCertParam:(NSDictionary *)value]];
        }else{
            keyValue = [NSString stringWithFormat:@"\"%@\":\"%@\"",key,value];
        }
        
        [keyAndValueList addObject:keyValue];
        
    }
    return [NSString stringWithFormat:@"{%@}",[keyAndValueList componentsJoinedByString:@","]];
}
@end
