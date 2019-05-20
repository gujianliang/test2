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

#import "WalletSDKMacro.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WalletUtilsDelegate <NSObject>

#pragma mark setDelegate

/**
 *  @abstract
 *  App developer implementation when dapp calls transaction function
 *  delegate function that must be implemented to support the DApp environment
 *
 *  @param clauses : Clause model list
 *  @param gas : Set maximum gas allowed for call
 *  @param signer : Enforces the specified address to sign the transaction
 *  @param callback : Callback after the end. txid:Transaction identifier; signer:Signer address
 *
 */
- (void)onTransfer:(NSArray<ClauseModel *> *)clauses
            signer:(NSString *)signer
               gas:(NSString *)gas
          callback:(void(^)(NSString *txid ,NSString *signer))callback;

/**
 *  @abstract
 *   App developer implementation when dapp calls get address function
 *   delegate function that must be implemented to support the DApp environment
 *
 *  @param callback : Callback after the end
 *
 */
- (void)onGetWalletAddress:(void(^)(NSArray<NSString *> *addressList))callback;

/**
 *  @abstract
 *   App developer implementation when dapp calls authentication function
 *   delegate function that must be implemented to support the DApp environment
 *
 *  @param message : Data to be signed,form dapp
 *  @param signer : Enforces the specified address to sign the certificate
 *  @param callback : Callback after the end.signer: Signer address; signatureData : Signature is 65 bytes
 *
 */
- (void)onCertificate:(NSDictionary *)message
               signer:(NSString *)signer
             callback:(void(^)(NSString *signer, NSData *signatureData))callback;


/**
 *  @abstract
 *   App developer implementation when dapp calls checkOwn address function
 *   delegate function that must be implemented to support the DApp environment
 *
 *  @param address : Address from dapp
 *  @param callback : Callback after the end
 *
 */
- (void)onCheckOwnAddress:(NSString *)address callback:(void(^)(BOOL result))callback;

@end

@interface WalletUtils : NSObject

@property(nonatomic, weak) id<WalletUtilsDelegate> delegate;

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
 *  Create wallet
 *
 *  @param password : Wallet password
 *  @param callback : Callback after the end;The attributes of a class has mnemonicPhras , address, privateKey, keystore
 *
 */
+ (void)createWalletWithPassword:(NSString *)password
                       callback:(void(^)(WalletAccountModel *account,NSError *error))callback;

/**
 *  @abstract
 *  Create wallet with mnemonic words
 *
 *  @param mnemonicWords :Mnemonic Words
 *  @param password : Wallet password
 *  @param callback : Callback after the end;The attributes of a class has mnemonicPhras , address, privateKey, keystore
 */

+ (void)createWalletWithMnemonicWords:(NSArray<NSString *> *)mnemonicWords
                            password:(NSString *)password
                            callback:(void(^)(WalletAccountModel *account,NSError *error))callback;

/**
 *  @abstract
 *  Verify mnemonic words
 *
 *  @param mnemonicWords : Mnemonic words,Number of mnemonic words : 12, 15, 18, 21 and 24.
 *  @return result
 */
+ (BOOL)isValidMnemonicWords:(NSArray<NSString *> *)mnemonicWords;

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
 *  @param message : Data to be signed
 *  @param signatureData : Signature is 65 bytes
 *
 *  @return address
 */
+ (NSString *)recoverAddressFromMessage:(NSData*)message
                          signatureData:(NSData*)signatureData;

/**
 *  @abstract
 *  Verify keystore format
 *
 *  @param keystoreJson :Keystore JSON encryption format for user wallet private key
 *
 *  @return verification result
 */
+ (BOOL)isValidKeystore:(NSString *)keystoreJson;


/**
 *  @abstract
 *  Get address from keystore
 *
 *  @param keystoreJson :  Keystore JSON encryption format for user wallet private key
 *
 */
+ (NSString *)getAddressWithKeystore:(NSString *)keystoreJson;

/**
 *  @abstract
 *  Change Wallet password
 *
 *  @param oldPassword : old password for wallet.
 *  @param newPassword : new password for wallet.
 *  @param keystoreJson :  Keystore JSON encryption format for user wallet private key
 *  @param callback : Callback after the end
 *
 */
+ (void)modifyKeystore:(NSString *)keystoreJson
           newPassword:(NSString *)newPassword
           oldPassword:(NSString *)oldPassword
              callback:(void (^)(NSString *newKeystore))callback;;

/**
 *  @abstract
 *  Verify the keystore with a password
 *
 *  @param keystoreJson :  Keystore JSON encryption format for user wallet private key
 *  @param password :  Wallet password
 *  @param callback : Callback after the end
 *
 */
+ (void)verifyKeystore:(NSString *)keystoreJson
              password:(NSString *)password
              callback:(void (^)(BOOL result))callback;
/**
 *  @abstract
 *  Decrypt keystore
 *
 *  @param keystoreJson : Keystore JSON encryption format for user wallet private key
 *  @param password : Wallet password
 *  @param callback : Callback after the end. Callback after the end;The attributes of a class has mnemonicPhras , address, privateKey, keystore
 *
 */
+ (void)decryptKeystore:(NSString*)keystoreJson
               password:(NSString*)password
               callback:(void(^)(NSString *privateKey,NSError *error))callback;


/**
 *  @abstract
 *  Encrypted private key
 *
 *  @param password : Wallet password
 *  @param privateKey : PrivateKey
 *  @param callback : Callback after the end. keystoreJson : Keystore in json format
 *
 */
+ (void)encryptPrivateKeyWithPassword:(NSString*)password
                           privateKey:(NSString *)privateKey
                            callback:(void (^)(NSString *keystoreJson))callback;

/**
 *  @abstract
 *   Get chainTag of block chain
 *
 *  @param callback : Callback after the end
 *
 */
+ (void)getChainTag:(void (^)(NSString *chainTag))callback;

/**
 *  @abstract
 *   Get reference of block chain
 *  @param callback : Callback after the end
 *
 */
+ (void)getBlockReference:(void (^)(NSString *blockReference))callback;


/**
 *  @abstract
 *   Signed transaction
 *
 *  @param parameter : Transaction parameters
 *  @param keystoreJson :  Keystore JSON encryption format for user wallet private key
 *  @param password : Wallet password
 *  @param callback :  Callback after the end. raw: RLP encode data and signature
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
 *  @param keystoreJson :  Keystore JSON encryption format for user wallet private key
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
 *  Add the signature address to the authentication signature data
 *
 *  @param signer : Enforces the specified address to sign the certificate
 *  @param message : Authentication signature data
 */
+ (NSString *)addSignerToCertMessage:(NSString *)signer message:(NSDictionary *)message;

/**
 *  @abstract
 *  Sign and send
 *
 *  @param parameter : Signature parameters
 *  @param keystoreJson :  Keystore JSON encryption format for user wallet private key
 *  @param password : Wallet password
 *  @param callback : Callback after the end
 *
 */
+ (void)signAndSendTransferWithParameter:(TransactionParameter *)parameter
                            keystore:(NSString*)keystoreJson
                            password:(NSString *)password
                            callback:(void(^)(NSString *txid))callback;

/**
 *  @abstract
 *  Set delegate to SDK
 *
 *  @param delegate : delegate object
 */
+ (void)initDAppWithDelegate:(id)delegate;

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
 *  @param config : Developer generated WKWebViewConfiguration object
 *
 */
+ (void)injectJSWithWebView:(WKWebViewConfiguration *)config;

/**
 *  @abstract
 *  Release the singleton of dapp
 *
 *  Call this method when exiting the contrller where dapp is located
 *
 */
+ (void)deallocDApp;


/**
 *  @abstract
 *  Get SDK Version
 *
 *
 *
 */
+ (NSString *)getVersion;



NS_ASSUME_NONNULL_END




@end
