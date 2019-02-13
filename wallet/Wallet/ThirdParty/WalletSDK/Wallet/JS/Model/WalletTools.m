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
#import "WalletPaymentQRCodeView.h"
#import "NSMutableDictionary+Helpers.h"
#import "AFNetworkReachabilityManager.h"
#import "WalletMBProgressShower.h"
#import "WalletDAppHead.h"

@implementation WalletTools


+ (NSString *)dateConvertString:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+(NSString*)dateStringFrommSecondString:(NSString*)mSecond format:(NSString *)format{
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:[mSecond doubleValue]/1000.0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    return [dateFormat stringFromDate:nd];
}

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

+ (BOOL)IsIdentityCard:(NSString *)IDCardNumber
{
    if (IDCardNumber.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:IDCardNumber];
}

+(BOOL)isNoNull:(id)Obj
{
    if (Obj) {
        if ([Obj isEqual:[NSNull null]]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

+(NSString*)appVersion
{
    NSString* appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    appversion = [appversion stringByReplacingOccurrencesOfString:@"." withString:@""];
    return appversion;
}

+ (BOOL)checkQRcode:(NSString *)code
{
    NSString *regex =@"[A-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (![pred evaluateWithObject:code]) {
        return YES;
    }
    return NO;
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

+ (BOOL)validateWithRegExp: (NSString *)regExp text:(NSString *)text
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject:text];
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


+ (NSString *) compareDayTime:(NSString *)str
{
    NSTimeInterval time = str.doubleValue;
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:detailDate];
    
    long temp = 0;
    NSString *result;
    if (timeInterval/60 < 1){
        result = VCNSLocalizedBundleString(@"刚刚", nil);
        
    }else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld %@", temp,
                  temp == 1 ? VCNSLocalizedBundleString(@"minAgo_single", nil) : VCNSLocalizedBundleString(@"minAgo_plural", nil)];
        
    } else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld %@", temp,
                  temp == 1 ? VCNSLocalizedBundleString(@"hrAgo_single", nil) : VCNSLocalizedBundleString(@"hrAgo_plural", nil)];
    
    }else { // 具体 月/日/年 时:分
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
        result = [dateFormatter stringFromDate: detailDate];
    }
    
    return  result;
}

+ (NSString *)checksumAddress:(NSString *)inputAddress
{
    Address *a = [Address addressWithString:inputAddress];
    if (a) {
        return a.checksumAddress;
    }
    return inputAddress;
}

+(NSString *)getSwapAddress:(NSString *)ethAddress thorAddress:(NSString *)thorAddress
{
    NSData *data1 = [SecureData hexStringToData:ethAddress.lowercaseString];
    NSData *data2 = [SecureData hexStringToData:thorAddress];
    NSMutableData *data3 = [NSMutableData new];
    [data3 appendData:data1];
    [data3 appendData:data2];
    
    SecureData *last = [SecureData secureDataWithData:data3];
    NSString *shaStr = last.SHA256.hexString;
    
    NSString *result = [NSString stringWithFormat:@"%@%@",@"0x00000000000000000000" ,[shaStr substringFromIndex:46]];
    return result;
}

// 大小写
+ (BOOL)InputCapitalAndLowercaseLetter:(NSString*)string
{
    NSString *regex =@"[a-zA-Z]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL  inputString = [predicate evaluateWithObject:string];
    return inputString;
}

+ (void)circualarView:(UIView *)view Radius:(CGFloat)radius
{
    view.layer.cornerRadius = radius;
    view.clipsToBounds = YES;
}

+ (void)checkNetwork:(void(^)(BOOL t))block
{
    BOOL result = YES;
    if (block) {
        block(result);
    }
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

+(NSString *)keep4Decimal:(NSString *)input
{
    NSArray *valueList = [input componentsSeparatedByString:@"."];
    NSString *decimals = @"";
    if (valueList.count > 1 ) {
        NSString *temp = valueList[1];
        if (temp.length >3) {
            decimals = [temp substringToIndex:4];
        }else{
            decimals = temp;
        }
    }
    
    return [NSString stringWithFormat:@"%@.%@",valueList[0],decimals];
}

+ (NSString *)conventTimeSec:(NSString *)input
{
    NSTimeInterval time = input.doubleValue;
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    return [dateFormatter stringFromDate:detailDate];
}


+ (NSString *)conventTime:(NSString *)input
{
    NSTimeInterval time = input.doubleValue;
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:detailDate];
}

+ (NSString *)conventInvalidTime:(NSString *)input
{
    NSTimeInterval time = input.doubleValue;
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    return [dateFormatter stringFromDate:detailDate];
}


+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (NSString *)serviceRuleHostWithContent:(NSString *)content
{
    NSString *languageCode = [WalletUserDefaultManager getLanuage];

    if ([languageCode containsString:@"zh"]){
        languageCode = @"cn";
        
    }else{
       languageCode = @"en";
    }
    
    return [NSString stringWithFormat:@"https://cdn.vechain.com/vechainthorwallet/docs/%@/protocol/%@",languageCode,content];
}

+ (UIViewController *)viewControllerSupportView:(UIView *)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

+ (BOOL)addressChecksum:(NSString *)address
{
    if (address.length != 42) {
        return NO;
    }
    NSString *temp = [address substringFromIndex:2];
    Address *a = [Address addressWithString:temp];
    
    if (a == nil) { // 地址检查不通过，不能获得 checksum
        return NO;
    }
    
    NSString *temp1 = [a.checksumAddress substringFromIndex:2];
    NSString *temp2 = [address substringFromIndex:2];
    
    if (![self checkEthAddress:temp2]) { // 含有异常字符串
        return NO;
    }
    
    if ([temp2.lowercaseString isEqualToString:temp2]) { // 小写的放过，在外面再做检查
        return YES;
    }
    
    if (![temp1 isEqualToString:temp2]) { // 输入和输出 不同，输入不是checksum
        return NO;
    }
    
    return YES;
}

+ (BOOL)checkEthAddress:(NSString *)address
{
    NSString *regex =@"[0-9a-fA-F]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:address];
}

+(BOOL)hasSpecialWord:(NSString *)words
{
    if ([words containsString:@"'"]) {
        return YES;
    }
    return NO;
}

+(UIImage *)creatQRcodeImage:(NSString *)content
{
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    // 3.将字符串转换成NSdata
    NSData *data  = [content dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    // 5.生成二维码
    CIImage *image = [filter outputImage];
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = 3;
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    UIImage *image1 = [UIImage imageWithCGImage:scaledImage];
    return image1;
}

+ (void)drawDottedLine:(UIView *)view
{
    CAShapeLayer *border = [CAShapeLayer layer];
    
    //虚线的颜色
    border.strokeColor = HEX_RGB(0xDEDEDE).CGColor;
    //填充的颜色
    border.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:5];
    
    //设置路径
    border.path = path.CGPath;
    
    border.frame = view.bounds;
    //虚线的宽度
    border.lineWidth = 1.f;
    
    //虚线的间隔
    border.lineDashPattern = @[@4, @2];
    
    view.layer.cornerRadius = 5.f;
    view.layer.masksToBounds = YES;
    [view.layer addSublayer:border];
}

//查询节点信息 余额
+ (NSString *)blockWtihMethod:(NSString *)methodId tokenID:(NSString *)tokenID
{
    NSInteger t = 64 - [methodId substringFromIndex:2].length;
    NSMutableString *zero = [NSMutableString new];
    for (int i = 0; i < t; i++) {
        [zero appendString:@"0"];
    }
    NSString *newValue = [NSString stringWithFormat:@"%@%@",methodId,zero];
    NSString *data = [NSString stringWithFormat:@"%@%@",newValue,tokenID];
    return data;
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

+ (NSDictionary *)getContractData:(ContractType)contractType params:(NSArray *)params
{
    NSString *gasLimit = @"";
    NSString *contractClauseData = @"";
    NSString *additionalMsg = @"";
    NSString *methodID = @"";

    switch (contractType) {
        case Contract_appyNode:         // 奖励升级
        {
            gasLimit = @"200";
            methodID = APPLY_UPGRADE;
            contractClauseData = [WalletTools contractMethodId:methodID params:params];
            additionalMsg = VCNSLocalizedBundleString(@"contract_payment_info_row4_content_node_upgrde", nil);
        }
            break;
        case Contract_cancelNode:       // 奖励取消升级
        {
            gasLimit = @"100";
            methodID = CANCEL_UPGRADE;
            contractClauseData = [WalletTools contractMethodId:methodID params:params];
            additionalMsg = VCNSLocalizedBundleString(@"contract_payment_info_row4_content_cancel_upgrade", nil);
        }
            break;
        case Contract_PubicSale:        // 公开拍卖
        {
            gasLimit = @"350";
            methodID = CREATE_SALE_AUCTION;
            contractClauseData = [WalletTools contractMethodId:methodID params:params];
            additionalMsg = VCNSLocalizedBundleString(@"contract_payment_info_row4_content_public", nil);
        }
            break;
        case Contract_OrientSale:
        {
            gasLimit = @"350";          // 定向拍卖
            methodID = CREATE_DIRECTION_SALE_AUCTION;
            contractClauseData = [WalletTools contractMethodId:methodID params:params];
            additionalMsg = VCNSLocalizedBundleString(@"contract_payment_info_row4_content_auction", nil);
        }
            break;
        case Contract_buyNode:          // 购买节点
        {
            gasLimit = @"350";
            methodID = BID;
            contractClauseData = [WalletTools contractMethodId:methodID params:params];
            additionalMsg = VCNSLocalizedBundleString(@"contract_payment_info_row4_content_buy", nil);
        }
            break;
        case Contract_acceptNode:       // 接收节点
        {
            gasLimit = @"350";
            methodID = BID;
            contractClauseData = [WalletTools contractMethodId:methodID params:params];
            additionalMsg = VCNSLocalizedBundleString(@"contract_payment_info_row4_content_receive", nil);
        }
            break;
        case Contract_cancelSaleNode:     // 去掉挂单
        {
            gasLimit = @"350";
            methodID = CANCEL_AUCTION;
            contractClauseData = [WalletTools contractMethodId:methodID params:params];
            additionalMsg = VCNSLocalizedBundleString(@"contract_payment_info_row4_content_cancel_onsale", nil);
        }
            break;
        case Contract_transfer:     // 转移到另外钱包
        {
            gasLimit = @"200";
            methodID = NODE_TRANSFER;
            contractClauseData = [WalletTools contractMethodId:methodID params:params];
            additionalMsg = VCNSLocalizedBundleString(@"transfer_thor_node_title", nil);
        }
            break;
        
            break;
//        case NoContract_transferToken:     //其他合约签名
//        {
//            gasLimit = @"300";
//            methodID = NODE_TRANSFER;
//            contractClauseData = [WalletTools contractMethodId:methodID params:params];
//            additionalMsg = VCNSLocalizedBundleString(@"transfer_thor_node_title", nil);
//        }
//            break;
//        default:
            break;
    }
    if (gasLimit.length > 0 && contractClauseData.length > 0 && additionalMsg.length > 0) {
        return [NSDictionary dictionaryWithObjectsAndKeys:gasLimit,@"gasLimit",
                                       contractClauseData,@"contractClauseData",
                                           additionalMsg ,@"additionalMsg",
                                            methodID ,@"methodID",nil];
    }else{
        return nil;
    }
}

+ (ContractType)methodIDConvertContractType:(NSString *)methodID
{
    if ([methodID isEqualToString:APPLY_UPGRADE]) { // 申请节点升级
        return Contract_appyNode;
        
    }else if ([methodID isEqualToString:CANCEL_UPGRADE]){ // 取消升级申请
        return Contract_cancelNode;
        
    }else if ([methodID isEqualToString:CREATE_SALE_AUCTION]){ // 创建公开拍卖
        return Contract_PubicSale;
        
    }else if ([methodID isEqualToString:CREATE_DIRECTION_SALE_AUCTION]){ // 创建定向拍卖
        return Contract_OrientSale;
        
    }else if ([methodID isEqualToString:BID]){ // 拍卖投标
        return Contract_buyNode;
        
    }else if ([methodID isEqualToString:BID]){ //
        return Contract_acceptNode;
        
    }else if ([methodID isEqualToString:CANCEL_AUCTION]){ // 拍卖取消
        return Contract_cancelSaleNode;
    }
    else if ([methodID isEqualToString:NODE_TRANSFER]){ // 节点转移
        return Contract_transfer;
    }
    return Contract_appyNode;
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
    NSLog(@"inject == %@",injectJS);
    [webView evaluateJavaScript:injectJS completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"error == %@",error);
    }];
    
    if (code != 1) {
        [self jsErrorAlert:message];
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


+ (NSString *)removeExtraZeroAtBegin:(NSString *)valueFormated
{
    while ([valueFormated hasPrefix:@"0"]
           || [valueFormated hasPrefix:@"."]) {
        if ([valueFormated isEqualToString:@"0."]) {
            valueFormated = @"0";
            break;
        }
        
        if ([valueFormated hasPrefix:@"0."]) {
            break;
        }
        
        if ([valueFormated hasPrefix:@"."] ) {
            valueFormated = [@"0" stringByAppendingString:valueFormated];
            break;
        }
        
        if ([valueFormated isEqualToString:@"0"]
            || ![valueFormated hasPrefix:@"0"]) {
            break;
        }
        
        if ([valueFormated hasPrefix:@"00"]) {
            valueFormated = [valueFormated substringFromIndex:1];
        } else if ([valueFormated hasPrefix:@"0"] && ![valueFormated hasPrefix:@"0."]) {
            valueFormated = [valueFormated substringFromIndex:1];
            break;
        }
    }
    return valueFormated;
}

+ (BOOL)fromISToAddress:(NSString *)from to:(NSString *)to
{
    bool isSame = NO;
    if ([from.lowercaseString isEqualToString:to.lowercaseString]) {
        isSame = YES;
    }
    if (isSame) {
        [WalletAlertShower showAlert:nil
                                 msg:VCNSLocalizedBundleString(@"非法参数", nil)
                               inCtl:[WalletTools getCurrentVC]
                               items:@[VCNSLocalizedBundleString(@"dialog_yes", nil)]
                          clickBlock:^(NSInteger index) {
                          }];
        return NO;
    }
    return YES;
}
@end
