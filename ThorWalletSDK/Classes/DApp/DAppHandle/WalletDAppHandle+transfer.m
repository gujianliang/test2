//
//  WalletDAppHandle+transfer.m
//  Wallet
//
//  Created by VeChain on 2019/4/2.
//  Copyright © 2019年 VeChain. All rights reserved.
//

// This code is distributed under the terms and conditions of the MIT license. 

/**
    Copyright (c) 2019 VeChain <support@vechain.com>

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.

**/

#import "YYModel.h"
#import <WebKit/WebKit.h>
#import "WalletDAppHeader.h"
#import "WalletTransactionApi.h"
#import "WalletDAppHandle+transfer.h"

@implementation WalletDAppHandle (transfer)

- (void)transferCallback:(WalletJSCallbackModel *)callbackModel
                  connex:(BOOL)bConnex
{
    
    NSString *kind = callbackModel.params[@"kind"];
    
    if ([kind isEqualToString:@"cert"]) { // Cert type signature
        
        NSString *from = callbackModel.params[@"options"][@"signer"];
        [self certTransfer:callbackModel from:from webView:self.webView];
        return ;
    }
    
    __block NSString *gas      = @"";
    __block NSString *signer   = @"";
    __block NSString *gasPrice = @"";
    
    NSMutableArray *clauseModelList = [[NSMutableArray alloc]init];
    
    [self packgetDatabConnex:bConnex
             clauseModelList:clauseModelList
                         gas:&gas
                    gasPrice:&gasPrice
                      signer:&signer
              callbackParams:callbackModel.params];
    
    if (gas.integerValue == 0) {
        
        gas = [NSString stringWithFormat:@"%d",[WalletDAppGasCalculateHandle getGas:clauseModelList]];
        
        [self simulateMultiAccount:clauseModelList gas:&gas signer:signer callbackModel:callbackModel bConnex:bConnex];
    }else{
        [self callbackClauseList:clauseModelList gas:gas signer:signer bConnex:bConnex callbackModel:callbackModel];
    }
}

- (void)simulateMultiAccount:(NSArray *)clauseModelList gas:(NSString * __autoreleasing *)gas signer:(NSString *)signer callbackModel:(WalletJSCallbackModel *)callbackModel bConnex:(BOOL)bConnex
{
    @weakify(self);
    WalletDappSimulateMultiAccountApi *simulateApi = [[WalletDappSimulateMultiAccountApi alloc]initClause:clauseModelList opts:@{} revision:@""];
    [simulateApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        @strongify(self);
        NSArray *list = (NSArray *)finishApi.resultDict;
        NSString *gasUsed = [list firstObject][@"gasUsed"];
        if (gasUsed.integerValue != 0) {
            //Gasused If it is not 0,  need to add 15000
            NSString *originGas = *gas;
            *gas = [NSString stringWithFormat:@"%ld",originGas.integerValue + gasUsed.integerValue + 15000];
        }
        
        [self callbackClauseList:clauseModelList gas:*gas signer:signer bConnex:bConnex  callbackModel:callbackModel];
        
    }failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        @strongify(self);
        [self paramsErrorCallbackModel:callbackModel webView:self.webView ];
    }];
}

- (void)packgetDatabConnex:(BOOL)bConnex clauseModelList:(NSMutableArray *)clauseModelList gas:(NSString **)gas gasPrice:(NSString **)gasPrice signer:(NSString **)signer callbackParams:(NSDictionary *)callbackParams
{
    if (bConnex) { // Connex
        
        NSArray *clauseList = callbackParams[@"clauses"];
        
        for (NSDictionary *clauseDict in clauseList) {
            
            ClauseModel *clauseModel = [[ClauseModel alloc]init];
            clauseModel.to    = clauseDict[@"to"];
            clauseModel.value = clauseDict[@"value"];
            clauseModel.data  = clauseDict[@"data"];
            
            [clauseModelList addObject:clauseModel];
        }
        
        *gas        = callbackParams[@"options"][@"gas"];
        *gasPrice   = @"120"; //connex js No pass gaspPrice write default
        
        *signer       = callbackParams[@"options"][@"signer"];
        
    }else{ // Web3
        
        ClauseModel *clauseModel = [[ClauseModel alloc]init];
        clauseModel.to    = callbackParams[@"to"];
        clauseModel.value = callbackParams[@"value"];
        clauseModel.data  = callbackParams[@"data"];
        
        *gas        = callbackParams[@"gas"];
        *gasPrice   = callbackParams[@"gasPrice"];
        
        [clauseModelList addObject:clauseModel];
    }
}

- (void)callbackClauseList:(NSArray *)clauseModelList gas:(NSString *)gas signer:(NSString *)signer bConnex:(BOOL)bConnex callbackModel:(WalletJSCallbackModel *)callbackModel
{
    id delegate = [WalletDAppHandle shareWalletHandle].delegate;
    if (delegate) {
        if ([delegate respondsToSelector:@selector(onWillTransfer: signer: gas: completionHandler:)]) {
            @weakify(self)
            [delegate onWillTransfer:clauseModelList signer:signer gas:gas completionHandler:^(NSString * txId,NSString *signer)
             {
                 @strongify(self);
                 [self callbackToWebView:txId
                                  signer:signer
                                 bConnex:bConnex
                                 webView:self.webView
                           callbackModel:callbackModel];
                 
             }];
        }else{
            [WalletTools callbackWithrequestId:callbackModel.requestId
                                       webView:self.webView
                                          data:@""
                                    callbackId:callbackModel.callbackId
                                          code:ERROR_REJECTED];
        }
    }
}

//Call back to dapp webview
- (void)callbackToWebView:(NSString *)txid signer:(NSString *)signer bConnex:(BOOL)bConnex  webView:(WKWebView *)webView callbackModel:(WalletJSCallbackModel *)callbackModel
{
    if (txid.length != 0) {
        id data = nil;
        if (bConnex) {
            
            NSMutableDictionary *dictData = [NSMutableDictionary dictionary];
            [dictData setValueIfNotNil:txid forKey:@"txid"];
            [dictData setValueIfNotNil:signer.lowercaseString forKey:@"signer"];
            
            data = dictData;
        }else{
            data = txid;
        }
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:data
                                callbackId:callbackModel.callbackId
                                      code:OK];
    }else{
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackModel.callbackId
                                      code:ERROR_NETWORK];
    }
}

- (void)paramsErrorCallbackModel:(WalletJSCallbackModel *)callbackModel webView:(WKWebView *)webView
{
    [WalletTools callbackWithrequestId:callbackModel.requestId webView:webView data:@"" callbackId:callbackModel.callbackId code:ERROR_NETWORK];
}

//Initiate a transaction
- (void)signTransfer:(WalletTransactionParameter *)paramModel
            keystore:(NSString *)keystore
            password:(NSString *)password
              isSend:(BOOL)isSend
            callback:(void(^)(NSString *txId))callback
{
    self.keystore = keystore;
    
    self.isSend = isSend;
    
    Transaction *transaction = [[Transaction alloc] init];
    
    NSString *decimalNoce = [BigNumber bigNumberWithHexString:paramModel.nonce].decimalString;
    transaction.nonce = decimalNoce.integerValue;
    
    transaction.Expiration = paramModel.expiration.integerValue;
    transaction.gasPrice  = [BigNumber bigNumberWithInteger:paramModel.gasPriceCoef.integerValue];
    
    if (paramModel.dependsOn.length == 0 || paramModel.dependsOn == nil) {
        transaction.dependsOn = [NSData data];
    }else{
        transaction.dependsOn = [SecureData hexStringToData:paramModel.dependsOn];
    }
    
    transaction.gasLimit = [BigNumber bigNumberWithInteger:paramModel.gas.integerValue];
    
    transaction.ChainTag = [BigNumber bigNumberWithHexString:paramModel.chainTag];
    
    transaction.BlockRef = [BigNumber bigNumberWithHexString:paramModel.blockReference];
    
    [self packageClausesData:transaction paramModel:paramModel];
    
    [self sign:transaction paramModel:paramModel keystore:keystore password:password callback:callback];
}

//Organize the clause data
- (void)packageClausesData:(Transaction *)transaction
                paramModel:(WalletTransactionParameter *)paramModel
{
    NSMutableArray *clauseList = [NSMutableArray array];
    
    for (ClauseModel *model in paramModel.clauses) {
        
        NSMutableArray *clauseSingle = [NSMutableArray array];
        NSData *to = nil;
        NSData *value = nil;
        NSData *data = nil;
        
        BigNumber *subValue;
        CGFloat amountF = 0.0;
        if ([WalletTools checkDecimalStr:model.value]) {
            subValue = [BigNumber bigNumberWithDecimalString:model.value];
            amountF = model.value.floatValue;
        }else{
            subValue = [BigNumber bigNumberWithHexString:model.value];
            amountF = subValue.decimalString.floatValue;
        }
        
        if (amountF == 0.0
            && [subValue lessThanEqualTo:[BigNumber constantZero]]) {
            value = [NSData data];
        } else {
            value = subValue.data;
        }
        
        if (model.to.length ==  0) {
            to = [NSData data];
        }else{
            to = [SecureData hexStringToData:model.to];
        }
        
        if (model.data.length == 0) {
            data = [NSData data];
            
        }else{
            data = [SecureData hexStringToData:model.data];
        }
        [clauseSingle addObject:to];
        [clauseSingle addObject:value];
        [clauseSingle addObject:data];

        [clauseList addObject:clauseSingle];
    }
    
    transaction.Clauses = clauseList;
}

- (void)sign:(Transaction *)transaction
  paramModel:(WalletTransactionParameter *)paramModel
    keystore:(NSString *)keystore
    password:(NSString *)password
callback:(void(^)(NSString *txId))callback

{
    // Try user password to decrypt keystore
    @weakify(self)

    [Account decryptSecretStorageJSON:keystore
                             password:password
                             callback:^(Account *account, NSError *NSError)
    {
         @strongify(self)
         if (!account) {
             
             callback(@"");
             NSLog(@"wrong password");
             return;
         }

        //Sign with private key
         [account sign:transaction];
        
        //Signature fails if v is 2 or 3
         if (transaction.signature.v == 2
             || transaction.signature.v == 3) {
             
             [self showTransactionFail:callback];

         }else{

             [self account:account transaction:transaction callback:callback];
         }
    }];
}

- (void)account:(Account *)account transaction:(Transaction *)transaction callback:(void(^)(NSString *txId))callback

{
    self.txId = [transaction txID:account];
    NSString *raw = [SecureData dataToHexString: [transaction serialize]];
    
    if (self.isSend) {
        [self sendRaw:raw callback:callback];
        
    }else{
        callback(raw);
    }
}

- (void)sendRaw:(NSString *)raw callback:(void(^)(NSString *txId))callback
{
    // Send transaction
    @weakify(self)
    WalletTransactionApi *transationApi = [[WalletTransactionApi alloc]initWithRaw:raw];
    [transationApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        @strongify(self);
        
        self.txId = finishApi.resultDict[@"id"];
        callback(self.txId);
    } failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        @strongify(self);
        [self showTransactionFail:callback];
    }];
}

- (void)showTransactionFail:(void(^)(NSString *txId ))callback
{
    callback(@"");
}


@end
