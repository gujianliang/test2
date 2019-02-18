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
#import "BigNumber.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WalletUtils : NSObject

/**
 *  @abstract
 *  creat wallet
 *
 *  @param password :wallet password
 *  @param block : finish creat wallet callback
 *
 */
+ (void)createWalletWithPassword:(NSString *)password
                      callback:(void(^)(Account *account))block;

/**
 *  @abstract
 *  creat wallet with mnemonic
 *
 *  @param mnemonic :12 words for creat wallet
 *  @param password :password for wallet
 *  @param block : finish creat wallet callback
 */
#warning  miss error
+ (void)creatWalletWithMnemonic:(NSString *)mnemonic
                      password:(NSString *)password
                      callback:(void(^)(Account *account))block;

/**
 *  @abstract
 *  Verify the mnemonic word is legal
 *
 *  @param mnemonic :12 words
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
+ (Address*)recoverAddressFromMessage:(NSData*)message
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

+ (void)setCurrentWallet:(NSString *)address;

+ (void)initWithWalletDict:(NSMutableArray *)walletList;

+ (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *_Nullable)frame completionHandler:(void (^_Nullable)(NSString * __nullable result))completionHandler;

+ (void)injectJS:(WKWebView *_Nonnull)webview;

+ (void)signViewFrom:(NSString *_Nonnull)from to:(NSString *_Nonnull)to amount:(NSString *_Nonnull)amount coinName:(NSString *_Nonnull)coinName block:(void(^)(NSString *txId))block;

@end
