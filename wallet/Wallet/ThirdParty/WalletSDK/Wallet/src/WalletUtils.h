//
//  WalletUtils.h
//
//  Created by VeChain on 2018/8/12.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionParameter.h"
#import "Signature.h"
#import "Account.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WalletAccountModel.h"

@interface WalletUtils : NSObject

NS_ASSUME_NONNULL_BEGIN

/**
 *  @abstract
 *  create wallet
 *
 *  @param password :wallet password
 *  @param block : finish create wallet callback
 *
 */
+ (void)createWalletWithPassword:(NSString *)password
                        callback:(void(^)(WalletAccountModel *account,NSError *error))block;

/**
 *  @abstract
 *  create wallet with mnemonic
 *
 *  @param mnemonicList :12 words for create wallet
 *  @param password :password for wallet
 *  @param block : finish create wallet callback
 */

+ (void)creatWalletWithMnemonic:(NSArray *)mnemonicList
                      password:(NSString *)password
                       callback:(void(^)(WalletAccountModel *account,NSError *error))block;

/**
 *  @abstract
 *  Verify the mnemonic word is legal
 *
 *  @param mnemonicList :12 words
 *
 *  @return verification results
 */
+ (BOOL)isValidMnemonicPhrase:(NSString*)mnemonicList;


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
                        callback:(void(^)(WalletAccountModel *account,NSError *error))callback;

/**
 *  @abstract
 *  verify Message
 *
 *  @param message : to verify the information
 *  @param signatureData : NSData signature (r,s,v)
 *
 *  @return object for address
 */
+ (NSString *)recoverAddressFromMessage:(NSData*)message
                          signatureData:(NSData*)signatureData;

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
+ (void)signature:(NSData*)message
         keystore:(NSString*)json
         password:(NSString*)password
            block:(void (^)(NSData *signatureData,NSError *error))block;

/**
 *  @abstract
 *  encrypt private key to keystore
 *
 *  @param password :password for wallet
 *  @param walletAccount :object for private key
 *  @param callback :finish encrypt callback
 *
 */
+ (void)encryptSecretStorageJSON:(NSString*)password
                         account:(WalletAccountModel *)walletAccount
                        callback:(void (^)(NSString *))callback;

/**
 *  @abstract
 *  encrypt set current wallet address
 *
 *  @param address :current wallet address
 *
 */
+ (void)setCurrentWallet:(NSString *)address;

/**
 *  @abstract
 *  encrypt set current wallet address
 *
 *  @param walletList :wallet list ,one item NSDictionary,has 2 key,address and keystore
 address: wallet addres
 keystore: json
 *
 */
+ (void)initWithWalletDict:(NSMutableArray *)walletList;

/*! @abstract Displays a JavaScript text input panel.
    @param webView The web view invoking the delegate method.
    @param defaultText The initial text to display in the text entry field.
    @param completionHandler The completion handler to call after the text
input panel has been dismissed. Pass the entered text if the user chose
OK, otherwise nil.
*/
+ (void)webView:(WKWebView *)webView defaultText:(NSString *)defaultText completionHandler:(void (^)(NSString *result))completionHandler;

/**
 *  @abstract
 *  encrypt inject js into webview
 *
 *  @param webview The web view invoking the developper new.
 *
 */
+ (void)injectJS:(WKWebView *)webview;

/**
 *  @abstract
 *  encrypt The call sign control
 *
 *  @param parameter Signature parameters
 *  @param keystore wallet for keystore
 *  @param block callback
 *
 */
+ (void)transactionWithKeystore:(NSString *)keystore parameter:(TransactionParameter *)parameter block:(void(^)(NSString *txId,NSString *signer))block;

/**
 *  @abstract
 *  Verify the mnemonic word is legal
 *
 *  @param keystore :wallet for keystore
 *
 *  @return verification results
 */
+ (BOOL)isValidKeystore:(NSString *)keystore;

/**
 *  @abstract
 *  Verify get checksum address
 *
 *  @param address :wallet for address
 *
 *  @return checksum address
 */
+ (NSString *)getChecksumAddress:(NSString *)address;

/**
 *  @abstract
 *  setup node url
 *
 *  @param nodelUrl :node url
 *
 */
+ (void)setNode:(NSString *)nodelUrl;

NS_ASSUME_NONNULL_END

@end
