//
//  WalletUtils.m
//
//  Created by VeChain on 2018/8/12.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletUtils.h"
#import "WalletDAppHandle.h"
#import "WalletSignatureView.h"
#import "WalletTools.h"
#import "WalletDAppHead.h"
#import "WalletSingletonHandle.h"
#import "WalletMBProgressShower.h"
#import "WalletGetDecimalsApi.h"
#import "WalletGetSymbolApi.h"
#import "WalletSignParamModel.h"
#import "SecureData.h"
#import "Account.h"

@implementation WalletUtils


+ (void)creatWalletWithPassword:(NSString *)password
                       callback:(void(^)(WalletAccountModel *accountModel,NSError *error))callback
{
    __block Account *account = [Account randomMnemonicAccount];
    
    [account encryptSecretStorageJSON:password callback:^(NSString *json) {
        
         account.keystore = json;
        if (json.length == 0) {
            if (callback) {
                NSString *domain = @"com.wallet.ErrorDomain";
                NSString *desc = @"Generate keystore fail";
                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
                
                NSError *error = [NSError errorWithDomain:domain
                                                     code:-101
                                                 userInfo:userInfo];
                
                callback(nil,error);
            }
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

+ (void)creatWalletWithMnemonicWords:(NSArray *)mnemonicWords
                            password:(NSString *)password
                            callback:(void(^)(WalletAccountModel *account,NSError *error))callback
{
    __block Account *account = [Account accountWithMnemonicPhrase:[mnemonicWords componentsJoinedByString:@" "]];
    
    [account encryptSecretStorageJSON:password callback:^(NSString *json) {
        
        account.keystore = json;
        if (json.length == 0) {
            if (callback) {
                NSString *domain = @"com.wallet.ErrorDomain";
                NSString *desc = @"Generate keystore fail";
                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
                
                NSError *error = [NSError errorWithDomain:domain
                                                     code:-101
                                                 userInfo:userInfo];
                
                callback(nil,error);
            }
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

+ (BOOL)isValidMnemonicWords:(NSArray*)mnemonicWords;
{
    return [Account isValidMnemonicPhrase:[mnemonicWords componentsJoinedByString:@" "]];
}

+ (void)decryptKeystore:(NSString*)keystoreJson
               password:(NSString*)password
               callback:(void(^)(WalletAccountModel *account,NSError *error))callback
{
    [Account decryptSecretStorageJSON:keystoreJson password:password callback:^(Account *account, NSError *NSError) {
        if (NSError == nil) {
            WalletAccountModel *accountModel = [[WalletAccountModel alloc]init];
            accountModel.keystore = keystoreJson;
            accountModel.privatekey = [SecureData dataToHexString:account.privateKey];
            accountModel.address = account.address.checksumAddress;
            accountModel.words = [account.mnemonicPhrase componentsSeparatedByString:@" "];
            
            callback(accountModel,nil);
        }else{
            callback(nil,NSError);
        }
    }];
}

+ (NSString *)recoverAddressFromMessage:(NSData*)message
                signatureData:(NSData *)signatureData
{
    Signature *signature = [Signature signatureWithData:signatureData];
    
    return [Account verifyMessage:message signature:signature].checksumAddress.lowercaseString;
}

#warning message hashed ,还是没有hash 的
+ (void)sign:(NSData*)message
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
                 callback([SecureData hexStringToData:hashStr],nil);
             }
         }else{
             if (callback) {
                 callback(nil,error);
             }
         }
     }];
}

+ (void)encryptKeystore:(NSString*)password
                account:(WalletAccountModel *)account
               callback:(void (^)(NSString *keystoreJson))callback
{
    Account *ethAccount = [Account accountWithMnemonicPhrase:[account.words componentsJoinedByString:@" "]];
    [ethAccount encryptSecretStorageJSON:password
                             callback:^(NSString *json)
    {
         if (json.length > 0) {
             if (callback) {
                 callback(json);
             }
         }
    }];
}

+ (void)initDappWebViewWithKeystore:(NSMutableArray *)walletList
{
    [[WalletDAppHandle shareWalletHandle]initWithWalletDict:walletList];
}

+ (void)webView:(WKWebView *)webView defaultText:(NSString *)defaultText completionHandler:(void (^)(NSString * result))completionHandler
{
    NSLog(@"defaultText == %@",defaultText);
    
    WalletDAppHandle *dappHandle = [WalletDAppHandle shareWalletHandle];
    [dappHandle webView:webView defaultText:defaultText completionHandler:completionHandler];
}

+ (void)injectJSWithWebView:(WKWebView *)webview
{
    WalletDAppHandle *dappHandle = [WalletDAppHandle shareWalletHandle];
    [dappHandle injectJS:webview];
}

+ (void)sendWithKeystore:(NSString *)keystoreJson parameter:(TransactionParameter *)parameter callback:(void(^)(NSString *txId,NSString *signer))callback
{
    NSString *toAddress = @"";
    NSString *tokenAddress = @"";
    NSString *amount = @"";
    NSString *clauseStr = @"";
    JSTransferType transferType = JSVETTransferType;
    
    [self transactionCheckParams:&keystoreJson parameter:parameter toAddress:&toAddress amount:&amount transferType:&transferType tokenAddress:&tokenAddress clauseStr:&clauseStr];
    
    
    NSMutableArray *clauseList = [NSMutableArray array];
    if (parameter.to.length == 0) {
        [clauseList addObject:[NSData data]];
    }else{
        [clauseList addObject: [SecureData secureDataWithHexString:parameter.to].data];
    }
    
    if (parameter.value.length == 0) {
        [clauseList addObject:[NSData data]];
    }else{
        if (transferType == JSTokenTransferType) {
            [clauseList addObject:[NSData data]];

        }else{
            [clauseList addObject:[BigNumber bigNumberWithHexString:parameter.value].data];
        }

    }
    
    if (parameter.data.length == 0) {
        [clauseList addObject:[NSData data]];
    }else{
        [clauseList addObject:[SecureData secureDataWithHexString:parameter.data].data];
    }
    
    WalletSignParamModel *signParamModel = [[WalletSignParamModel alloc]init];
    
    signParamModel.toAddress    = toAddress;
    signParamModel.fromAddress  = parameter.from;
    signParamModel.gasPriceCoef = [BigNumber bigNumberWithHexString:DefaultGasPriceCoef];;
    signParamModel.gas          = parameter.gas;
    signParamModel.amount       = parameter.value;
    signParamModel.clauseData   = parameter.data ;
    signParamModel.tokenAddress = tokenAddress ;
    signParamModel.keystore     = keystoreJson;
    signParamModel.clauseList   = [NSArray arrayWithObject:clauseList];
    
    WalletSignatureView *signatureView = [[WalletSignatureView alloc] initWithFrame:[WalletTools getCurrentVC].view.bounds];
    signatureView.transferType = transferType;
    
    [signatureView updateViewParamModel:signParamModel];
    
    [[WalletTools getCurrentVC].navigationController.view addSubview:signatureView];
    
    signatureView.transferBlock = ^(NSString * _Nonnull txid) {
        
        if (callback) {
            callback(txid,parameter.from);
        }
    };
}

+ (void)transactionCheckParams:(NSString **)keystore  parameter:(TransactionParameter *)parameter toAddress:(NSString **)toAddress amount:(NSString **)amount transferType:(JSTransferType *)transferType tokenAddress:(NSString **)tokenAddress clauseStr:(NSString **)clauseStr
{
    // check keystore form
    if (![WalletTools checkKeystore:*keystore]) {
        
        [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view
                                      Text:ERROR_REQUEST_PARAMS_MSG During:1];
        return;
    }
    NSDictionary *dictKeystore = [NSJSONSerialization dictionaryWithJsonString:*keystore];
    NSString *keystoreFrom = dictKeystore[@"address"];
    
    if ([keystoreFrom.lowercaseString isEqualToString:(parameter.from).lowercaseString]) {
        [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view
                                      Text:ERROR_REQUEST_PARAMS_MSG During:1];
        return;
    }
    
    if ((parameter.data).length == 0) { //vet 转账
        *toAddress = parameter.to;
        *amount = parameter.value;
        *transferType = JSVETTransferType;
        
        if (![WalletTools errorAddressAlert:*toAddress]
            || ![WalletTools errorAddressAlert:parameter.from]
            || ((*amount).length > 0 && ![WalletTools checkHEXStr:*amount])) { // vet 可以转账0
            
            [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view
                                          Text:ERROR_REQUEST_PARAMS_MSG During:1];
            return ;
        }
        
    }else{
        if ([parameter.data hasPrefix:TransferMethodId]) { //token transfer
            *transferType = JSTokenTransferType;
            *tokenAddress = parameter.to;
            *clauseStr = parameter.data;
            
            NSString *clauseTemp =  [*clauseStr stringByReplacingOccurrencesOfString:@"0xa9059cbb000000000000000000000000" withString:@""];
            *toAddress = [@"0x" stringByAppendingString:[clauseTemp substringToIndex:40]];
            
            NSString *clauseStrTemp = [*clauseStr stringByReplacingOccurrencesOfString:TransferMethodId withString:@""];
            NSString *clauseValue = @"";
            
            if (clauseStrTemp.length >= 128) {
                clauseValue = [clauseStrTemp substringWithRange:NSMakeRange(64, 64)];
            }
            
            parameter.value = [NSString stringWithFormat:@"0x%@",clauseValue];
            
            if (![WalletTools errorAddressAlert:parameter.from]
                || ![WalletTools errorAddressAlert:*tokenAddress]
                || ![WalletTools checkHEXStr:parameter.value]
                || ![WalletTools checkHEXStr:*clauseStr]) { //
                
                [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view
                                              Text:ERROR_REQUEST_PARAMS_MSG During:1];
                return ;
            }
            
        }else{ //contract signature
            *transferType = JSContranctTransferType;
            *amount = parameter.value;
            *clauseStr = parameter.data;
            *toAddress = parameter.to; //token address
            
            // toAddress equal to token addres,contract signature can be 0
            if (![WalletTools errorAddressAlert:parameter.from]
                || ![WalletTools errorAddressAlert:parameter.to]
                || ![WalletTools checkHEXStr:*clauseStr]) { // vet 可以转账0
                
                [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view
                                              Text:ERROR_REQUEST_PARAMS_MSG During:1];
                return ;
            }
            
            if ((*amount).length > 0 && ![WalletTools checkHEXStr:*amount]) {
                [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view
                                              Text:ERROR_REQUEST_PARAMS_MSG During:1];
                return ;
            }
        }
    }
}

+ (BOOL)isValidKeystore:(NSString *)keystoreJson
{
   return [WalletTools checkKeystore:keystoreJson];
}

+ (NSString *)getChecksumAddress:(NSString *)address
{
   return [WalletTools checksumAddress:address];
}

+ (void)setNode:(NSString *)nodelUrl
{
    [WalletUserDefaultManager setBlockUrl:nodelUrl];
}

+ (NSString *)getNode
{
    return [WalletUserDefaultManager getBlockUrl];
}

@end
