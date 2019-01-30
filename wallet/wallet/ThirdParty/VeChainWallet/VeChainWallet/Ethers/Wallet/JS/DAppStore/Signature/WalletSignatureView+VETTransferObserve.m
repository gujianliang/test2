//
//  WalletSignatureView+VETTransferObserve.m
//  VeWallet
//
//  Created by 曾新 on 2019/1/22.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletSignatureView+VETTransferObserve.h"
#import "WalletObersverTransactionModel.h"
#import "WalletBaseConfigModel.h"
#import "WalletBlockInfoApi.h"
//#import "WalletSqlDataEngine.h"
//#import "WalletTradeDetailVC.h"
//#import "WalletTradeDetailVC.h"
#import "WalletPaymentQRCodeView.h"
#import "WalletTransactionApi.h"
#import "WalletRewardNodeApi.h"

@implementation WalletSignatureView (VETTransferObserve)


-(void)icoTransferAccount:(NSString *)valueFormated
{
//    [FFBMSMBProgressShower showCircleIn:self];
    WalletObersverTransactionModel *transaction = [[WalletObersverTransactionModel alloc] init];
    
    // 生成随机 nonce
    SecureData* randomData = [SecureData secureDataWithLength:8];
    int result = SecRandomCopyBytes(kSecRandomDefault, randomData.length, randomData.mutableBytes);
    if (result != 0) {
        [FFBMSAlertShower showAlert:nil
                                msg:VCNSLocalizedBundleString(@"transfer_wallet_send_fail", nil)
                              inCtl:[FFBMSTools getCurrentVC]
                              items:@[VCNSLocalizedBundleString(@"dialog_yes", nil)]
                         clickBlock:^(NSInteger index)
         {
         }];
    }
    
    BigNumber *bigNonce = [[BigNumber bigNumberWithData:randomData.data] mod:[BigNumber bigNumberWithInteger:NSIntegerMax]];
    transaction.nonce = (bigNonce.hexString).lowercaseString;
    transaction.expiration = @"720";
    transaction.gasPriceCoef = self.gasPriceCoef.decimalString;
    
    if (![self.currentCoinModel.coinName isEqualToString:@"VET"]) {
        transaction.gas = [BigNumber bigNumberWithDecimalString:self.currentCoinModel.transferGas].decimalString;
        transaction.tokenAddress = self.currentCoinModel.address;
    }else{
        transaction.gas = [BigNumber bigNumberWithDecimalString:self.currentCoinModel.transferGas].decimalString;
        transaction.tokenAddress = @"";
    }
    
    WalletBaseConfigModel *configModel = nil;
    transaction.chainTag = configModel.chain_tag;
    
    // 获取最新区块ID前8bytes作为blockRef
    WalletBlockInfoApi *bestBlockApi = [[WalletBlockInfoApi alloc] init];
    @weakify(self)
    [bestBlockApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        @strongify(self)
//        [FFBMSMBProgressShower hide:self];
        
        WalletBlockInfoModel *blockModel = finishApi.resultModel;
        
        NSString *blockRef = [[blockModel.id substringFromIndex:2] substringToIndex:16];
        transaction.blockRef = ([BigNumber bigNumberWithHexString:[NSString stringWithFormat:@"0x%@",blockRef]].hexString).lowercaseString;
        
        transaction.to = self.toAddress.lowercaseString;
        transaction.amount = valueFormated;
        transaction.from = self.fromAddress;
        transaction.decimals = @(self.currentCoinModel.decimals);
        transaction.symbol = self.currentCoinModel.coinName;
        transaction.cost = [self.gasLimit stringByReplacingOccurrencesOfString:@" VTHO" withString:@""];
        
        NSString *payJson = [@"tr://" stringByAppendingString:[transaction yy_modelToJSONString]];
        
        [self showPayViewQRCode:payJson transactionModel:transaction];
        
    }failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        @strongify(self)
        [self showTransactionFail];
    }];
}

- (void)removrQRcodeView
{
    UIView *qrCodeView1 = [[FFBMSTools getCurrentVC].navigationController.view viewWithTag:701];
    UIView *qrCodeView2 = [[FFBMSTools getCurrentVC].navigationController.view viewWithTag:702];
    if (qrCodeView1) {
        [qrCodeView1 removeFromSuperview];
    }
    if (qrCodeView2) {
        [qrCodeView2 removeFromSuperview];
    }
}

- (void)successAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:VCNSLocalizedBundleString(@"转账发起成功", nil) message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [[UIApplication sharedApplication].keyWindow.rootViewController showViewController:alertController sender:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)reSignture
{
    [FFBMSAlertShower showAlert:nil
                            msg:VCNSLocalizedBundleString(@"transaction_signature_v_error", nil)
                          inCtl:[FFBMSTools getCurrentVC]
                          items:@[VCNSLocalizedBundleString(@"transaction_signature_v_error_button", nil)]
                     clickBlock:^(NSInteger index)
     {
         switch (index) {
             case 0:
             {
                 [self removrQRcodeView];
                 [self startTransaction];
             }
                 break;
             default:
                 break;
         }
     }];
}

-(void)showPayViewQRCode:(NSString *)json transactionModel:(WalletObersverTransactionModel *)transaction
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        WalletPaymentQRCodeView *QRCodeView = [[WalletPaymentQRCodeView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                                                       type:HotWalletQrCodeType
                                                                                       json:json
                                                                                   codeType:QRCodeVetType];
        QRCodeView.backgroundColor = UIColor.clearColor;
        QRCodeView.tag = 701;
        [[FFBMSTools getCurrentVC].navigationController.view addSubview:QRCodeView];
        [UIView animateWithDuration:0.3 animations:^{
            [QRCodeView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        }];
        @weakify(self)
        QRCodeView.block = ^(NSString *result)
        {
            @strongify(self)
            [self enterPayView:transaction];
        };
    });
    
}

-(void)enterPayView:(WalletObersverTransactionModel *)transaction
{
    
    WalletPaymentQRCodeView *QRCodeView = [[WalletPaymentQRCodeView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                                                   type:HotWalletScanType
                                                                                   json:@""
                                                                               codeType:QRCodeVetType];
    QRCodeView.backgroundColor = UIColor.clearColor;
    QRCodeView.tag = 702;
    QRCodeView.enter_path = @"transferList";
    QRCodeView.businessType = BusinessType_TRANSFER;
    [[FFBMSTools getCurrentVC].navigationController.view addSubview:QRCodeView];
    [UIView animateWithDuration:0.3 animations:^{
        [QRCodeView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }];
    @weakify(self);
    QRCodeView.block = ^(NSString *result)
    {
        @strongify(self);
        Transaction *transactionTransfer = [[Transaction alloc] init];
        transactionTransfer.nonce =  [[BigNumber bigNumberWithHexString:transaction.nonce] integerValue];
        
        transactionTransfer.Expiration =  transaction.expiration.integerValue;
        transactionTransfer.gasPrice   =  [BigNumber bigNumberWithDecimalString:transaction.gasPriceCoef];
        transactionTransfer.gasLimit   =  [BigNumber bigNumberWithDecimalString:transaction.gas];
        transactionTransfer.ChainTag   =  [BigNumber bigNumberWithHexString:transaction.chainTag];
        transactionTransfer.BlockRef   =  [BigNumber bigNumberWithHexString:transaction.blockRef];
        
        BigNumber *subValue;
        if ([transaction.symbol isEqualToString:@"VET"]) {
            //ven 转账  data 设置空
            subValue = [Payment parseEther:transaction.amount];
            if ([transaction.amount floatValue] == 0.0
                && [subValue lessThanEqualTo:[BigNumber constantZero]]) {
                NSData *toData = [SecureData hexStringToData:transaction.to];
                transactionTransfer.Clauses = @[@[toData,[NSData data],[NSData data]]];
            } else {
                NSData *toData = [SecureData hexStringToData:transaction.to];
                transactionTransfer.Clauses = @[@[toData,subValue.data,[NSData data]]];
            }
            
        } else {
            //token 转账 value 设置0，data 设置见文档
            subValue = [Payment parseToken:transaction.amount dicimals:transaction.decimals.integerValue];
            NSString *data = [FFBMSTools signData:transaction.to value:subValue.hexString];
            SecureData *tokenAddress = [SecureData secureDataWithHexString:transaction.tokenAddress];
            NSData *clauseData = [SecureData hexStringToData:data];
            transactionTransfer.Clauses = @[@[tokenAddress.data,[NSData data],clauseData]];
        }
        
        NSData *data = [SecureData hexStringToData:[@"0x" stringByAppendingString:result]];
        transactionTransfer.signature = [Signature signatureWithData:data];
        NSString *raw = [SecureData dataToHexString: [transactionTransfer serialize]];
        
        NSData *signtureMessage =  [transactionTransfer getSigntureMessage];
        
        Address *from =  [Account verifyMessage:signtureMessage signature:transactionTransfer.signature];
        
        if (![from.checksumAddress.lowercaseString isEqualToString:transaction.from.lowercaseString])
        {
            // 重新签名
            [self reSignture];
            return ;
        }
        
        //异常数据要重新签名
        if (transactionTransfer.signature.v == 2
            || transactionTransfer.signature.v == 3) {
            [self reSignture];
            return;
        }
        
        [self pageageTransaction:transactionTransfer
                transactionModel:transaction
                             raw:raw
                        subValue:subValue];
    };
}

-(void)pageageTransaction:(Transaction *) transactionTransfer
         transactionModel:(WalletObersverTransactionModel *)transaction
                      raw:(NSString *)raw
                 subValue:(BigNumber *)subValue
{
    // 获取最新区块ID前8bytes作为blockRef
    WalletBlockInfoApi *bestBlockApiNew = [[WalletBlockInfoApi alloc] init];
    @weakify(self)
    [bestBlockApiNew loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        @strongify(self)
        WalletBlockInfoModel *blockModelNew = finishApi.resultModel;
        
        
//        [sql saveTransferModel:model];
        
        // 发送交易
        [self sendraw:raw];
    }failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        @strongify(self)
        [self showTransactionFail];
    }];
}

- (void)sendraw:(NSString *)raw
{
    // 发送交易
    @weakify(self);
    WalletTransactionApi *transationApi = [[WalletTransactionApi alloc]initWithRaw:raw];
    [transationApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        @strongify(self)
//        [FFBMSMBProgressShower hide:self];
//        NC_POST_NAME_NO_OBJECT(kTransactionSuccess);
        [self removrQRcodeView];
        
        self.txid = finishApi.resultDict[@"id"];
//        NSString*
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
        [self timerCountBlock];
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        @strongify(self)
        [self showTransactionFail];
        [self removrQRcodeView];
    }];
}

- (void)showTransactionFail {
//    [FFBMSMBProgressShower hide:self];
    [FFBMSAlertShower showAlert:nil
                            msg:VCNSLocalizedBundleString(@"transfer_wallet_send_fail", nil)
                          inCtl:[FFBMSTools getCurrentVC]
                          items:@[VCNSLocalizedBundleString(@"dialog_yes", nil)]
                     clickBlock:^(NSInteger index) {
                     }];
}


- (void)startTransaction {
    if (![self checkNetwork]) {
        return;
    }
    
    [self doTransaction];

    
}


- (void)doTransaction
{

   
    // 格式化用户不正确输入
    Address *address = [Address addressWithString:self.toAddress];
    NSString *valueFormated = [self removeExtraZeroAtBegin:self.amount];
    NSArray *valueComponents = [valueFormated componentsSeparatedByString:@"."];
    // 如果用户输入的位数超过币的decimals，删掉多余的
    valueFormated = (valueComponents.count == 2 && ((NSString *)valueComponents.lastObject).length > self.currentCoinModel.decimals) ? [NSString stringWithFormat:@"%@%@%@", valueComponents[0], @".", [((NSString *)valueComponents[1]) substringToIndex:self.currentCoinModel.decimals]] : valueFormated;
    
    
    ////////////使用新控件
    
    BOOL ico =  NO;
    
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValueIfNotNil:@(ico) forKey:@"isICO"];
    [dictParam setValueIfNotNil:self.currentCoinModel forKey:@"coinModel"];
    [dictParam setValueIfNotNil:self.gasLimit forKey:@"miner"];
    [dictParam setValueIfNotNil:self.gasPriceCoef forKey:@"gasPriceCoef"];
    
    WalletSignatureView *signaVC = [[WalletSignatureView alloc] initWithFrame:self.bounds];
    [signaVC updateView:self.fromAddress
              toAddress:address.checksumAddress
           contractType:NoContract_transferToken
                 amount:valueFormated
                 params:@[dictParam]];
    
    
    // 1,是vet 还是 token 转账
    // 2,ico 还有其他的功能 签名
    // 3,矿工费
    // 4,gasPrice
    @weakify(self);
    signaVC.block = ^(BOOL result) {
        @strongify(self);
        [[FFBMSTools getCurrentVC].navigationController popViewControllerAnimated:NO];
        
        if (result) {
//            [self mark:@""];
        }
    };
    
    //    [self.navigationController.view addSubview:signaVC];
    //
    //    /////////////
    //
    //    return;
    //观察钱包走授权逻辑
    { // ico 观察钱包 或 普通观察钱包
        
        [self icoTransferAccount:valueFormated];
    
    }
}

- (BOOL)checkNetwork {
    // 检查网络
    AFNetworkReachabilityManager *reachManager = [AFNetworkReachabilityManager sharedManager];
    BOOL net = [reachManager isReachable];
    if (!net) {
        [FFBMSAlertShower showAlert:nil
                                msg:VCNSLocalizedBundleString(@"no_network_hint", nil)
                              inCtl:[FFBMSTools getCurrentVC]
                              items:@[VCNSLocalizedBundleString(@"dialog_yes", nil)]
                         clickBlock:^(NSInteger index) {
                         }];
        return NO;
    }
    return YES;
}



- (NSString *)removeExtraZeroAtBegin:(NSString *)valueFormated {
    while ([valueFormated hasPrefix:@"0"]
           || [valueFormated hasPrefix:@"."]) {
        if ([valueFormated isEqualToString:@"0."]) {
            valueFormated = @"0";
            break;
        }
        
        if ([valueFormated hasPrefix:@"0."]) {
            break;
        }
        
        if ([valueFormated hasPrefix:@"."] ) {
            valueFormated = [@"0" stringByAppendingString:valueFormated];
            break;
        }
        
        if ([valueFormated isEqualToString:@"0"]
            || ![valueFormated hasPrefix:@"0"]) {
            break;
        }
        
        if ([valueFormated hasPrefix:@"00"]) {
            valueFormated = [valueFormated substringFromIndex:1];
        } else if ([valueFormated hasPrefix:@"0"] && ![valueFormated hasPrefix:@"0."]) {
            valueFormated = [valueFormated substringFromIndex:1];
            break;
        }
    }
    return valueFormated;
}

- (void)mark:(NSString *)errorMsg
{

}

@end
