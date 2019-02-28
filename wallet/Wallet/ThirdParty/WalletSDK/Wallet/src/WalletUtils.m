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

@implementation WalletUtils
{
}

+ (void)createWalletWithPassword:(NSString *)password
                       callback:(void(^)(Account *account))block
{
    __block Account *account = [Account randomMnemonicAccount];
    
    [account encryptSecretStorageJSON:password callback:^(NSString *json) {
        
         account.keystore = json;
        if (block) {
            block(account);
        }
    }];
}

+ (void)creatWalletWithMnemonic:(NSString *)mnemonic
                      password:(NSString *)password
                      callback:(void(^)(Account *account))block
{
    __block Account *account = [Account accountWithMnemonicPhrase:mnemonic];
    
    [account encryptSecretStorageJSON:password callback:^(NSString *json) {
        
        account.keystore = json;
        if (block) {
            block(account);
        }
    }];
}

+ (BOOL)isValidMnemonicPhrase:(NSString*)phrase
{
    return [Account isValidMnemonicPhrase:phrase];
}

+ (void)decryptSecretStorageJSON:(NSString*)json
                        password:(NSString*)password
                        callback:(void (^)(Account *account, NSError *NSError))callback
{
    [Account decryptSecretStorageJSON:json password:password callback:callback];
}

+ (Address*)recoverAddressFromMessage:(NSData*)message
                signature:(Signature*)signature
{
   return [Account verifyMessage:message signature:signature];
}

+ (void)sign:(NSData*)message
    keystore:(NSString*)json
    password:(NSString*)password
       block:(void (^)(Signature *signature))block
{
    [Account decryptSecretStorageJSON:json
                             password:password
                             callback:^(Account *account, NSError *NSError)
     {
#warning 签出 1或者 0,fail alert
         // 签名交易
         if (NSError == nil) {
            SecureData *data = [SecureData BLAKE2B:message];
            Signature *signature = [account signDigest:data.data];
             if (block) {
                 block(signature);
             }
         }
     }];
}

+ (void)encryptSecretStorageJSON:(NSString*)password
                         account:(Account *)account
                        callback:(void (^)(NSString *))callback
{
    [account encryptSecretStorageJSON:password
                             callback:^(NSString *json)
    {
         if (json.length > 0) {
             if (callback) {
                 callback(json);
             }
         }
    }];
}

+ (void)setCurrentWallet:(NSString *)address
{
    [[WalletSingletonHandle shareWalletHandle] setCurrentModel:address];
}

+ (void)initWithWalletDict:(NSMutableArray *)walletList
{
    [[WalletDAppHandle shareWalletHandle]initWithWalletDict:walletList];
}

+ (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    NSLog(@"defaultText == %@",defaultText);
    
    WalletDAppHandle *dappHandle = [WalletDAppHandle shareWalletHandle];
    [dappHandle webView:webView runJavaScriptTextInputPanelWithPrompt:prompt defaultText:defaultText initiatedByFrame:frame completionHandler:completionHandler];
}

+ (void)injectJS:(WKWebView *)webview
{
    WalletDAppHandle *dappHandle = [WalletDAppHandle shareWalletHandle];
    [dappHandle injectJS:webview];
}

+ (void)transactionWithKeystore:(NSString *)keystore parameter:(TransactionParameter *)parameter block:(void(^)(NSString *txId,NSString *signer))block
{
    NSString *toAddress = @"";
    NSString *tokenAddress = @"";
    NSString *amount = @"";
    NSString *clauseStr = @"";
    JSTransferType transferType = JSVETTransferType;
    
    // check keystore form
    if (![WalletTools checkKeystore:keystore]) {
        
        [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view
                                      Text:ERROR_REQUEST_PARAMS_MSG During:1];
        return;
    }
    NSDictionary *dictKeystore = [NSJSONSerialization dictionaryWithJsonString:keystore];
    NSString *keystoreFrom = dictKeystore[@"address"];
    
    if ([keystoreFrom.lowercaseString isEqualToString:parameter.from.lowercaseString]) {
        [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view
                                      Text:ERROR_REQUEST_PARAMS_MSG During:1];
        return;
    }
    
    if (parameter.data.length == 0) { //vet 转账
        toAddress = parameter.to;
        amount = parameter.value;
        transferType = JSVETTransferType;
        
        if (![WalletTools errorAddressAlert:toAddress]
            || ![WalletTools errorAddressAlert:parameter.from]
            || (amount.length > 0 && ![WalletTools checkHEXStr:amount])) { // vet 可以转账0
            
            [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view
                                          Text:ERROR_REQUEST_PARAMS_MSG During:1];
            return ;
        }
        
    }else{
        if ([parameter.data hasPrefix:TransferMethodId]) { //token transfer
            transferType = JSTokenTransferType;
            tokenAddress = parameter.to;
            clauseStr = parameter.data;
            
            NSString *clauseTemp =  [clauseStr stringByReplacingOccurrencesOfString:@"0xa9059cbb000000000000000000000000" withString:@""];
            toAddress = [@"0x" stringByAppendingString:[clauseTemp substringToIndex:40]];
            
            NSString *clauseStrTemp = [clauseStr stringByReplacingOccurrencesOfString:TransferMethodId withString:@""];
            NSString *clauseValue = @"";
            
            if (clauseStrTemp.length >= 128) {
                clauseValue = [clauseStrTemp substringWithRange:NSMakeRange(64, 64)];
            }
            
            parameter.value = [NSString stringWithFormat:@"0x%@",clauseValue];
            
            if (![WalletTools errorAddressAlert:parameter.from]
                || ![WalletTools errorAddressAlert:tokenAddress]
                || ![WalletTools checkHEXStr:parameter.value]
                || ![WalletTools checkHEXStr:clauseStr]) { //
                
                [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view
                                              Text:ERROR_REQUEST_PARAMS_MSG During:1];
                return ;
            }
            
        }else{ //contract signature
            transferType = JSContranctTransferType;
            amount = parameter.value;
            clauseStr = parameter.data;
            toAddress = parameter.to; //token address
            
            // toAddress equal to token addres,contract signature can be 0
            if (![WalletTools errorAddressAlert:parameter.from]
                || ![WalletTools errorAddressAlert:parameter.to]
                || ![WalletTools checkHEXStr:clauseStr]) { // vet 可以转账0
                
                [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view
                                              Text:ERROR_REQUEST_PARAMS_MSG During:1];
                return ;
            }
            
            if (amount.length > 0 && ![WalletTools checkHEXStr:amount]) {
                [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view
                                              Text:ERROR_REQUEST_PARAMS_MSG During:1];
                return ;
            }
        }
    }
    
    
    NSMutableArray *clauseList = [NSMutableArray array];
    if (parameter.to.length == 0) {
        [clauseList addObject:[NSData data]];
    }else{
        [clauseList addObject: [parameter.to dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (parameter.value.length == 0) {
        [clauseList addObject:[NSData data]];
    }else{
        [clauseList addObject:[parameter.value dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (parameter.data.length == 0) {
        [clauseList addObject:[NSData data]];
    }else{
        [clauseList addObject:[parameter.data dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    WalletSignParamModel *signParamModel = [[WalletSignParamModel alloc]init];
    
    signParamModel.toAddress    = toAddress;
    signParamModel.fromAddress  = parameter.from;
    signParamModel.gasPriceCoef = [BigNumber bigNumberWithHexString:DefaultGasPriceCoef];;
    signParamModel.gas          = parameter.gas;
    signParamModel.amount       = parameter.value;
    signParamModel.clauseData   = parameter.data ;
    signParamModel.tokenAddress = tokenAddress ;
    signParamModel.keystore     = keystore;
    signParamModel.clauseList   = clauseList;
    
    WalletSignatureView *signatureView = [[WalletSignatureView alloc] initWithFrame:[WalletTools getCurrentVC].view.bounds];
    signatureView.transferType = transferType;
    
    [signatureView updateViewParamModel:signParamModel];
    
    [[WalletTools getCurrentVC].navigationController.view addSubview:signatureView];
    
    signatureView.transferBlock = ^(NSString * _Nonnull txid) {
        
        if (block) {
            block(txid,parameter.from);
        }
    };
}


@end
