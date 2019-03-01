//
//  WalletUtils.h
//
//  Created by VeChain on 2018/8/12.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionParameter.h"
#import "Payment.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WalletAccountModel.h"

@interface WalletUtils : NSObject

NS_ASSUME_NONNULL_BEGIN

/**
 *  @abstract
 *  create wallet
 *
 *  @param password :Wallet password
 *  @param block : Callback after the end
 *
 */
+ (void)createWalletWithPassword:(NSString *)password
                        callback:(void(^)(WalletAccountModel *account,NSError *error))block;

/**
 *  @abstract
 *  create wallet with mnemonic
 *
 *  @param mnemonicList :12 words for create wallet
 *  @param password :Wallet password
 *  @param block : Callback after the end
 */

+ (void)creatWalletWithMnemonic:(NSArray *)mnemonicList
                      password:(NSString *)password
                       callback:(void(^)(WalletAccountModel *account,NSError *error))block;

/**
 *  @abstract
 *  Verify the mnemonic word is legal
 *
 *  @param mnemonicList :12 words
 *  @return verification results
 */
+ (BOOL)isValidMnemonicPhrase:(NSString*)mnemonicList;



/**
 *  @abstract
 *  recover address
 *
 *  @param message : Data before signature
 *  @param signatureData : Data after signature
 *
 *  @return address
 */
+ (NSString *)recoverAddressFromMessage:(NSData*)message
                          signatureData:(NSData*)signatureData;

/**
 *  @abstract
 *  sign message
 *
 *  @param message : Prepare the data to be signed
 *  @param json :Keystore in json format
 *  @param password :Wallet password
 *  @param block :Callback after the end
 *
 */
+ (void)signature:(NSData*)message
         keystore:(NSString*)json
         password:(NSString*)password
            block:(void (^)(NSData *signatureData,NSError *error))block;

/**
 *  @abstract
 *  Decryption keystore
 *
 *  @param json : Keystore in json format
 *  @param password : Wallet password
 *  @param callback : Callback after the end
 *
 */
+ (void)decryptSecretStorageJSON:(NSString*)json
                        password:(NSString*)password
                        callback:(void(^)(WalletAccountModel *account,NSError *error))callback;


/**
 *  @abstract
 *  Use the new password to encrypt.
 *
 *  @param password :Wallet password
 *  @param walletAccount :Account object
 *  @param callback :Callback after the end
 *
 */
+ (void)encryptSecretStorageJSON:(NSString*)password
                         account:(WalletAccountModel *)walletAccount
                        callback:(void (^)(NSString *))callback;

/**
 *  @abstract
 *  Set the keystore list to sdk
 *
 *  @param keystoreList :Array of keystore json
 *
 */
+ (void)initWebViewWithKeystore:(NSArray *)keystoreList;

/*! @abstract Displays a JavaScript text input panel.
 *  @param webView The web view invoking the delegate method.
 *  @param defaultText The initial text to display in the text entry field.
 *  @param completionHandler The completion handler to call after the text
input panel has been dismissed. Pass the entered text if the user chose
OK, otherwise nil.
*/
+ (void)webView:(WKWebView *)webView defaultText:(NSString *)defaultText completionHandler:(void (^)(NSString *result))completionHandler;

/**
 *  @abstract
 *  inject js into webview
 *
 *  @param webview :Developer generated webview object
 *
 */
+ (void)injectJSWithWebView:(WKWebView *)webview;

/**
 *  @abstract
 *   call sign control
 *
 *  @param parameter :Signature parameters
 *  @param keystore :Keystore in json format
 *  @param block :Callback after the end
 *
 */
+ (void)transactionWithKeystore:(NSString *)keystore parameter:(TransactionParameter *)parameter block:(void(^)(NSString *txId,NSString *signer))block;

/**
 *  @abstract
 *  Verify the mnemonic word is legal
 *  @param keystore :Keystore in json format
 *
 *  @return verification results
 */
+ (BOOL)isValidKeystore:(NSString *)keystore;

/**
 *  @abstract
 *  Verify get checksum address
 *
 *  @param address :Wallet address
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
