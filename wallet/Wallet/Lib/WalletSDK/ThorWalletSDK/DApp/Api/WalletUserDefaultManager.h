//
//  WalletUserDefaultManager.h
//  Wallet
//
//  Created by Tom on 18/4/11.
//  Copyright © VECHAIN. All rights reserved.

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WalletUserDefaultManager : NSObject

+ (NSString *)getBlockUrl;

+ (void)setBlockUrl:(NSString *)blockUrl;



@end
