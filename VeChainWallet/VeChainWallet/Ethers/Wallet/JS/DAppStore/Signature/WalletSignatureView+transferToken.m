//
//  WalletSignatureView+transferToken.m
//  VeWallet
//
//  Created by 曾新 on 2019/1/12.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletSignatureView+transferToken.h"
#import "WalletGenesisBlockInfoApi.h"
#import "WalletBlockInfoApi.h"
//#import "WalletSqlDataEngine.h"
#import "WalletTransactionApi.h"
//#import "WalletTradeDetailVC.h"


@implementation WalletSignatureView (transferToken)

- (void)signTransfer:(void(^)(NSString *txid))transferBlock;
{
    // 显示Loading
//    [FFBMSMBProgressShower showCircleIn:self];
    
    Transaction *transaction = [[Transaction alloc] init];
    
    // 生成随机 nonce
    SecureData* randomData = [SecureData secureDataWithLength:8];
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
//        [FFBMSAlertShower showAlert:nil
//                                msg:NSLocalizedString(@"transfer_wallet_send_fail", nil)
//                              inCtl:[FFBMSTools getCurrentVC]
//                              items:@[NSLocalizedString(@"dialog_yes", nil)]
//                         clickBlock:^(NSInteger index) {
//                         }];
    }
    transaction.nonce = [[[BigNumber bigNumberWithData:randomData.data] mod:[BigNumber bigNumberWithInteger:NSIntegerMax]] integerValue];
    
    transaction.Expiration = 720;
    transaction.gasPrice = self.gasPriceCoef;
    
    if (self.transferType == JSContranctTransferType){ //合约签名
        transaction.gasLimit = [BigNumber bigNumberWithInteger:self.gas.integerValue];
    }else if (![self.currentCoinModel.coinName isEqualToString:@"VET"]) { // token 签名
        transaction.gasLimit = [BigNumber bigNumberWithDecimalString:self.currentCoinModel.transferGas];
    }else{ // vet 签名
        if (self.currentCoinModel.transferGas.length > 0) {
            transaction.gasLimit = [BigNumber bigNumberWithDecimalString:self.currentCoinModel.transferGas];
        }else{
            transaction.gasLimit = [BigNumber bigNumberWithDecimalString:@"21000"];
        }
    }
    
    // 拉创世区块id做chainTag
//    @weakify(self)
    WalletGenesisBlockInfoApi *genesisBlock = [WalletGenesisBlockInfoApi new];
    [genesisBlock loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        WalletBlockInfoModel *genesisblockModel = finishApi.resultModel;
        NSString *blockID = genesisblockModel.id;
        NSString *chainTag = [NSString stringWithFormat:@"0x%@", [blockID substringFromIndex:blockID.length-2]];
        transaction.ChainTag = [BigNumber bigNumberWithHexString:chainTag];
        
        // 获取最新区块ID前8bytes作为blockRef
        WalletBlockInfoApi *bestBlockApi = [[WalletBlockInfoApi alloc] init];
//        @strongify(self)
        [bestBlockApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
//            @strongify(self)
            WalletBlockInfoModel *blockModel = finishApi.resultModel;
            
            NSString *blockRef = [[blockModel.id substringFromIndex:2] substringToIndex:16];
            transaction.BlockRef = [BigNumber bigNumberWithHexString:[NSString stringWithFormat:@"0x%@",blockRef]];
            BigNumber *subValue;
            if ([self.currentCoinModel.coinName isEqualToString:@"VET"]) {
                //ven 转账  data 设置空
                subValue = [Payment parseEther:self.amount];
                if ([self.amount floatValue] == 0.0
                    && [subValue lessThanEqualTo:[BigNumber constantZero]]) {
                    NSData *toData = [SecureData hexStringToData:self.toAddress];
                    transaction.Clauses = @[@[toData,[NSData data],[NSData data]]];
                } else {
                    NSData *toData = [SecureData hexStringToData:self.toAddress];
                    transaction.Clauses = @[@[toData,subValue.data,[NSData data]]];
                }
                
            } else if(self.currentCoinModel) {
                //token 转账 value 设置0，data 设置见文档
                subValue = [Payment parseToken:self.amount dicimals:self.currentCoinModel.decimals];

                SecureData *tokenAddress = [SecureData secureDataWithHexString:self.currentCoinModel.address];
                transaction.Clauses = @[@[tokenAddress.data,[NSData data],self.clouseData]];
            }else{ // 合约转账
                CGFloat amountF = self.amount.floatValue;
                if (amountF == 0) {
                    if (self.tokenAddress.length == 0) {
                        transaction.Clauses = @[@[[NSData data],[NSData data], self.clouseData]];
                    }else{
                        transaction.Clauses = @[@[[SecureData hexStringToData:self.tokenAddress],[NSData data], self.clouseData]];
                    }
                    
                } else {
                    
                     if (self.tokenAddress.length == 0) {
                         BigNumber *subValue = [Payment parseEther:self.amount];
                         transaction.Clauses = @[@[[NSData data],subValue.data, self.clouseData]];
                     }else{
                         BigNumber *subValue = [Payment parseEther:self.amount];
                         transaction.Clauses = @[@[[SecureData hexStringToData:self.tokenAddress],subValue.data, self.clouseData]];
                     }
                }
            }
            // 尝试用户密码解密keystore
            NSString *keystore = @"";
            
//            [[WalletSqlDataEngine sharedInstance] getKeystore:self.fromAddress];
            [Account decryptSecretStorageJSON:keystore password:self.pwTextField.text callback:^(Account *account, NSError *NSError) {
//                @strongify(self)
                if (!account) {
//                    [FFBMSMBProgressShower hide:self];
//                    [FFBMSAlertShower showAlert:nil
//                                            msg:NSLocalizedString(@"transfer_wallet_password_error", nil)
//                                          inCtl:[FFBMSTools getCurrentVC]
//                                          items:@[NSLocalizedString(@"重试", nil)]
//                                     clickBlock:^(NSInteger index) {
//                                     }];
                   
                    
                    return;
                    
                }else {
                    
                }
                
                [account sign:transaction];
                
                NSString *raw1 = [SecureData dataToHexString: [transaction serialize]];
                // 发送交易
                WalletTransactionApi *transationApi1 = [[WalletTransactionApi alloc]initWithRaw:raw1];
                [transationApi1 loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
//                    @strongify(self);
//
//                    [FFBMSMBProgressShower hide:self];
//
//                    NC_POST_NAME_NO_OBJECT(kTransactionSuccess);
                    self.txid = finishApi.resultDict[@"id"];
                    
                    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
                    [self timerCountBlock];
//
//                    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
//                    [paramDict setValueIfNotNil:self.enter_path forKey:@"enter_path"];
//                    [paramDict setValueIfNotNil:self.txid forKey:@"trx_id"];
//                    [paramDict setValueIfNotNil:@(self.business_type) forKey:@"business_type"];
//                    
//                    [[SensorsAnalyticsSDK sharedInstance] track:@"SendWatchWalletSign"
//                                                 withProperties:paramDict];
                    
                } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
//                    [FFBMSMBProgressShower hide:self];
//                    [FFBMSAlertShower showAlert:nil
//                                            msg:NSLocalizedString(@"transfer_wallet_send_fail", nil)
//                                          inCtl:[FFBMSTools getCurrentVC]
//                                          items:@[NSLocalizedString(@"dialog_yes", nil)]
//                                     clickBlock:^(NSInteger index) {
//                                     }];
                    
                    
                }];
            }];
        } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
//            @strongify(self)
            [self showTransactionFail];
        }];
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
//        @strongify(self)
        [self showTransactionFail];
    }];
}

- (void)showTransactionFail {
    
//    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
//    [paramDict setValueIfNotNil:self.enter_path forKey:@"enter_path"];
//    [paramDict setValueIfNotNil:@"" forKey:@"trx_id"];
//    [paramDict setValueIfNotNil:@(self.business_type) forKey:@"business_type"];
//
//    [[SensorsAnalyticsSDK sharedInstance] track:@"SendWatchWalletSign"
//                                 withProperties:paramDict];
//
//    [FFBMSMBProgressShower hide:self];
//    [FFBMSAlertShower showAlert:nil
//                            msg:NSLocalizedString(@"transfer_wallet_send_fail", nil)
//                          inCtl:[FFBMSTools getCurrentVC]
//                          items:@[NSLocalizedString(@"dialog_yes", nil)]
//                     clickBlock:^(NSInteger index) {
//                     }];
}

@end
