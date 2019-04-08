//
//  WalletDAppHandle+transfer.m
//  WalletSDK
//
//  Created by 曾新 on 2019/4/2.
//  Copyright © 2019年 Ethers. All rights reserved.
//

#import "WalletDAppHandle+transfer.h"
#import <WebKit/WebKit.h>
#import "NSJSONSerialization+NilDataParameter.h"
#import "YYModel.h"
#import "WalletBlockInfoApi.h"
#import "WalletVETBalanceApi.h"
#import "WalletGetSymbolApi.h"
#import "WalletGetDecimalsApi.h"
#import "WalletGenesisBlockInfoApi.h"
#import "WalletAccountCodeApi.h"
#import "WalletBlockApi.h"
#import "WalletTransantionsReceiptApi.h"
#import "WalletDAppHead.h"
#import "WalletDAppHandle+web3JS.h"
#import "WalletDAppHandle+connexJS.h"
#import "NSJSONSerialization+NilDataParameter.h"
#import "WalletDAppPeersApi.h"
#import "WalletDAppTransferDetailApi.h"
#import "WalletJSCallbackModel.h"
#import "WalletGetBaseGasPriceApi.h"
#import "SocketRocketUtility.h"
#import "WalletTransactionApi.h"

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

- (void)packageClausesData:(Transaction *)transaction paramModel:(TransactionParameter *)paramModel
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
             [WalletAlertShower showAlert:nil
                                      msg:VCNSLocalizedBundleString(@"transfer_wallet_password_error", nil)
                                    inCtl:[WalletTools getCurrentVC]
                                    items:@[VCNSLocalizedBundleString(@"重试", nil)]
                               clickBlock:^(NSInteger index)
              {

              }];
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
    NSLog(@"raw ==%@",raw);
    // 发送交易
    @weakify(self)
    WalletTransactionApi *transationApi1 = [[WalletTransactionApi alloc]initWithRaw:raw];
    [transationApi1 loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        @strongify(self);
        
        self.txId = finishApi.resultDict[@"id"];
        callback(self.txId);
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        
        [self showTransactionFail:callback];
    }];
}

- (void)showTransactionFail:(void(^)(NSString *txId ))callback
{    
    callback(self.txId);
}


@end
