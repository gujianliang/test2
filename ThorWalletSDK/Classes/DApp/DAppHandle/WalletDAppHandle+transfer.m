//
//  WalletDAppHandle+transfer.m
//  Wallet
//
//  Created by vechaindev on 2019/4/2.
//  Copyright © 2019年 VeChain. All rights reserved.
//

// This code is distributed under the terms and conditions of the MIT license. 

/**
    Copyright (c) 2019 vechaindev <support@vechain.com>

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


#import "WalletDAppHandle+transfer.h"
#import <WebKit/WebKit.h>
#import "YYModel.h"
#import "WalletDAppHeader.h"
#import "WalletTransactionApi.h"

@implementation WalletDAppHandle (transfer)


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

            self.txId = [transaction txID:account];
             NSString *raw = [SecureData dataToHexString: [transaction serialize]];
             
             if (self.isSend) {
                 [self sendRaw:raw callback:callback];

             }else{
                 callback(raw);
             }
         }
    }];
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

- (void)signCertFrom:(NSString *)from
             account:(Account *)account
             content:(NSString *)content
           requestId:(NSString *)requestId
             webView:(WKWebView *)webView
          callbackId:(NSString *)callbackId
               param:(NSDictionary *)param
{
    
    NSString *packSign = [WalletTools packageCertParam:param];
    
    NSData *totalData = [packSign dataUsingEncoding:NSUTF8StringEncoding];
    SecureData *data = [SecureData BLAKE2B:totalData];
    Signature *signature = [account signDigest:data.data];
    
    SecureData *vData = [[SecureData alloc]init];
    [vData appendByte:signature.v];
    
    NSString *s = [SecureData dataToHexString:signature.s];
    NSString *r = [SecureData dataToHexString:signature.r];
    
    NSString *hashStr = [NSString stringWithFormat:@"0x%@%@%@",
                         [r substringFromIndex:2],
                         [s substringFromIndex:2],
                         [vData.hexString substringFromIndex:2]];
    
    //Signature fails if v is 2 or 3
    if (signature.v == 2
        || signature.v == 3) {
        
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_NETWORK];
    }else{
        NSMutableDictionary *dictSub = [NSMutableDictionary dictionary];
        
        [dictSub setValueIfNotNil:param[@"domain"]      forKey:@"domain"];
        [dictSub setValueIfNotNil:from.lowercaseString  forKey:@"signer"];
        [dictSub setValueIfNotNil:param[@"timestamp"]   forKey:@"timestamp"];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:dictSub forKey:@"annex"];
        [dict setObject:hashStr forKey:@"signature"];
        
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:dict
                                callbackId:callbackId
                                      code:OK];
    }
}

@end
