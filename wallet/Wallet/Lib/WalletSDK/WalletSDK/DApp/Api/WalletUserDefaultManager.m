//
//  WalletUserDefaultManager.m
//  Wallet
//
//  Created by Tom on 18/4/11.
//  Copyright © VECHAIN. All rights reserved.
//
#import "WalletUserDefaultManager.h"

#define Main_Node      @"https://vethor-node.digonchain.com"

@implementation WalletUserDefaultManager


+ (NSString *)getBlockUrl
{
    // If block host is not set, the default is the official environment.
    NSString *blockUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"wallerSDK_BlockUrl"];
    if (blockUrl.length == 0 || blockUrl == nil) {
        return Main_Node;
    }else{
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"wallerSDK_BlockUrl"];
    }
}

+ (void)setBlockUrl:(NSString *)blockUrl
{
    [[NSUserDefaults standardUserDefaults] setObject:blockUrl forKey:@"wallerSDK_BlockUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
