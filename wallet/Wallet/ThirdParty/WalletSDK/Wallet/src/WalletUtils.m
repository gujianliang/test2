//
//  WalletUtils.m
//
//  Created by VeChain on 2018/8/12.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletUtils.h"
#import "WalletDAppHandle.h"
#import "WalletTools.h"
#import "WalletDAppHead.h"
#import "WalletMBProgressShower.h"
#import "WalletGetDecimalsApi.h"
#import "WalletGetSymbolApi.h"
#import "WalletSignParamModel.h"
#import "SecureData.h"
#import "Account.h"
#import "RLPSerialization.h"
#import "WalletGenesisBlockInfoApi.h"
#import "WalletBlockInfoApi.h"
#import "WalletDappCheckParamsHandle.h"

#import "WalletDAppHandle+transfer.h"

@implementation WalletUtils


+ (void)createWalletWithPassword:(NSString *)password
                       callback:(void(^)(WalletAccountModel *accountModel,NSError *error))callback
{
    NSString *domain = @"com.wallet.ErrorDomain";
    NSString *desc = @"password is invaild";
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
    
    NSError *error = [NSError errorWithDomain:domain
                                         code:-101
                                     userInfo:userInfo];
    
    if (password.length == 0) {
        
        if (callback) {
            callback(nil,error);
        }
        return;
    }
    __block Account *account = [Account randomMnemonicAccount];
    
    [account encryptSecretStorageJSON:password callback:^(NSString *json) {
        
         account.keystore = json;
        if (json.length == 0) {
            NSString *domain = @"com.wallet.ErrorDomain";
            NSString *desc = @"Failed to generate keystore";
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
            
            NSError *error = [NSError errorWithDomain:domain
                                                 code:-102
                                             userInfo:userInfo];
            if (callback) {
                callback(nil,error);
            }
            return ;
        }else{
            if (callback) {
                WalletAccountModel *accountModel = [[WalletAccountModel alloc]init];
                accountModel.keystore = json;
                accountModel.privatekey = [SecureData dataToHexString:account.privateKey];
                accountModel.address = account.address.checksumAddress;
                accountModel.words = [account.mnemonicPhrase componentsSeparatedByString:@" "];
                
                callback(accountModel,nil);
            }
        }
    }];
}

// mnemonicWords count 12,15,18,21,24
+ (void)createWalletWithMnemonicWords:(NSArray<NSString *> *)mnemonicWords
                            password:(NSString *)password
                            callback:(void(^)(WalletAccountModel *account,NSError *error))callback
{
    
    NSString *domain = @"com.wallet.ErrorDomain";
    NSString *desc = @"mnemonicWords is invaild";
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
    
    NSError *error = [NSError errorWithDomain:domain
                                         code:-101
                                     userInfo:userInfo];
    
    
    if (![WalletUtils  isValidMnemonicWords:mnemonicWords]) {
        
        NSLog(@"mnemonicWords is invaild");
        if (callback) {
            callback(nil, error);
        }
        return;
    }
    
    NSMutableArray *trimeList = [NSMutableArray array];
    for (NSString * word in mnemonicWords) {
        if (word.length == 0) {
            if (callback) {
                callback(nil, error);
            }
            return;
        }else{
            NSString *trimeWord = [word stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [trimeList addObject:trimeWord];
        }
    }
    
    __block Account *account = [Account accountWithMnemonicPhrase:[trimeList componentsJoinedByString:@" "]];
    
    if (!account) {
        if (callback) {

            callback(nil, error);
        }
        return;
    }
    
    [account encryptSecretStorageJSON:password callback:^(NSString *json) {
        
        account.keystore = json;
        if (json.length == 0) {
            if (callback) {
                callback(nil, error);
            }
            
        }else{
            if (callback) {
                
                WalletAccountModel *accountModel = [[WalletAccountModel alloc]init];
                accountModel.keystore = json;
                accountModel.privatekey = [SecureData dataToHexString:account.privateKey];
                accountModel.address = account.address.checksumAddress;
                accountModel.words = [account.mnemonicPhrase componentsSeparatedByString:@" "];
                
                callback(accountModel, nil);
            }
        }
    }];
}

+ (BOOL)isValidMnemonicWords:(NSArray<NSString *> *)mnemonicWords;
{
    if (mnemonicWords.count < 12 || mnemonicWords.count > 24) {
        return NO;
    }
    
    NSMutableArray *trimeList = [NSMutableArray array];
    for (NSString * word in mnemonicWords) {
        if (word.length == 0) {
            return NO;
        }else{
            NSString *trimeWord = [word stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [trimeList addObject:trimeWord];
        }
    }
    return [Account isValidMnemonicPhrase:[mnemonicWords componentsJoinedByString:@" "]];
}

+ (void)decryptKeystore:(NSString*)keystoreJson
               password:(NSString*)password
               callback:(void(^)(NSString *privateKey,NSError *error))callback
{
    [Account decryptSecretStorageJSON:keystoreJson password:password callback:^(Account *account, NSError *decryptError) {
        
        if (decryptError == nil) {
            
            if (callback) {
                callback(account.address.checksumAddress,nil);
            }
        }else{
            if (callback) {
                callback(nil, decryptError);
            }
        }
    }];
}

+ (void)encryptPrivateKeyWithPassword:(NSString*)password
                           privateKey:(NSString *)privateKey
                             callback:(void (^)(NSString *keystoreJson))callback
{
    NSData *dataPrivate = [SecureData hexStringToData:privateKey];
    Account *ethAccount = [Account accountWithPrivateKey:dataPrivate];
    [ethAccount encryptSecretStorageJSON:password
                                callback:^(NSString *json)
     {
         if (json.length > 0) {
             if (callback) {
                 callback(json);
             }
         }else{
             if (callback) {
                 callback(nil);
             }
         }
     }];
}


+ (NSString *)recoverAddressFromMessage:(NSData*)message
                signatureData:(NSData *)signatureData
{
    SecureData *digest = [SecureData BLAKE2B:message];
    Signature *signature = [Signature signatureWithData:signatureData];
    return [Account verifyMessage:digest.data signature:signature].checksumAddress;
}


+ (BOOL)initDAppWithDelegate:(id)delegate
{
    WalletDAppHandle *dappHandle = [WalletDAppHandle shareWalletHandle];
    dappHandle.delegate = delegate;
    
    if (![delegate respondsToSelector:@selector(onTransfer: gas: callback:)] ||
        ![delegate respondsToSelector:@selector(onGetWalletAddress:)]) {
        return NO;
    }
    return YES;
}

+ (void)webView:(WKWebView *)webView defaultText:(NSString *)defaultText completionHandler:(void (^)(NSString * result))completionHandler
{
    WalletDAppHandle *dappHandle = [WalletDAppHandle shareWalletHandle];
    [dappHandle webView:webView defaultText:defaultText completionHandler:completionHandler];
}

+ (void)injectJSWithWebView:(WKWebView *)webview
{
    WalletDAppHandle *dappHandle = [WalletDAppHandle shareWalletHandle];
    [dappHandle injectJS:webview];
}

+ (void)signAndSendTransferWithParameter:(TransactionParameter *)parameter
                            keystore:(NSString*)keystoreJson
                            password:(NSString *)password
                            callback:(void(^)(NSString *txId))callback
{
    // check keystore format
    if (![WalletTools checkKeystore:keystoreJson]) {
        
        if (callback) {
            callback(nil);
        }
        return;
    }
    
    [WalletDappCheckParamsHandle checkParamClause:parameter
                                         callback:^(NSString * _Nonnull error, bool result)
    {
        if (!result) {
            if (callback) {
                callback(nil);
            }
            return;
        }else{
            
            [WalletUtils signTransfer:parameter keystore:keystoreJson password:password isSend:YES  completionHandler:callback];
        }
    }];
     
}

+ (void)signWithParameter:(TransactionParameter *)parameter
                 keystore:(NSString*)keystoreJson
                 password:(NSString*)password
                 callback:(void(^)(NSString *raw))callback
{
    // check keystore format
    if (![WalletTools checkKeystore:keystoreJson]) {
        
        if (callback) {
            callback(nil);
        }
        return;
    }
    
    [WalletDappCheckParamsHandle checkParamClause:parameter
                                         callback:^(NSString * _Nonnull error, bool result)
     {
         if (!result) {
             if (callback) {
                 callback(nil);
             }
             return;
         }else{
             [WalletUtils signTransfer:parameter keystore:keystoreJson password:password isSend:NO completionHandler:callback];
         }
     }];
    
}

+ (void)signWithMessage:(NSData *)message
               keystore:(NSString*)keystoreJson
               password:(NSString*)password
               callback:(void (^)(NSData *signatureData,NSError *error))callback
{
    [Account decryptSecretStorageJSON:keystoreJson
                             password:password
                             callback:^(Account *account, NSError *error)
     {
         // Signature trading
         if (error == nil) {
             SecureData *data = [SecureData BLAKE2B:message];
             Signature *signature = [account signDigest:data.data];
             if (callback) {
                 SecureData *vData = [[SecureData alloc]init];
                 [vData appendByte:signature.v];
                 
                 NSString *s = [SecureData dataToHexString:signature.s];
                 NSString *r = [SecureData dataToHexString:signature.r];
                 
                 NSString *hashStr = [NSString stringWithFormat:@"0x%@%@%@",
                                      [r substringFromIndex:2],
                                      [s substringFromIndex:2],
                                      [vData.hexString substringFromIndex:2]];
                 
                 if (signature.v == 2
                     || signature.v == 3) {
                     
                     if (callback) {
                         callback(nil,error);
                     }
                 }else{
                     if (callback) {
                         callback([SecureData hexStringToData:hashStr],nil);
                     }
                 }
             }
         }else{
             if (callback) {
                 callback(nil,error);
             }
         }
     }];
}

+ (BOOL)isValidKeystore:(NSString *)keystoreJson
{
   return [WalletTools checkKeystore:keystoreJson];
}

+ (NSString *)getChecksumAddress:(NSString *)address
{
   return [WalletTools checksumAddress:address];
}

+ (void)setNodeUrl:(NSString *)nodelUrl
{
    if (nodelUrl.length == 0) {
        [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view
                                      Text:ERROR_REQUEST_PARAMS_MSG During:1];
        return;
    }
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [WalletUserDefaultManager setBlockUrl:nodelUrl];
}

+ (NSString *)getNodeUrl
{
    return [WalletUserDefaultManager getBlockUrl];
}

+ (void)deallocDApp
{
    [WalletDAppHandle attempDealloc];
    
    UIView *signView = [[WalletTools getCurrentNavVC].view viewWithTag:SignViewTag];
    if (signView) {
        [signView removeFromSuperview];
    }
}

+ (void)modifyKeystore:(NSString *)keystoreJson
           newPassword:(NSString *)newPassword
           oldPassword:(NSString *)oldPassword
              callback:(void (^)(NSString *newKeystore))callback;
{
    [WalletUtils decryptKeystore:keystoreJson password:oldPassword callback:^(NSString * _Nonnull privatekey, NSError * _Nonnull error) {
        
        if (error) {
            callback(nil);
            return ;
        }else{
            [WalletUtils encryptPrivateKeyWithPassword:newPassword privateKey:privatekey callback:^(NSString * _Nonnull keystoreJson) {
                
                callback(keystoreJson);
                
            }];
        }
    }];
}

+ (void)verifyKeystore:(NSString *)keystore
                      password:(NSString *)password
                      callback:(void (^)(BOOL result))callback
{
    [WalletUtils decryptKeystore:keystore password:password callback:^(NSString * _Nonnull privatekey, NSError * _Nonnull error){
        
        if (privatekey) {
            callback(YES);
        }else{
            callback(NO);
        }
    }];
}

+ (void)getChainTag:(void (^)(NSString *chainTag))callback
{
    WalletGenesisBlockInfoApi *genesisBlock = [WalletGenesisBlockInfoApi new];
    [genesisBlock loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        WalletBlockInfoModel *genesisblockModel = finishApi.resultModel;
        NSString *blockID = genesisblockModel.id;
        NSString *chainTag = [NSString stringWithFormat:@"0x%@", [blockID substringFromIndex:blockID.length-2]];
        
        if (callback) {
            callback(chainTag);
        }
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        if (callback) {
            callback(nil);
        }
    }];
}

+ (void)getBlockReference:(void (^)(NSString *blockReference))callback
{
    // 获取最新区块ID前8bytes作为blockRef
    WalletBlockInfoApi *bestBlockApi = [[WalletBlockInfoApi alloc] init];
    [bestBlockApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        WalletBlockInfoModel *blockModel = finishApi.resultModel;
        
        NSString *blockRef = [[blockModel.id substringFromIndex:2] substringToIndex:16];
        callback ([@"0x" stringByAppendingString:blockRef]);
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        callback(nil);
    }];
}

+ (void)signTransfer:(TransactionParameter *)paramModel keystore:(NSString *)keystore password:(NSString *)password isSend:(BOOL)isSend completionHandler:(void(^)(NSString *txId))completionHandler
{
    WalletDAppHandle *handle = [WalletDAppHandle shareWalletHandle];
    [handle signTransfer:paramModel keystore:keystore password:password isSend:isSend callback:completionHandler];
}

+ (NSString *)getAddressWithKeystore:(NSString *)keystore
{
    if (keystore.length == 0) {
        return @"";
    }
    NSDictionary *dictKeystore = [NSJSONSerialization dictionaryWithJsonString:keystore];
    NSString *address = dictKeystore[@"address"];
    if (![address hasPrefix:@"0x"]) {
        if (address.length > 0) {
            address = [@"0x" stringByAppendingString:address];
            return [WalletUtils getChecksumAddress:address];
            
        } else {
            return @"";
        }
    }else{
        return [WalletUtils getChecksumAddress:address];
    }
}


@end
