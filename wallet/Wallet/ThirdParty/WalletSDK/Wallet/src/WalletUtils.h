//
//  WalletUtils.h
//
//  Created by VeChain on 2018/8/12.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionParameter.h"
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

+ (void)setNode:(NSString *)nodelUrl;

/**
 *  @abstract
 *  create wallet
 *
 *  @param password :wallet password
 *  @param block : finish create wallet callback
 *
 */
+ (void)createWalletWithPassword:(NSString *)password
                      callback:(void(^)(Account *account))block;

/**
 *  @abstract
 *  create wallet with mnemonic
 *
 *  @param mnemonic :12 words for create wallet
 *  @param password :password for wallet
 *  @param block : finish create wallet callback
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
    @param prompt The prompt to display.
    @param defaultText The initial text to display in the text entry field.
    @param frame Information about the frame whose JavaScript initiated this call.
    @param completionHandler The completion handler to call after the text
input panel has been dismissed. Pass the entered text if the user chose
OK, otherwise nil.
*/
+ (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *_Nullable)frame completionHandler:(void (^_Nullable)(NSString * __nullable result))completionHandler;

/**
 *  @abstract
 *  encrypt inject js into webview
 *
 *  @param webview The web view invoking the developper new.
 *
 */
+ (void)injectJS:(WKWebView *_Nonnull)webview;

/**
 *  @abstract
 *  encrypt set current wallet address
 *
 *  @param from wallet address
 *  @param to  address
 *  @param amount transfer
 *  @param block callback
 *
 */
+ (void)transactionWithKeystore:(NSString *)keystore parameter:(TransactionParameter *)parameter block:(void(^)(NSString *txId,NSString *signer))block;



@end
