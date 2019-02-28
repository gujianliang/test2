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
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"BlockUrl"];
}

+ (void)setBlockUrl:(NSString *)blockUrl
{
    [[NSUserDefaults standardUserDefaults] setObject:blockUrl forKey:@"BlockUrl"];
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
