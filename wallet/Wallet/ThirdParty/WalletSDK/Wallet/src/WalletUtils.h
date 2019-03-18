//
//  WalletUtils.h
//
//  Created by VeChain on 2018/8/12.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionParameter.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WalletAccountModel.h"
#import "MBProgressHUD.h"
#import "BigNumber.h"

@interface WalletUtils : NSObject

NS_ASSUME_NONNULL_BEGIN

/**
 *  @abstract
 *  Create wallet
 *
 *  @param password : Wallet password
 *  @param callback : Callback after the end;The attributes of a class has mnemonicPhras , address, privateKey, keystore
 *
 */
+ (void)creatWalletWithPassword:(NSString *)password
                       callback:(void(^)(WalletAccountModel *account,NSError *error))callback;

/**
 *  @abstract
 *  Create wallet with mnemonic words
 *
 *  @param mnemonicWords :12 words
 *  @param password : Wallet password
 *  @param callback : Callback after the end;The attributes of a class has mnemonicPhras , address, privateKey, keystore
 */

+ (void)creatWalletWithMnemonicWords:(NSArray *)mnemonicWords
                            password:(NSString *)password
                            callback:(void(^)(WalletAccountModel *account,NSError *error))callback;

/**
 *  @abstract
 *  Verify mnemonic words
 *
 *  @param mnemonicWords : 12 words
 *  @return result
 */
+ (BOOL)isValidMnemonicWords:(NSArray *)mnemonicWords;

/**
 *  @abstract
 *  Recover address
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
 *  Verify the mnemonic word is legal
 *  @param keystoreJson :Keystore in json format
 *
 *  @return verification result
 */
+ (BOOL)isValidKeystore:(NSString *)keystoreJson;

/**
 *  @abstract
 *  Get checksum address
 *
 *  @param address :Wallet address
 *
 *  @return checksum address
 */
+ (NSString *)getChecksumAddress:(NSString *)address;


/**
 *  @abstract
 *  Decrypt keystore
 *
 *  @param keystoreJson : Keystore in json format
 *  @param password : Wallet password
 *  @param callback : Callback after the end. Callback after the end;The attributes of a class has mnemonicPhras , address, privateKey, keystore
 *
 */
+ (void)decryptKeystore:(NSString*)keystoreJson
               password:(NSString*)password
               callback:(void(^)(WalletAccountModel *account,NSError *error))callback;


/**
 *  @abstract
 *  Change keystore password
 *
 *  @param password : Wallet password
 *  @param account : WalletAccountModel object
 *  @param callback : Callback after the end. keystoreJson : Keystore in json format
 *
 */
+ (void)encryptKeystoreWithPassword:(NSString*)password
                            account:(WalletAccountModel *)account
                           callback:(void (^)(NSString *keystoreJson))callback;

/**
 *  @abstract
 *  Set node url
 *
 *  @param nodelUrl : node url
 *
 */
+ (void)setNode:(NSString *)nodelUrl;

/**
 *  @abstract
 *  Get node url
 *
 */
+ (NSString *)getNode;

/**
 *  @abstract
 *  Sign message
 *
 *  @param message : Prepare the data to be signed
 *  @param keystoreJson : Keystore in json format
 *  @param password : Wallet password
 *  @param callback : Callback after the end
 *
 */
+ (void)sign:(NSData*)message
    keystore:(NSString*)keystoreJson
    password:(NSString*)password
    callback:(void (^)(NSData *signatureData,NSError *error))callback;

/**
 *  @abstract
 *  Sign and send
 *
 *  @param parameter : Signature parameters
 *  @param keystoreJson : Keystore in json format
 *  @param callback : Callback after the end
 *
 */
+ (void)sendWithKeystore:(NSString *)keystoreJson
               parameter:(TransactionParameter *)parameter
                callback:(void(^)(NSString *txId,NSString *signer))callback;

/**
 *  @abstract
 *  Set keystore list to SDK
 *
 *  @param keystoreList : Array of keystore json
 *
 */
+ (void)initDappWebViewWithKeystore:(NSArray *)keystoreList;

/*! @abstract
 *  Displays a JavaScript text input panel.
 *
 *  @param webView : The web view invoking the delegate method.
 *  @param defaultText : The initial text to display in the text entry field.
 *  @param completionHandler : The completion handler to call after the text
input panel has been dismissed. Pass the entered text if the user chose
OK, otherwise nil.
*/
+ (void)webView:(WKWebView *)webView
    defaultText:(NSString *)defaultText
completionHandler:(void (^)(NSString *result))completionHandler;

/**
 *  @abstract
 *  Inject js into webview
 *
 *  @param webview : Developer generated webview object
 *
 */
+ (void)injectJSWithWebView:(WKWebView *)webview;

/**
 *  @abstract
 *  Release the singleton of dapp
 *
 *  Call this method when exiting the contrller where dapp is located
 *
 */
+ (void)deallocDappSingletion;

/**
 *  @abstract
 *  Convert wei to value strings
 *
 *  @param wei : The minimum unit of coin
 *  @param decimals : decimals of coin
 *
 */
+ (NSString*)formatToken:(BigNumber*)wei decimals:(NSUInteger)decimals;

/**
 *  @abstract
 *  Convert the number of coin to wei
 *
 *  @param decimals : decimals of coin
 *  @param valueString : the number of coin
 *
 */
+ (BigNumber*)parseToken:(NSString*)valueString dicimals:(NSUInteger)decimals;

NS_ASSUME_NONNULL_END

@end
