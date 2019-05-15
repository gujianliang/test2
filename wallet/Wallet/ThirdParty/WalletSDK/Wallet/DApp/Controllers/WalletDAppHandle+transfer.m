//
//  WalletDAppHandle+transfer.m
//  WalletSDK
//
//  Created by Tom on 2019/4/2.
//  Copyright © 2019年 Ethers. All rights reserved.
//

#import "WalletDAppHandle+transfer.h"
#import <WebKit/WebKit.h>
#import "YYModel.h"
#import "WalletDAppHead.h"
#import "WalletTransactionApi.h"
#import "WalletMBProgressShower.h"

@implementation WalletDAppHandle (transfer)


- (void)signTransfer:(TransactionParameter *)paramModel
            keystore:(NSString *)keystore
            password:(NSString *)password
              isSend:(BOOL)isSend
            callback:(void(^)(NSString *txId))callback
{
    // 显示Loading
    self.keystore = keystore;
    
    self.isSend = isSend;
    
    Transaction *transaction = [[Transaction alloc] init];
    
    NSString *decimalNoce = [BigNumber bigNumberWithHexString:paramModel.nonce].decimalString;
    transaction.nonce = decimalNoce.integerValue;
    
    transaction.Expiration = paramModel.expiration.integerValue;
    transaction.gasPrice  = [BigNumber bigNumberWithInteger:paramModel.gasPriceCoef.integerValue];
    
    if (paramModel.dependsOn.length == 0) {
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

- (void)packageClausesData:(Transaction *)transaction
                paramModel:(TransactionParameter *)paramModel
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
  paramModel:(TransactionParameter *)paramModel
    keystore:(NSString *)keystore
    password:(NSString *)password
callback:(void(^)(NSString *txId))callback

{
    // 尝试用户密码解密keystore
    @weakify(self)

    [Account decryptSecretStorageJSON:keystore
                             password:password
                             callback:^(Account *account, NSError *NSError)
    {
         @strongify(self)
         if (!account) {
             
             [WalletMBProgressShower showTextIn:[WalletTools getCurrentVC].view
                                           Text:VCNSLocalizedBundleString(@"transfer_wallet_password_error", nil) During:1];
             
             return;
         }

         [account sign:transaction];
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
    // 发送交易
    @weakify(self)
    WalletTransactionApi *transationApi1 = [[WalletTransactionApi alloc]initWithRaw:raw];
    [transationApi1 loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        @strongify(self);
        
        self.txId = finishApi.resultDict[@"id"];
        callback(self.txId);
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        @strongify(self);
        [self showTransactionFail:callback];
    }];
}

- (void)showTransactionFail:(void(^)(NSString *txId ))callback
{
#warning 处理方式
    callback(self.txId);
}


- (void)signCertFrom:(NSString *)from
             account:(Account *)account
             content:(NSString *)content
           requestId:(NSString *)requestId
             webView:(WKWebView *)webView
          callbackId:(NSString *)callbackId
               param:(NSDictionary *)param
{
    
    NSString *packSign = [WalletTools packCertParam:param];
    
    NSData *totalData1 = [packSign dataUsingEncoding:NSUTF8StringEncoding];
    SecureData *data = [SecureData BLAKE2B:totalData1];
    Signature *signature = [account signDigest:data.data];
    
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
        // fail
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
