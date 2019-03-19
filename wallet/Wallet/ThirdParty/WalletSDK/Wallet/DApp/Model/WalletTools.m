//
//  WalletTools.m
//  Wallet
//
//  Created by 曾新 on 18/4/26.
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
#import "WalletGetBaseGasPriceApi.h"

@implementation WalletTools


+ (UIViewController*)getCurrentVC {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController*)getCurrentNavVC {
    UIViewController *currentVC = [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    
    if (currentVC.navigationController == nil) {
        return currentVC;
    }
    return currentVC.navigationController;
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

+ (NSString*)localeStringWithKey:(NSString*)key{

    NSString *languageCode = [WalletUserDefaultManager getLanuage];
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:languageCode ofType:@"lproj"];
    NSBundle *languageBundle = [NSBundle bundleWithPath:bundlePath];
    NSString *translatedString = [languageBundle localizedStringForKey:key value:@"" table:nil];
    
    if (translatedString.length < 1) {
        
        translatedString = NSLocalizedStringWithDefaultValue(key, nil, [NSBundle mainBundle], key, key);
    }
    return translatedString;
}

+ (NSString *)localStringBundlekey:(NSString *)key{
    NSString *pathString1 = [[NSBundle mainBundle] pathForResource:@"WalletSDKBundle" ofType:@"bundle"];
    if(!pathString1){
        return key;
    }
        
    NSBundle *resourceBundle = [NSBundle bundleWithPath:pathString1];
    
    // 获取当前设备语言
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    
    NSString *languageCode = @"en"; // 英文
    if([languageName containsString:@"zh"]){
        languageCode = @"zh-Hans"; // 中文
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

//查询thor 余额
+ (NSString *)tokenBalanceData:(NSString *)toAddress
{
    if ([[toAddress lowercaseString] hasPrefix:@"0x"]) {
        toAddress = [toAddress stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    }
    NSString *head = @"0x70a08231000000000000000000000000";
    NSString *data = [NSString stringWithFormat:@"%@%@",head,toAddress];
    return data;
}

//转账 thor data 的值
+ (NSString *)signData:(NSString *)address
                 value:(NSString *)value
{
    NSString *head = @"0xa9059cbb";
    NSString *newAddrss = [NSString stringWithFormat:@"000000000000000000000000%@",[address substringFromIndex:2]];
    NSInteger t = 64 - [value substringFromIndex:2].length;
    NSMutableString *zero = [NSMutableString new];
    for (int i = 0; i < t; i++) {
         [zero appendString:@"0"];
    }
    NSString *newValue = [NSString stringWithFormat:@"%@%@",zero,[value substringFromIndex:2]];
    NSString *result = [NSString stringWithFormat:@"%@%@%@",head,newAddrss,newValue];
    return  result;
}

+ (NSString *)checksumAddress:(NSString *)inputAddress
{
    Address *a = [Address addressWithString:inputAddress.lowercaseString];
    if (a) {
        return a.checksumAddress;
    }
    return inputAddress;
}

// 大小写
+ (BOOL)InputCapitalAndLowercaseLetter:(NSString*)string
{
    NSString *regex =@"[a-zA-Z]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL  inputString = [predicate evaluateWithObject:string];
    return inputString;
}

+ (void)checkNetwork:(void(^)(BOOL t))block
{
    BOOL result = YES;
    AFNetworkReachabilityManager *reachManager = [AFNetworkReachabilityManager sharedManager];
    if (![reachManager isReachable]) {

        UIViewController * vc= [WalletTools getCurrentVC];
        UIView *cententView = vc.view;
        if (vc.navigationController) {
            cententView = vc.navigationController.view;
        }
        [WalletMBProgressShower showTextIn:cententView
                                     Text:VCNSLocalizedBundleString(@"no_network_hint", nil)
                                   During:1.5];
        result = NO;
    }
    if (block) {
        block(result);
    }
}

+ (BOOL)checkEthAddress:(NSString *)address
{
    NSString *regex =@"[0-9a-fA-F]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:address];
}


//合约签名，data 数据准备
+ (NSString *)contractMethodId:(NSString *)methodId params:(NSArray *)params
{
    NSString *totalData = methodId;
    for (NSString *param in params) {
        NSInteger t = 64 - [param substringFromIndex:2].length;
        NSMutableString *zero = [NSMutableString new];
        for (int i = 0; i < t; i++) {
            [zero appendString:@"0"];
        }
        NSString *newValue = [NSString stringWithFormat:@"%@%@",zero,[param substringFromIndex:2]];

        totalData = [totalData stringByAppendingString:newValue];
    }
    return totalData;
}

+ (NSString *)thousandSeparator:(NSString *)inputStr decimals:(BOOL)decimals
{
    if (inputStr.length == 0) {
        return @"";
    }
    NSArray *comSep = [inputStr componentsSeparatedByString:@"."];
    if (comSep.count > 1) { // 有小数部分
        if (decimals) { // 需要小数
            NSString *tempDecimals = comSep[1];
            if (tempDecimals.length < 2) {
                return [NSString stringWithFormat:@"%@.%@0",[self splitLongStr:comSep[0]],comSep[1]];
            }else if (tempDecimals.length == 2)
            {
                return [NSString stringWithFormat:@"%@.%@",[self splitLongStr:comSep[0]],comSep[1]];

            }else{
                tempDecimals = [tempDecimals substringToIndex:2];
                return [NSString stringWithFormat:@"%@.%@",[self splitLongStr:comSep[0]],tempDecimals];
            }
            
        }else{
            return [NSString stringWithFormat:@"%@.%@",[self splitLongStr:comSep[0]],comSep[1]];
        }
        
    }else{  // 无小数部分
        if (decimals) {
            return [[self splitLongStr:inputStr] stringByAppendingString:@".00"];
        }else{
            return [self splitLongStr:inputStr];
        }
    }
    return @"";
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


// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString
{
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    return unicodeString;
}

+ (NSString *)abiDecodeString:(NSString *)input
{
    input = [input stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    NSString *first = [input substringWithRange:NSMakeRange(0, 64)];
    first = [NSString stringWithFormat:@"0x%@",first];
    //16进制转10
    NSString *strLength = [BigNumber bigNumberWithHexString:first].decimalString;
    NSString *last = [input substringWithRange:NSMakeRange(64, input.length - 64)];
    
    NSString *second = [last substringWithRange:NSMakeRange(0, strLength.integerValue * 2)];
    NSInteger secondLength = [BigNumber bigNumberWithHexString:[NSString stringWithFormat:@"0x%@",second]].decimalString.integerValue;
    
    NSString *result = [last substringWithRange:NSMakeRange(strLength.integerValue * 2, last.length - strLength.integerValue * 2)];
    
    NSString *realText = [result substringWithRange:NSMakeRange(0, secondLength * 2)];
    
    NSString *rr = [WalletTools stringFromHexString:realText];
    return rr;
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

#if ReleaseVersion
    NSLog(@"injectJS == %@",injectJS);
#endif
    
    [webView evaluateJavaScript:injectJS completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        if (error) {
            NSLog(@"injectJS error == %@",error);
        }else {
            NSLog(@"injectJS success");
        }
    }];
    
    if (code != 1 && code != 500) {
//        [self jsErrorAlert:message];
    }
}

+ (NSString *)errorMessageWith:(NSInteger)code
{
    switch (code) {
        case 200:
           return ERROR_REQUEST_PARAMS_MSG;
            break;
        case 201:
           return ERROR_REQUEST_METHOD_MSG;
            break;
        case 202:
           return ERROR_REQUEST_MULTI_CLAUSE_MSG;
            break;
        case 203:
            return ERROR_REQUEST_QR_TOO_LONG_MSG;
            break;
        case 300:
            return ERROR_NETWORK_MSG;
            break;
        case 400:
            return ERROR_SERVER_DATA_MSG;
            break;
        case 500:
            return ERROR_CANCEL_MSG;
            break;
            
        default:
            break;
    }
   return @"";
}

+ (void)jsErrorAlert:(NSString *)message
{
    [WalletAlertShower showAlert:nil
                            msg:message
                          inCtl:[WalletTools getCurrentVC]
                          items:@[VCNSLocalizedBundleString(@"dialog_yes", nil)]
                     clickBlock:^(NSInteger index) {
                     }];
}

+ (BOOL)fromISToAddress:(NSString *)from to:(NSString *)to
{
    bool isSame = NO;
    if ([from.lowercaseString isEqualToString:to.lowercaseString]) {
        isSame = YES;
    }
    if (isSame) {
        [WalletAlertShower showAlert:nil
                                 msg:VCNSLocalizedBundleString(@"h5_params_error", nil)
                               inCtl:[WalletTools getCurrentVC]
                               items:@[VCNSLocalizedBundleString(@"dialog_yes", nil)]
                          clickBlock:^(NSInteger index) {
                          }];
        return NO;
    }
    return YES;
}

+ (BigNumber *)calcThorNeeded:(float)gasPriceCoef gas:(NSNumber *)gas
{
    if (![gas isKindOfClass:[NSNumber class]]) {
        NSString *gasStr = [NSString stringWithFormat:@"%@",gas];
        gas = [NSNumber numberWithInteger:gasStr.integerValue];
    }
    NSMutableDictionary* dictParameters = [NSMutableDictionary dictionary];
    [dictParameters setValueIfNotNil:@"0x8eaa6ac0000000000000000000000000000000000000626173652d6761732d7072696365" forKey:@"data"];
    [dictParameters setValueIfNotNil:@"0x0" forKey:@"value"];
    
    NSString *httpAddress =  [NSString stringWithFormat:@"%@/accounts/%@",[WalletUserDefaultManager getBlockUrl],@"0x0000000000000000000000000000506172616D73"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:httpAddress]];
    request.timeoutInterval = 30;
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[dictParameters yy_modelToJSONData]];
    NSData *responseObject = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *error;
    if (responseObject){
        NSString *responseStr = [[NSString alloc]initWithData:responseObject
                                                       encoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr
                                                                      dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error]  ;
        NSString *baseGasPriceHex = json[@"data"];
        if (baseGasPriceHex.length > 3) {
            NSString *baseGasPrice = [BigNumber bigNumberWithHexString:baseGasPriceHex].decimalString;
            
            BigNumber *gasBigNumber = [BigNumber bigNumberWithNumber:gas];
            
            BigNumber *baseGasPriceBig = [BigNumber bigNumberWithDecimalString:baseGasPrice];
            BigNumber *currentGasPrice = [BigNumber bigNumberWithInteger:(1 + gasPriceCoef/255.0)*1000000];
            BigNumber *removeOffset = [BigNumber bigNumberWithInteger:1000000];
            
            BigNumber *gasCanUse = [[[baseGasPriceBig mul:currentGasPrice] mul:gasBigNumber] div:removeOffset];
            return gasCanUse;
        }
    }
    return nil;
}

+ (void)checkParamGasPrice:(NSString *)gasPrice gas:(NSString *)gas amount:(NSString *)amount to:(NSString *)to clauseStr:(NSString *)clauseStr
{
    if ([gasPrice isKindOfClass:[NSNull class]]) {
        gasPrice = DefaultGasPriceCoef;
    }else if (gasPrice.length == 0) {
        //默认120，如果js没有返回，就给默认的
        gasPrice = DefaultGasPriceCoef;
    }
    
    if ([gas isKindOfClass:[NSNull class]]) {
        gas = nil;
    }
    
    if ([amount isKindOfClass:[NSNull class]]) {
        amount = @"0";
    }
    
    if ([clauseStr isKindOfClass:[NSNull class]]) {
        clauseStr = nil;
    }
    
    if ([to isKindOfClass:[NSNull class]]) {
        to = nil;
    }
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

+ (NSString *)getAmountFromClause:(NSString *)clauseStr to:(NSString **)to
{
    NSString *clauseTemp =  [clauseStr stringByReplacingOccurrencesOfString:@"0xa9059cbb000000000000000000000000" withString:@""];
    *to = [@"0x" stringByAppendingString:[clauseTemp substringToIndex:40]];
    
    NSString *clauseStrTemp = [clauseStr stringByReplacingOccurrencesOfString:TransferMethodId withString:@""];
    NSString *clauseValue = @"";
    
    if (clauseStrTemp.length >= 128) {
        clauseValue = [clauseStrTemp substringWithRange:NSMakeRange(64, 64)];
    }
    return [NSString stringWithFormat:@"0x%@",clauseValue];
}

+ (BOOL)checkClauseDataFormat:(NSString *)clauseStr toAddress:(NSString *)toAddress bToken:(BOOL)bToken
{
    if (![WalletTools checkHEXStr:clauseStr]) {
        return NO;
    }
    
    if(!bToken){
        if (toAddress.length > 0) {
            if (![WalletTools errorAddressAlert:toAddress]) {
                return NO;
            }
            
            if (![WalletTools checkHEXStr:toAddress]) {
                return NO;
            }
        }
    }
    
    if (toAddress.length == 0) {
        return YES;
    }else if (clauseStr.length > 10) {
        
        if ([WalletTools checkHEXStr:clauseStr]) {
            NSString *temp1 = [clauseStr substringFromIndex:10];
            NSInteger i = temp1.length % 64;
            if (i == 0) {
                return YES;
            }
        }
        return NO;
        
    }else{
        return NO;
    }
}
@end
