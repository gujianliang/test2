//
//  FFBMSTools.m
//  FFBMS
//
//  Created by 曾新 on 16/4/26.
//  Copyright © 2016年 Eagle. All rights reserved.
//

#import "FFBMSTools.h"
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>
#import <SystemConfiguration/SystemConfiguration.h>
//#import "VCBaseVC.h"
//#import "AppDelegate.h"
//#import <ethers/ethers.h>
#import "WalletUtils.h"
//#import "WalletSqlDataEngine.h"
#import "WalletPaymentQRCodeView.h"
//#import "WalletAuthSignApi.h"
//#import "WalletAuthFirstVC.h"
//#import "WalletAuthInputPWView.h"
//#import "WalletHandle.h"
#import "NSMutableDictionary+Helpers.h"
#import "AFNetworkReachabilityManager.h"

#import "FFBMSMBProgressShower.h"

@implementation FFBMSTools


+ (NSDate *)stringConvertDate:(NSString *)strDate format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:format];
    NSDate *date=[formatter dateFromString:strDate];
    return date;
}

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


//+ (UINavigationController *) getTabControllerByIndex:(int)index
//{
//    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    UITabBarController *tabBarController = (UITabBarController*)delegate.rootTab;
//    UINavigationController *nav = [tabBarController.viewControllers objectAtIndex:index];
//    return nav;
//}

//+ (UINavigationController *) getActiveTabController
//{
//    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    UITabBarController *tabBarController = (UITabBarController*)delegate.rootTab;
//    UIViewController *nav = [tabBarController.viewControllers objectAtIndex:tabBarController.selectedIndex];
//    return (UINavigationController *)nav;
//}

+ (void) restoreTabNavToRoot
{
//    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate.rootTab dismissViewControllerAnimated:NO completion:NULL];
//
//    for (int i = 0; i < delegate.rootTab.viewControllers.count; i++) {
//        [[self getTabControllerByIndex:i] popToRootViewControllerAnimated:NO];
//    }
//
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
//    [delegate.rootTab setSelectedIndex:0];
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

+(CGFloat)heightByStrWithWidthAndFontSize:(NSString*)Str  WIDTH:(CGFloat)width UIFONTSIZE:(CGFloat)fontSize
{
    CGRect sizeValueStr = [Str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return sizeValueStr.size.height;
}

//绘制虚线
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    
    //  设置虚线颜色为
    [shapeLayer setStrokeColor:lineColor.CGColor];
    
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
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
    NSString *pathString1 = [[NSBundle mainBundle] pathForResource:@"WalletSDKBundle" ofType:@"bundle"];
    if(!pathString1){
        return nil;
    }
    
    NSBundle *resourceBundle = [NSBundle bundleWithPath:pathString1];
//    name = [name stringByAppendingString:@".tiff"];
    NSString *bundlePath = [resourceBundle pathForResource:name ofType:@"tiff"];
    UIImage *image = [UIImage imageWithContentsOfFile:bundlePath];
    
    return image;
}


// 判断是否包含中文
+ (BOOL) containChiness:(NSString *)text{
    
    NSUInteger length = [text length];
    for (int i = 0; i < length; ++i){
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [text substringWithRange:range];
        
        if ([subString isEqualToString:@"€"] || [subString isEqualToString:@"•"]) {
            return NO;
        }
        
        const char  *cString = [subString UTF8String];
        if (cString) {
            if (strlen(cString) == 3){
                NSLog(@"汉字:%s", cString);
                return YES;
            }
        }else{
                NSLog(@"表情:%@", text);
            return YES;
        }
    }
    return NO;
}

+ (BOOL )checkPW:(NSString *)password
{
    // 大写，小写，数字，字符
    
    NSString * number = @"^\\w*\\d+\\w*$";      //数字
    NSString * lower = @"^\\w*[a-z]+\\w*$";      //小写字母
    NSString * upper = @"^\\w*[A-Z]+\\w*$";     //大写字母
    
    // 判断数字
    
    BOOL hasNum = NO;
    BOOL hasUpper = NO;
    BOOL hasLower = NO;
    BOOL hasSepcial = NO;
   
    NSString *sepcialList = @".,?!':… ~@;\"/()_-+=`^#*%&\\\[]<>{}|·¡¿$¥£€•";    // 常见英文键盘特殊字符
    
    for (int i = 0; i< password.length; i++) {
        
        NSString *temp = [password substringWithRange:NSMakeRange(i, 1)];
        if ([self validateWithRegExp:number text:temp]) {   // 校验是否有数字
            hasNum = YES;
        }
        if ([self validateWithRegExp:lower text:temp]) {    // 校验是否有小写
            hasLower = YES;
        }
        if ([self validateWithRegExp:upper text:temp]) {    // 校验是否有大写
            hasUpper = YES;
        }
        if ([sepcialList containsString:temp]) { // 校验是否有常用英文特殊字符
            hasSepcial = YES;
        }
        
    }
    
    NSInteger result = 0;
    
    if (hasNum)
    {
        result ++;
    }
    if (hasLower)
    {
        result ++;
    }
    if (hasUpper)
    {
        result ++;
    }
    if (hasSepcial)
    {
        result ++;
    }
    
    return  result < 3 ? NO :YES;

}

+ (BOOL)validateWithRegExp: (NSString *)regExp text:(NSString *)text
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject:text];
}

//+ (UIImage *)walletAddreeConvertImage:(NSString *)address
//{
//    Address *addressNormalize = [Address addressWithString:address];
//    if (addressNormalize.checksumAddress != nil) {
//        address = addressNormalize.checksumAddress;
//    }
//    Blockies *getImage =  [[Blockies alloc]initWithSeed:address
//                                                   size:8
//                                                  scale:2
//                                                  color:nil
//                                                bgColor:nil
//                                              spotColor:nil
//                                               randSeed:nil];
//    UIImage *image = [getImage createImageWithCustomScale:3];
//    return image;
//}

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

+ (NSString *) compareCurrentTime:(NSString *)str
{
    NSTimeInterval time = str.doubleValue;
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:detailDate];
    long temp = 0;
    NSString *result;
    if (timeInterval/60 < 1)
    {
        result = VCNSLocalizedBundleString(@"刚刚", nil);
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld %@",temp,
                  temp == 1 ? VCNSLocalizedBundleString(@"minAgo_single", nil) : VCNSLocalizedBundleString(@"minAgo_plural", nil)];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld %@",temp,
                  temp == 1 ? VCNSLocalizedBundleString(@"hrAgo_single", nil) : VCNSLocalizedBundleString(@"hrAgo_plural", nil)];
    }
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld %@",temp,
                  temp == 1 ? VCNSLocalizedBundleString(@"dayAgo_single", nil) : VCNSLocalizedBundleString(@"dayAgo_plural", nil)];
    }
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld %@",temp,
                  temp == 1 ? VCNSLocalizedBundleString(@"monthAgo_single", nil) : NSLocalizedString(@"monthAgo_plural", nil)];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld %@",temp,
                  temp == 1 ? VCNSLocalizedBundleString(@"yearAgo_single", nil) : VCNSLocalizedBundleString(@"yearAgo_plural", nil)];
    }
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


//+ (NSTimeInterval) compareTimeSpace:(NSString *)str
//{
//    NSTimeInterval time = str.doubleValue;
//
//    NSString *serverOffset = [WalletHandle shareWalletHandle].responseOffset;
//
//    NSInteger mergeTime = time - serverOffset.integerValue;
//    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:mergeTime];
//
//    NSDate *currentDate = [NSDate date];
//    // 以截止时间为基准，计算当前时间距离截止时间的距离
//    NSTimeInterval timeInterval = [detailDate timeIntervalSinceDate:currentDate];
//
//    if(timeInterval < 0){ // 代表时间已经过期
//        timeInterval = 0;
//    }
//
//    return timeInterval;
//}

+ (NSString *) convertTimeTo:(NSTimeInterval)timeInterval
{
    if (timeInterval == 0) {
        return @"";
    }
    
    long temp = timeInterval / 3600;
    NSString *result = @"";
    
    long hour = temp;
    long min = (timeInterval - 3600 * hour ) / 60;
    double secTemp = timeInterval - 3600 * hour - 60 * min;
    long sec = ceil(secTemp);
    
    NSString *hourStr = @"";
    if (hour < 10) {
        hourStr = [NSString stringWithFormat:@"0%ld", hour];
        
    }else {
        hourStr = [NSString stringWithFormat:@"%ld", hour];
    }
    
    NSString *minStr = @"";
    if (min < 10) {
        minStr = [NSString stringWithFormat:@"0%ld", min];
        
    }else {
        minStr = [NSString stringWithFormat:@"%ld", min];
    }
    
    NSString *secStr = @"";
    if (sec < 10) {
        secStr = [NSString stringWithFormat:@"0%ld", sec];
        
    }else {
        secStr = [NSString stringWithFormat:@"%ld", sec];
    }
    
    result = [NSString stringWithFormat:@"%@:%@:%@", hourStr, minStr, secStr];
    
    return result;
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

//+(UIViewController *)getPresentedViewConreoller
//{
//    UIViewController *rootVC = AppRootVC;
//    UIViewController *topVC = rootVC;
//    if (topVC.presentedViewController) {
//        topVC = topVC.presentedViewController;
//    }
//    return topVC;
//}

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
#warning test 
    BOOL result = YES;
    if (block) {
        block(result);
    }
    return;
    AFNetworkReachabilityManager *reachManager = [AFNetworkReachabilityManager sharedManager];
    if (![reachManager isReachable]) {

        UIViewController * vc= [FFBMSTools getCurrentVC];
        UIView *cententView = vc.view;
        if (vc.navigationController) {
            cententView = vc.navigationController.view;
        }
        [FFBMSMBProgressShower showTextIn:cententView
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

+ (BOOL)checkKeystore:(NSString *)keystore
{
    NSDictionary *dictKS = nil;
    //[NSJSONSerialization dictionaryWithJsonString:[keystore lowercaseString]];
    
//    NSString *address = dictKS[@"address"];
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

//+ (BOOL)checkHasToken:(NSString *)tokenSymbol {
//    __block BOOL validTokenName = NO;
//    [[[WalletSqlDataEngine sharedInstance] tokenList] enumerateObjectsUsingBlock:^(WalletTokenModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj.symbol isEqualToString:tokenSymbol]
//            || [tokenSymbol isEqualToString:@"VET"]) {
//            validTokenName = YES;
//            *stop = YES;
//        }
//    }];
//    return validTokenName;
//}

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

//+(NSString *)addressAuthSign:(WalletAuthorizedDataModel *)dataModel account:(Account *)account
//{
//    if (dataModel.signTimeStamp.integerValue == 0) {
//        NSString *tempNumber = [[[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] componentsSeparatedByString:@"."] firstObject];
//
//        dataModel.signTimeStamp = [NSNumber numberWithUnsignedInteger:tempNumber.integerValue];
//
//    }
//    NSString *dataStr = [dataModel yy_modelToJSONString];
//    NSDictionary *dictData = [NSJSONSerialization dictionaryWithJsonString:dataStr];
//    NSMutableDictionary *dictOrigin = [NSMutableDictionary dictionaryWithDictionary:dictData];
//
//    NSArray *keys = [dictOrigin allKeys];
//    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
//        return [obj1 compare:obj2 options:NSNumericSearch];
//    }];
//
//    NSMutableArray *keyAndValueList = [NSMutableArray array];
//    for (NSString *key in sortedArray) {
//        NSString *value = dictOrigin[key];
//        NSString *keyValue = nil;
//        if ([value isKindOfClass:[NSNumber class]]) {
//            NSNumber *num = (NSNumber *)value;
//            value = ((NSNumber *)num).stringValue;
//
//            keyValue = [NSString stringWithFormat:@"\"%@\":%@",key,value];
//        }else{
//
//            keyValue = [NSString stringWithFormat:@"\"%@\":\"%@\"",key,value];
//        }
//
//        [keyAndValueList addObject:keyValue];
//
//    }
//    NSString *packSign = [NSString stringWithFormat:@"{%@}",[keyAndValueList componentsJoinedByString:@","]];
//
//    NSData *totalData1 = [packSign dataUsingEncoding:NSUTF8StringEncoding];
//    SecureData *encode = [SecureData BLAKE2B:totalData1 ];
//    NSString *encodeHex = [encode.hexString substringFromIndex:2];
//    NSString *pageCode = [kAuthAddressCode stringByAppendingString:encodeHex];
//    NSData *totalData = [SecureData hexStringToData:pageCode];
//    SecureData *hashData = [SecureData BLAKE2B:totalData ];
//    Signature *signature = [account signDigest:hashData.data];
//
//    SecureData *vData = [[SecureData alloc]init];
//    [vData appendByte:signature.v];
//
//    NSString *s = [SecureData dataToHexString:signature.s];
//    NSString *r = [SecureData dataToHexString:signature.r];
//
//    NSString *hashStr = [NSString stringWithFormat:@"%@%@%@",
//                         [r substringFromIndex:2],
//                         [s substringFromIndex:2],
//                         [vData.hexString substringFromIndex:2]];
//    return hashStr;
//}
//
//
//+(void)observerAuthAddress:(UIViewController *)vc
//                     model:(WalletAddressAuthModel *)model
//              sessiontoken:(NSString *)sessiontoken
//{
//    NSString *tempNumber = [[[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] componentsSeparatedByString:@"."] firstObject];
//    model.authorizedData.signTimeStamp = [NSNumber numberWithUnsignedInteger:tempNumber.integerValue];
//    NSString *json = [@"auth://" stringByAppendingString:[model yy_modelToJSONString]];
//
//    if ([vc.view viewWithTag:200]) {
//        return ;
//    }
//    WalletPaymentQRCodeView *QRCodeView = [[WalletPaymentQRCodeView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)
//                                                                                   type:HotWalletQrCodeType
//
//                                                                                   json:json
//                                                                               codeType:QRCodeObserverAuthType];
//    QRCodeView.backgroundColor = UIColor.clearColor;
//    QRCodeView.tag = 200;
//    [vc.view addSubview:QRCodeView];
//    [UIView animateWithDuration:0.3 animations:^{
//        [QRCodeView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    }];
//    QRCodeView.block = ^(NSString *result)
//    {
//        if ([vc.view viewWithTag:201]) {
//            return ;
//        }
//        WalletPaymentQRCodeView *QRCodeView = [[WalletPaymentQRCodeView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)
//                                                                                       type:HotWalletScanType
//
//                                                                                       json:@""
//                                                                                   codeType:QRCodeObserverAuthType];
//        QRCodeView.tag = 201;
//        QRCodeView.backgroundColor = UIColor.clearColor;
//        [vc.view addSubview:QRCodeView];
//        [UIView animateWithDuration:0.3 animations:^{
//            [QRCodeView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        }];
//        QRCodeView.block = ^(NSString *result)
//        {
//            //组装 交易model
//            model.sign = result;
//
//            WalletAuthSignApi *signApi = [[WalletAuthSignApi alloc]initWithModel:model
//                                                                    sessiontoken:sessiontoken];
//            [signApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
//
//                NSDictionary *dict = finishApi.resultDict;
//                if (((NSNumber *)dict[@"code"]).integerValue == 1) { //签名成功
//
//                    WalletAuthFirstVC *resutVC = [[WalletAuthFirstVC alloc]init];
//                    resutVC.authType = ResultType;
//
//                    resutVC.model = model;
//                    [vc.navigationController pushViewController:resutVC animated:YES];
//                }
//
//            } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
//
//                [FFBMSMBProgressShower showMulLineTextIn:vc.view Text:errMsg During:1.5];
//            }];
//        };
//    };
//}

//+(void)normalAddressProgress:(NSString *)address
//                          vc:(UIViewController *)vc
//                   AuthModel:(WalletAddressAuthModel *)model
//                sessiontoken:(NSString *)sessiontoken
//{
//    if ([vc.view viewWithTag:999]) {
//        return ;
//    }
//    WalletAuthInputPWView *inputView = [[WalletAuthInputPWView alloc]initWithAddress:address
//                                                                         authObserve:AuthAddressType
//                                                                               block:^(BOOL result,Account *account)
//
//    {
//        if (result) {
//            // 执行生成授权页面
//
//            WalletAuthorizedDataModel *dataModel = model.authorizedData;
//            NSString *hashStr = [FFBMSTools addressAuthSign:dataModel account:account];
//            model.sign = hashStr;
//            model.address = address;
//
//            WalletAuthSignApi *signApi = [[WalletAuthSignApi alloc]initWithModel:model
//                                                                    sessiontoken:sessiontoken];
//            [signApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
//                NSDictionary *dict = finishApi.resultDict;
//                if (((NSNumber *)dict[@"code"]).integerValue == 1) { //签名成功
//
//                    WalletAuthFirstVC *resutVC = [[WalletAuthFirstVC alloc]init];
//                    resutVC.authType = ResultType;
//
//                    resutVC.model = model;
//                    [vc.navigationController pushViewController:resutVC animated:YES];
//                }
//            } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
//                [FFBMSMBProgressShower showMulLineTextIn:vc.view Text:errMsg During:1.5];
//            }];
//        }
//    }];
//
//    [inputView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    inputView.tag = 999;
//    [vc.view addSubview:inputView];
//
//    [UIView animateWithDuration:0.3 animations:^{
//        [inputView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    } completion:^(BOOL finished) {
//
//    }];
//}

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

+ (BOOL)isCanUsePhotos {
    
    BOOL isAuthor = NO;
    
    NSString *mediaType = AVMediaTypeVideo;// Or AVMediaTypeAudio
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        isAuthor = NO;
        
        [FFBMSAlertShower showAlert:VCNSLocalizedBundleString(@"dialog_tip_title", nil)
                                msg:VCNSLocalizedBundleString(@"permission_camera_content", nil)
                              inCtl:[FFBMSTools getCurrentVC]
                              items:@[VCNSLocalizedBundleString(@"dialog_no", nil), VCNSLocalizedBundleString(@"usercenter_setting", nil)]
                         clickBlock:^(NSInteger index)
        {
             if(index == 1){
                 NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                 
                 if ([[UIApplication sharedApplication] canOpenURL:url]) {
                     [[UIApplication sharedApplication] openURL:url
                                                        options:nil
                                              completionHandler:^(BOOL success) {
                                                  
                                              }];
                 }
             }
            
        }];
        
    }else if (authStatus == AVAuthorizationStatusNotDetermined){
        isAuthor = NO;
        
    }else{
        isAuthor = YES;
    }
    
    if (!isAuthor) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL isAllow) {
            NSLog(@"%@",isAllow ? @"相机准许" : @"相机不准许");
        }];
    }
    
    return isAuthor;
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
            contractClauseData = [FFBMSTools contractMethodId:methodID params:params];
            additionalMsg = VCNSLocalizedBundleString(@"contract_payment_info_row4_content_node_upgrde", nil);
        }
            break;
        case Contract_cancelNode:       // 奖励取消升级
        {
            gasLimit = @"100";
            methodID = CANCEL_UPGRADE;
            contractClauseData = [FFBMSTools contractMethodId:methodID params:params];
            additionalMsg = VCNSLocalizedBundleString(@"contract_payment_info_row4_content_cancel_upgrade", nil);
        }
            break;
        case Contract_PubicSale:        // 公开拍卖
        {
            gasLimit = @"350";
            methodID = CREATE_SALE_AUCTION;
            contractClauseData = [FFBMSTools contractMethodId:methodID params:params];
            additionalMsg = VCNSLocalizedBundleString(@"contract_payment_info_row4_content_public", nil);
        }
            break;
        case Contract_OrientSale:
        {
            gasLimit = @"350";          // 定向拍卖
            methodID = CREATE_DIRECTION_SALE_AUCTION;
            contractClauseData = [FFBMSTools contractMethodId:methodID params:params];
            additionalMsg = VCNSLocalizedBundleString(@"contract_payment_info_row4_content_auction", nil);
        }
            break;
        case Contract_buyNode:          // 购买节点
        {
            gasLimit = @"350";
            methodID = BID;
            contractClauseData = [FFBMSTools contractMethodId:methodID params:params];
            additionalMsg = VCNSLocalizedBundleString(@"contract_payment_info_row4_content_buy", nil);
        }
            break;
        case Contract_acceptNode:       // 接收节点
        {
            gasLimit = @"350";
            methodID = BID;
            contractClauseData = [FFBMSTools contractMethodId:methodID params:params];
            additionalMsg = VCNSLocalizedBundleString(@"contract_payment_info_row4_content_receive", nil);
        }
            break;
        case Contract_cancelSaleNode:     // 去掉挂单
        {
            gasLimit = @"350";
            methodID = CANCEL_AUCTION;
            contractClauseData = [FFBMSTools contractMethodId:methodID params:params];
            additionalMsg = VCNSLocalizedBundleString(@"contract_payment_info_row4_content_cancel_onsale", nil);
        }
            break;
        case Contract_transfer:     // 转移到另外钱包
        {
            gasLimit = @"200";
            methodID = NODE_TRANSFER;
            contractClauseData = [FFBMSTools contractMethodId:methodID params:params];
            additionalMsg = VCNSLocalizedBundleString(@"transfer_thor_node_title", nil);
        }
            break;
        
            break;
//        case NoContract_transferToken:     //其他合约签名
//        {
//            gasLimit = @"300";
//            methodID = NODE_TRANSFER;
//            contractClauseData = [FFBMSTools contractMethodId:methodID params:params];
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

+(ContractType)methodIDConvertContractType:(NSString *)methodID
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
    NSString *test = input;
    test = [test stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    NSString *first = [test substringWithRange:NSMakeRange(0, 64)];
    first = [NSString stringWithFormat:@"0x%@",first];
    //16进制转10
    NSString *strLength = [BigNumber bigNumberWithHexString:first].decimalString;
    NSString *last = [test substringWithRange:NSMakeRange(64, test.length - 64)];
    
    NSString *second = [last substringWithRange:NSMakeRange(0, strLength.integerValue * 2)];
    NSInteger secondLength = [BigNumber bigNumberWithHexString:[NSString stringWithFormat:@"0x%@",second]].decimalString.integerValue;
    
    NSString *result = [last substringWithRange:NSMakeRange(strLength.integerValue * 2, last.length - strLength.integerValue * 2)];
    
    NSString *realText = [result substringWithRange:NSMakeRange(0, secondLength * 2)];
    
    NSString *rr = [FFBMSTools stringFromHexString:realText];
    return rr;
}

+ (void)callback:(NSString *)requestId
            data:(id)data
      callbackID:(NSString *)callbackID
         webview:(WKWebView *)webView
            code:(NSInteger)code
         message:(NSString *)message
{
    NSDictionary *packageDict = [FFBMSTools packageWithRequestId:requestId
                                                            data:data
                                                            code:code
                                                         message:message];
    NSString *injectJS = [NSString stringWithFormat:@"%@('%@')",callbackID,[packageDict yy_modelToJSONString]];
    NSLog(@"inject == %@",injectJS);
    [webView evaluateJavaScript:injectJS completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"error == %@",error);
    }];
    
    if (code != 1) {
        [self jsErrorAlert:message];
    }
}

+ (void)jsErrorAlert:(NSString *)message
{
    [FFBMSAlertShower showAlert:nil
                            msg:message
                          inCtl:[FFBMSTools getCurrentVC]
                          items:@[VCNSLocalizedBundleString(@"dialog_yes", nil)]
                     clickBlock:^(NSInteger index) {
                     }];
}

@end
