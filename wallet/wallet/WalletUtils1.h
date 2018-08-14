//
//  WalletUtils.h
//  ethers
//
//  Created by 曾新 on 2018/8/12.
//  Copyright © 2018年 Ethers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ethers/ethers.h>

@interface WalletUtils : NSObject

+ (void)creatWalletWithPassword:(NSString *)password
                      callBack:(void(^)(Account *account)) block;

+ (BOOL)isValidMnemonicPhrase: (NSString*)phrase;


+ (void)decryptSecretStorageJSON: (NSString*)json
                                password: (NSString*)password
                                callback: (void (^)(Account *account, NSError *NSError))callback;

+ (Address*)verifyMessage: (NSData*)message
                signature: (Signature*)signature;

- (void)sign: (Transaction*)transaction
    keystore: (NSString*)json
    password: (NSString*)password;

@end
