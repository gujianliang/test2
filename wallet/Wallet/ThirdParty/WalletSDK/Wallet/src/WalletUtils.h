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

@protocol WalletUtilsDelegate <NSObject>
#pragma mark setDelegate
/**
 *  @abstract
 *  Dapp call transfer function ,app developer implementation
 *  @param clauses : clause list.
 *  @param gas : Set maximum gas allowed for call.
 *  @param callback : Callback after the end
 *
 */
- (void)onTransfer:(NSArray *)clauses gas:(NSString *)gas callback:(void(^)(NSString *txid))callback;
/**
 *  @abstract
 *   Dapp call get address ,app developer implementation
 *  @param callback : Callback after the end
 *
 */
- (void)onGetWalletAddress:(void(^)(NSArray *addressList))callback;
@end

@interface WalletUtils : NSObject
@property(nonatomic, weak) id<WalletUtilsDelegate> delegate;
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
 *  @param mnemonicWords :Mnemonic Words
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
 *  @param mnemonicWords : Words
 *  @return result
 */
+ (BOOL)isValidMnemonicWords:(NSArray *)mnemonicWords;

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
 *  Check if the keystore format is correct
 *  @param keystoreJson :Keystore in json format
 *
 *  @return verification result
 */
+ (BOOL)isValidKeystore:(NSString *)keystoreJson;


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
               callback:(void(^)(NSString *privateKey,NSError *error))callback;


/**
 *  @abstract
 *  Change keystore password
 *
 *  @param password : Wallet password
 *  @param privateKey : privateKey
 *  @param callback : Callback after the end. keystoreJson : Keystore in json format
 *
 */
+ (void)encryptPrivateKeyWithPassword:(NSString*)password
                           privateKey:(NSString *)privateKey
                            callback:(void (^)(NSString *keystoreJson))callback;

/**
 *  @abstract
 *  Set node url
 *
 *  @param nodelUrl : node url
 *
 */
+ (void)setNodeUrl:(NSString *)nodelUrl;

/**
 *  @abstract
 *  Get node url
 *
 */
+ (NSString *)getNodeUrl;

/**
 *  @abstract
 *  Sign transfer message
 *
 *  @param parameter : Prepare the data to be signed
 *  @param keystoreJson : Keystore in json format
 *  @param password : Wallet password
 *  @param callback : Callback after the end
 *
 */
+ (void)signWithParameter:(TransactionParameter *)parameter
                 keystore:(NSString*)keystoreJson
                 password:(NSString*)password
                 callback:(void(^)(NSString *raw))callback;

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
+ (void)signWithMessage:(NSData *)message
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
+ (void)signAndSendTransfer:(NSString *)keystoreJson
                  parameter:(TransactionParameter *)parameter
                   password:(NSString *)password
                   callback:(void(^)(NSString *txId))callback;

/**
 *  @abstract
 *  Set delegate to SDK
 *
 *  @param delegate : delegate object
 *  reture :YES ,set delegate success;NO ,set delegate fail
 */
+ (BOOL)initDAppWithDelegate:(id)delegate;

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
 *  Change Wallet password
 *  @param oldPassword : old password for wallet.
 *  @param newPassword : new password for wallet.
 *  @param keystoreJson : Keystore in json format.
 *  @param callback : Callback after the end
 *
 */
+ (void)modifyKeystorePassword:(NSString *)oldPassword
                         newPW:(NSString *)newPassword
                  keystoreJson:(NSString *)keystoreJson
                      callback:(void (^)(NSString *newKeystore))callback;

/**
 *  @abstract
 *  Verify the keystore with a password
 *  @param keystoreJson : Keystore in json format.
 *  @param password : password for wallet.
 *  @param callback : Callback after the end
 *
 */
+ (void)verifyKeystorePassword:(NSString *)keystoreJson
                      password:(NSString *)password
                      callback:(void (^)(BOOL result))callback;

/**
 *  @abstract
 *   Get chainTag
 *  @param callback : Callback after the end
 *
 */
+ (void)getChainTag:(void (^)(NSString *chainTag))callback;

/**
 *  @abstract
 *   Get reference of block
 *  @param callback : Callback after the end
 *
 */
+ (void)getBlockReference:(void (^)(NSString *blockReference))callback;
/**
 *  @abstract
 *  Get address from keystore
 *  @param keystoreJson : Keystore in json format.
 *
 */
+ (NSString *)getAddressWithKeystore:(NSString *)keystoreJson;




NS_ASSUME_NONNULL_END

@end
