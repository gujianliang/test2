//
//  WalletUtils.h
//
//  Created by VeChain on 2018/8/12.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"
#import "Signature.h"
#import "Transaction.h"
#import "Account.h"
#import "SecureData.h"
#import "Payment.h"

@interface WalletUtils : NSObject

/**
 *  @abstract
 *  creat wallet
 *
 *  @param password :wallet password
 *  @param block : finish creat wallet callback
 *
 */
+ (void)creatWalletWithPassword:(NSString *)password
                      callback:(void(^)(Account *account))block;

/**
 *  @abstract
 *  creat wallet with mnemonic
 *
 *  @param mnemonic :12 words for creat wallet
 *  @param password :password for wallet
 *  @param block : finish creat wallet callback
 */
+ (void)creatWalletWithMnemonic:(NSString *)mnemonic
                      password:(NSString *)password
                      callback:(void(^)(Account *account))block;

/**
 *  @abstract
 *  Verify the mnemonic word is legal
 *
 *  @param mnemonic :12 wordws
 *
 *  @return verification results
 */
+ (BOOL)isValidMnemonicPhrase:(NSString*)mnemonic;


/**
 *  @abstract
 *  Decryption keystore
 *
 *  @param json : json string for keystore
 *  @param password : password for wallet
 *  @param callback : finish decryption keystore callback
 *
 */
+ (void)decryptSecretStorageJSON:(NSString*)json
                                password:(NSString*)password
                                callback:(void (^)(Account *account, NSError *NSError))callback;

/**
 *  @abstract
 *  verify Message
 *
 *  @param message : to verify the information
 *  @param signature : object signature
 *
 *  @return object for address
 */
+ (Address*)verifyMessage:(NSData*)message
                signature:(Signature*)signature;

/**
 *  @abstract
 *  sign message
 *
 *  @param message : message for sign
 *  @param json :json string for keystore
 *  @param password :password for wallet
 *  @param block :finish sign block
 *
 */
+ (void)sign:(NSData*)message
    keystore:(NSString*)json
    password:(NSString*)password
       block:(void (^)(Signature *signature))block;

/**
 *  @abstract
 *  encrypt private key to keystore
 *
 *  @param password :password for wallet
 *  @param account :object for private key
 *  @param callback :finish encrypt callback
 *
 */
+ (void)encryptSecretStorageJSON:(NSString*)password
                         account:(Account *)account
                        callback:(void (^)(NSString *))callback;
@end
