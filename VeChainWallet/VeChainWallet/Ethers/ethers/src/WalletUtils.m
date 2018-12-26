//
//  WalletUtils.m
//  ethers
//
//  Created by 曾新 on 2018/8/12.
//  Copyright © 2018年 Ethers. All rights reserved.
//

#import "WalletUtils.h"

@implementation WalletUtils

+(void)creatWalletWithPassword:(NSString *)password callBack:(void(^)(Account *account)) block
{
    __block Account *account = [Account randomMnemonicAccount];
    
    [account encryptSecretStorageJSON:password callback:^(NSString *json) {
        
         account.keystore = json;
        if (block) {
            block(account);
        }
    }];
}

+(void)creatWalletWithMnemonic:(NSString *)Mnemonic
                      password:(NSString *)password
                      callBack:(void(^)(Account *account)) block
{
    __block Account *account = [Account accountWithMnemonicPhrase:Mnemonic];
    
    [account encryptSecretStorageJSON:password callback:^(NSString *json) {
        
        account.keystore = json;
        if (block) {
            block(account);
        }
    }];
}

+ (BOOL)isValidMnemonicPhrase: (NSString*)phrase
{
    return [Account isValidMnemonicPhrase:phrase];
}



+ (void)decryptSecretStorageJSON: (NSString*)json
                                password: (NSString*)password
                                callback: (void (^)(Account *account, NSError *NSError))callback
{
    [Account decryptSecretStorageJSON:json password:password callback:callback];
}

+ (Address*)verifyMessage: (NSData*)message
                signature: (Signature*)signature
{
   return [Account verifyMessage:message signature:signature];
}

+ (void)sign: (NSData*)message
    keystore: (NSString*)json
    password: (NSString*)password
       block:(void (^)(Signature *signature))block
{
    [Account decryptSecretStorageJSON:json
                             password:password
                             callback:^(Account *account, NSError *NSError)
     {
         // 签名交易
         if (NSError == nil) {
            SecureData *data = [SecureData BLAKE2B:message];
            Signature *signature = [account signDigest:data.data];
             if (block) {
                 block(signature);
             }
         }
     }];
}



@end
