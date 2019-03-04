//
//  WalletUserDefaultManager.m
//  Wallet
//
//  Created by 曾新 on 18/4/11.
//  Copyright © VECHAIN. All rights reserved.
//

#import "WalletUserDefaultManager.h"

@implementation WalletUserDefaultManager


+ (NSString *)getBlockUrl
{
    // 如果没有设置block host ，默认是正式环境
    NSString *blockUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"wallerSDK_BlockUrl"];
    if (blockUrl.length == 0 || blockUrl == nil) {
        return @"https://vethor-node-vechaindev.com";
    }else{
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"wallerSDK_BlockUrl"];
    }
}

+ (void)setBlockUrl:(NSString *)blockUrl
{
    [[NSUserDefaults standardUserDefaults] setObject:blockUrl forKey:@"wallerSDK_BlockUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setLanuage:(NSString *)lanuage
{
    [[NSUserDefaults standardUserDefaults] setObject:lanuage forKey:@"languageCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getLanuage
{
    NSString *languageCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
    NSString *language = nil;
    
    if (languageCode.length == 0) { // 用户未设置：取出手机自带语言
        
        NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        NSString *localeLanguageCode = [appLanguages objectAtIndex:0];
        
        
        if ([localeLanguageCode containsString:@"zh"]) {
            language = @"zh-Hans";
            
        }else{
            language = @"en";
        }
    }else{ // 用户设置：取出设置语言
        language = languageCode;
    }
    
    return language;
}
@end
