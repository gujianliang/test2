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
#import "WalletTransactionApi.h"
#import "WalletSingletonHandle.h"
#import "WalletMBProgressShower.h"
#import "WalletDAppHead.h"
#import "WalletSignatureViewSubView.h"

@implementation WalletSignatureView (transferToken)

- (void)signTransfer:(void(^)(NSString *txid))transferBlock;
{
    // 显示Loading
    [WalletMBProgressShower showCircleIn:self];
    
    Transaction *transaction = [[Transaction alloc] init];
    
    // 生成随机 nonce
    SecureData* randomData = [SecureData secureDataWithLength:8];
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        [WalletAlertShower showAlert:nil
                                msg:VCNSLocalizedBundleString(@"transfer_wallet_send_fail", nil)
                              inCtl:[WalletTools getCurrentVC]
                              items:@[VCNSLocalizedBundleString(@"dialog_yes", nil)]
                         clickBlock:^(NSInteger index) {
                         }];
    }
    transaction.nonce = [[[BigNumber bigNumberWithData:randomData.data] mod:[BigNumber bigNumberWithInteger:NSIntegerMax]] integerValue];
    
    transaction.Expiration = DefaultExpiration;
    transaction.gasPrice = self.gasPriceCoef;
    
    if (self.transferType == WalletContranctTransferType){ //合约签名
        transaction.gasLimit = [BigNumber bigNumberWithInteger:self.gas.integerValue];
    }else if (self.transferType == WalletTokenTransferType) { // token 签名
        transaction.gasLimit = [BigNumber bigNumberWithDecimalString:self.currentCoinModel.transferGas];
    }else{ // vet 签名
        if (self.currentCoinModel.transferGas.length > 0) {
            transaction.gasLimit = [BigNumber bigNumberWithDecimalString:self.currentCoinModel.transferGas];
        }else{
            transaction.gasLimit = [BigNumber bigNumberWithDecimalString:VETGasLimit];
        }
    }
    // 拉创世区块id做chainTag
    [self getGenesisBlockInfo:transaction];
}

- (void)getGenesisBlockInfo:(Transaction *)transaction
{
    // 拉创世区块id做chainTag
    @weakify(self)
    WalletGenesisBlockInfoApi *genesisBlock = [WalletGenesisBlockInfoApi new];
    [genesisBlock loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        @strongify(self)
        WalletBlockInfoModel *genesisblockModel = finishApi.resultModel;
        NSString *blockID = genesisblockModel.id;
        NSString *chainTag = [NSString stringWithFormat:@"0x%@", [blockID substringFromIndex:blockID.length-2]];
        transaction.ChainTag = [BigNumber bigNumberWithHexString:chainTag];
        
        [self getBestBlockInfo:transaction];
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        @strongify(self)
        [self showTransactionFail];
    }];
}

- (void)getBestBlockInfo:(Transaction *)transaction
{
    // 获取最新区块ID前8bytes作为blockRef
    WalletBlockInfoApi *bestBlockApi = [[WalletBlockInfoApi alloc] init];
    @weakify(self)
    [bestBlockApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        @strongify(self)
        WalletBlockInfoModel *blockModel = finishApi.resultModel;
        
        NSString *blockRef = [[blockModel.id substringFromIndex:2] substringToIndex:16];
        transaction.BlockRef = [BigNumber bigNumberWithHexString:[NSString stringWithFormat:@"0x%@",blockRef]];
        
        
        [self packageClausesData:transaction];
        // 尝试用户密码解密keystore
        [self sign:transaction];
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        @strongify(self)
        [self showTransactionFail];
    }];
}

- (void)packageClausesData:(Transaction *)transaction
{
    if (self.clauseList.count > 0){
        NSArray *subClause = self.clauseList[0];
        if (subClause.count == 3) {
            transaction.Clauses = self.clauseList;
            return;
        }
        [self showTransactionFail];
    }
    BigNumber *subValue;
    if (self.transferType == WalletVETTransferType) {
        //vet 转账  data 设置空
        subValue = [Payment parseEther:self.amount];
        if ([self.amount floatValue] == 0.0
            && [subValue lessThanEqualTo:[BigNumber constantZero]]) {
            NSData *toData = [SecureData hexStringToData:self.toAddress];
            transaction.Clauses = @[@[toData,[NSData data],[NSData data]]];
        } else {
            NSData *toData = [SecureData hexStringToData:self.toAddress];
            transaction.Clauses = @[@[toData,subValue.data,[NSData data]]];
        }
        
    } else if(self.transferType == WalletTokenTransferType) {
        //token 转账 value 设置0，data 设置见文档
        subValue = [Payment parseToken:self.amount dicimals:self.currentCoinModel.decimals];
        
        SecureData *tokenAddress = [SecureData secureDataWithHexString:self.tokenAddress];
        transaction.Clauses = @[@[tokenAddress.data,[NSData data],self.clauseData]];
    }else if(self.transferType == WalletContranctTransferType) { // 合约转账
        CGFloat amountF = self.amount.floatValue;
        if (amountF == 0) {
            if (self.tokenAddress.length == 0) {
                transaction.Clauses = @[@[[NSData data],[NSData data], self.clauseData]];
            }else{
                transaction.Clauses = @[@[[SecureData hexStringToData:self.tokenAddress],[NSData data], self.clauseData]];
            }
        } else {
            
            if (self.tokenAddress.length == 0) {
                BigNumber *subValue = [Payment parseEther:self.amount];
                transaction.Clauses = @[@[[NSData data],subValue.data, self.clauseData]];
            }else{
                BigNumber *subValue = [Payment parseEther:self.amount];
                transaction.Clauses = @[@[[SecureData hexStringToData:self.tokenAddress],subValue.data, self.clauseData]];
            }
        }
    }
}

- (void)sign:(Transaction *)transaction
{
    // 尝试用户密码解密keystore
    NSString *keystore = self.keystore.length > 0 ?self.keystore : [[WalletSingletonHandle shareWalletHandle]currentWalletModel].keyStore;
    @weakify(self)

    [Account decryptSecretStorageJSON:keystore password:self.signatureSubView.pwTextField.text callback:^(Account *account, NSError *NSError) {
        @strongify(self)
        if (!account) {
            [WalletMBProgressShower hide:self];
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
            [self showTransactionFail];
        
        }else{
            NSString *raw = [SecureData dataToHexString: [transaction serialize]];
            [self sendRaw:raw];
        }
    }];
}

- (void)sendRaw:(NSString *)raw
{
    NSLog(@"raw ==%@",raw);
    // 发送交易
    @weakify(self)
    WalletTransactionApi *transationApi1 = [[WalletTransactionApi alloc]initWithRaw:raw];
    [transationApi1 loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        @strongify(self);
        [WalletMBProgressShower hide:self];
        self.txid = finishApi.resultDict[@"id"];
        
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
        [self timerCountBlock];
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        [WalletMBProgressShower hide:self];
        [WalletAlertShower showAlert:nil
                                msg:VCNSLocalizedBundleString(@"transfer_wallet_send_fail", nil)
                              inCtl:[WalletTools getCurrentVC]
                              items:@[VCNSLocalizedBundleString(@"dialog_yes", nil)]
                         clickBlock:^(NSInteger index) {
                         }];
        
        
    }];
}

- (void)showTransactionFail {
    
    [WalletMBProgressShower hide:self];
    [WalletAlertShower showAlert:nil
                            msg:VCNSLocalizedBundleString(@"transfer_wallet_send_fail", nil)
                          inCtl:[WalletTools getCurrentVC]
                          items:@[VCNSLocalizedBundleString(@"dialog_yes", nil)]
                     clickBlock:^(NSInteger index) {
                     }];
    if (self.transferBlock) {
        self.transferBlock(@"");
    }
}

@end
