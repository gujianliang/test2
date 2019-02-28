//
//  WalletUserDefaultManager.h
//  Wallet
//
//  Created by 曾新 on 18/4/11.
//  Copyright © VECHAIN. All rights reserved.

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
//#import "WalletContractConfig.h"



@interface WalletUserDefaultManager : NSObject


+ (NSString *)getBlockUrl;

+ (void)setBlockUrl:(NSString *)blockUrl;

+ (void)setLanuage:(NSString *)lanuage;

+ (NSString *)getLanuage;

@end
