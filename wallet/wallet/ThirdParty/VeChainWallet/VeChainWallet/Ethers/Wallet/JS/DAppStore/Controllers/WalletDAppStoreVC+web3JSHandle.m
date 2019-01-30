//
//  WalletDAppStoreVC+web3JSHardle.m
//  VeWallet
//
//  Created by 曾新 on 2019/1/23.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletDAppStoreVC+web3JSHandle.h"
#import "WalletVETBalanceApi.h"
//#import "WalletSqlDataEngine.h"
#import "WalletGenesisBlockInfoApi.h"
#import "WalletVETBalanceApi.h"
#import <WebKit/WebKit.h>
#import "WalletAccountCodeApi.h"
#import "WalletBlockApi.h"
#import "WalletTransantionsReceiptApi.h"
#import "WalletManageModel.h"
//#import "WalletSqlDataEngine.h"
#import "WalletSignatureView.h"
#import "WalletGetSymbolApi.h"
#import "WalletGetDecimalsApi.h"
#import "WalletSingletonHandle.h"
@implementation WalletDAppStoreVC (web3JSHandle)

- (void)getBalance:(NSString *)callbackID
                 webView:(WKWebView *)webView
               requestId:(NSString *)requestId
                 address:(NSString *)address
{
    WalletVETBalanceApi *vetBalanceApi = [[WalletVETBalanceApi alloc]initWith:address];
    [vetBalanceApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        WalletBalanceModel *balanceModel = finishApi.resultModel;
        
        [FFBMSTools callback:requestId
                        data:balanceModel.balance
                  callbackID:callbackID
                     webview:webView
                        code:OK
                     message:@""];
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        [FFBMSTools callback:requestId
                        data:@""
                  callbackID:callbackID
                     webview:webView
                        code:ERROR_SERVER_DATA
                     message:@"Server response error"];
    }];
}

- (NSString *)getAddress
{
    return [[WalletSingletonHandle shareWalletHandle] currentWalletModel].address;
}

- (void)getAddress:(WKWebView *)webView callbackID:(NSString *)callbackID
{
    NSString *injectJS = [NSString stringWithFormat:@"%@('%@')",callbackID,[self getAddress]];
    NSLog(@"inject func %@",injectJS);
    [webView evaluateJavaScript:injectJS completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"error == %@",error);
    }];
}

- (void)WEB3VETTransferFrom1:(NSString *)from1
                          to:(NSString *)to
                      amount:(NSString *)amount
                   requestId:(NSString *)requestId
                        gas:(NSString *)gas
                     webView:(WKWebView *)webView
                  callbackID:(NSString *)callbackID
                   gasCanUse:(BigNumber *)gasCanUse
                    gasPrice:(NSString *)gasPrice
{
    NSString *amountStr = [BigNumber bigNumberWithHexString:amount].decimalString;
    CGFloat amountTnteger = amountStr.floatValue/pow(10,18);
    if (![self errorAddressAlert:to] ||
        ![self errorAmount:amountStr coinName:@"VET"] ||
        ![self fromISToAddress:from1 to:to] ||
        !(gas.integerValue > 0)) {
        
        [FFBMSTools callback:requestId
                        data:@""
                  callbackID:callbackID
                     webview:webView
                        code:ERROR_REQUEST_PARAMS
                     message:@"request params error"];
        
        return;
    }
    
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValueIfNotNil:@(0) forKey:@"isICO"];
    
    WalletCoinModel *coinModel = [[WalletCoinModel alloc]init];
    coinModel.coinName = @"VET";
    coinModel.transferGas = gas;
    coinModel.decimals = 18;
    
    [dictParam setValueIfNotNil:coinModel forKey:@"coinModel"];
    
    NSString *miner = [Payment formatEther:gasCanUse options:2];
    [dictParam setValueIfNotNil:miner forKey:@"miner"];
    [dictParam setValueIfNotNil:[BigNumber bigNumberWithHexString:gasPrice] forKey:@"gasPriceCoef"];
    [dictParam setValueIfNotNil:[NSNumber numberWithLong:gas.integerValue] forKey:@"gas"];
    
    WalletSignatureView *signaVC = [[WalletSignatureView alloc] initWithFrame:[FFBMSTools getCurrentVC].view.bounds];
    signaVC.jsUse = YES;
    signaVC.transferType = JSVETTransferType;
    [signaVC updateView:from1
              toAddress:to
           contractType:NoContract_transferToken
                 amount:[NSString stringWithFormat:@"%lf",amountTnteger]
                 params:@[dictParam]];
    [[FFBMSTools getCurrentVC].navigationController.view addSubview:signaVC];
    
    signaVC.transferBlock = ^(NSString * _Nonnull txid) {
        NSLog(@"txid = %@",txid);
        
        if (txid.length == 0) {
            
            [FFBMSTools callback:requestId
                            data:@""
                      callbackID:callbackID
                         webview:webView
                            code:ERROR_CANCEL
                         message:@"User cancelled"];
        }else{
            
            [FFBMSTools callback:requestId
                            data:txid
                      callbackID:callbackID
                         webview:webView
                            code:OK
                         message:@""];
        }
        
    };
}

- (void)WEB3VTHOTransfer:(WalletSignatureView *)signaVC
                    from:(NSString *)from
                  to:(NSString *)to
              amount:(NSString *)amount
           requestId:(NSString *)requestId
                 gas:(NSString *)gas
            gasPrice:(NSString *)gasPrice
             webView:(WKWebView *)webView
          callbackID:(NSString *)callbackID
           gasCanUse:(BigNumber *)gasCanUse
          cluseData:(NSString *)cluseData
        tokenAddress:(NSString *)tokenAddress
{
    __block NSString *name = @"";
    
    WalletGetSymbolApi *getSymbolApi = [[WalletGetSymbolApi alloc]initWithTokenAddress:tokenAddress];
    [getSymbolApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        
        NSLog(@"ddd");
        NSDictionary *dictResult = finishApi.resultDict;
        NSString *symobl = dictResult[@"data"];
        if (symobl.length < 3) {
            [FFBMSTools callback:requestId
                            data:@""
                      callbackID:callbackID
                         webview:webView
                            code:ERROR_REQUEST_PARAMS
                         message:@"request params error"];
            return ;
        }
        
        name = [FFBMSTools abiDecodeString:symobl];
        
        WalletGetDecimalsApi *getDecimalsApi = [[WalletGetDecimalsApi alloc]initWithTokenAddress:tokenAddress];
        [getDecimalsApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
            
            NSDictionary *dictResult = finishApi.resultDict;
            NSString *symoblHex = dictResult[@"data"];
            
            if (symoblHex.length < 3) {
                [FFBMSTools callback:requestId
                                data:@""
                          callbackID:callbackID
                             webview:webView
                                code:ERROR_REQUEST_PARAMS
                             message:@"request params error"];
                return ;
            }
            
            NSString *symobl = [BigNumber bigNumberWithHexString:symoblHex].decimalString;
            
            NSString *qq = [cluseData stringByReplacingOccurrencesOfString:transferMethodId withString:@""];
            NSString *rrr = @"";
            if (qq.length > 32) {
                rrr = [qq substringWithRange:NSMakeRange(64, 64)];
            }
            CGFloat amountTnteger = [BigNumber bigNumberWithHexString:[NSString stringWithFormat:@"0x%@",rrr]].decimalString.floatValue/pow(10, symobl.integerValue);
            
            if (![self errorAddressAlert:to] ||
                ![self errorAmount:[NSString stringWithFormat:@"%lf",amountTnteger] coinName:@"!VET"] || //不是vet
                ![self fromISToAddress:from to:to]||
                !(gas.integerValue > 0)||
                cluseData.length == 0) {
                
                [FFBMSTools callback:requestId
                                data:@""
                          callbackID:callbackID
                             webview:webView
                                code:ERROR_REQUEST_PARAMS
                             message:@"request params error"];
                return;
            }
            
            NSString *miner = [Payment formatEther:gasCanUse options:2];
            
            NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
            [dictParam setValueIfNotNil:@(0) forKey:@"isICO"];
            
            WalletCoinModel *coinModel = [[WalletCoinModel alloc]init];
            coinModel.coinName = name;
            coinModel.transferGas = gas;
            coinModel.decimals = symobl.integerValue;
            coinModel.address = tokenAddress;
            
            [dictParam setValueIfNotNil:coinModel forKey:@"coinModel"];
            [dictParam setValueIfNotNil:miner forKey:@"miner"];
            [dictParam setValueIfNotNil:[BigNumber bigNumberWithInteger:gasPrice.integerValue] forKey:@"gasPriceCoef"];
            [dictParam setValueIfNotNil:[NSNumber numberWithFloat:gas.floatValue] forKey:@"gas"];
            
            BigNumber *dataH = [BigNumber bigNumberWithHexString:cluseData];
            [dictParam setValueIfNotNil:dataH.data forKey:@"clouseData"];
            
            WalletSignatureView *signaVC = [[WalletSignatureView alloc] initWithFrame:[FFBMSTools getCurrentVC].view.bounds];
            signaVC.jsUse = YES;
            signaVC.transferType = JSVTHOTransferType;
            [signaVC updateView:from
                      toAddress:to
                   contractType:NoContract_transferToken
                         amount:[NSString stringWithFormat:@"%.0f",amountTnteger]
                         params:@[dictParam]];
            [[FFBMSTools getCurrentVC].navigationController.view addSubview:signaVC];
            
            signaVC.transferBlock = ^(NSString * _Nonnull txid) {
                NSLog(@"txid = %@",txid);
                if (txid.length == 0) {
                    
                    [FFBMSTools callback:requestId
                                    data:@""
                              callbackID:callbackID
                                 webview:webView
                                    code:ERROR_CANCEL
                                 message:@"User cancelled"];
                }else{
                    
                    [FFBMSTools callback:requestId
                                    data:txid
                              callbackID:callbackID
                                 webview:webView
                                    code:OK
                                 message:@""];
                }
            };
        } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
            [FFBMSTools callback:requestId
                            data:@""
                      callbackID:callbackID
                         webview:webView
                            code:ERROR_SERVER_DATA
                         message:@"Server response error"];
        }];
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        [FFBMSTools callback:requestId
                        data:@""
                  callbackID:callbackID
                     webview:webView
                        code:ERROR_SERVER_DATA
                     message:@"Server response error"];
    }];
}

- (void)WEB3contractSign:(WalletSignatureView *)signaVC
                      to:(NSString *)to
                   from1:(NSString *)from1
                  amount:(NSString * )amount
               requestId:(NSString *)requestId
                     gas:(NSString *)gas
                gasPrice:(NSString *)gasPrice
               gasCanUse:(BigNumber *)gasCanUse
                 webView:(WKWebView *)webView
              callbackID:(NSString *)callbackID
               cluseData:(NSString *)cluseData
{
    if (cluseData.length == 0 ||
        !(gas.integerValue > 0)) {
        
        [FFBMSTools callback:requestId
                        data:@""
                  callbackID:callbackID
                     webview:webView
                        code:ERROR_REQUEST_PARAMS
                     message:@"request params error"];
        
        return;
    }
//    gas = [NSString stringWithFormat:@"%lf",gas.floatValue * 5];
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValueIfNotNil:@(0) forKey:@"isICO"];
    
    NSString *miner = [Payment formatEther:gasCanUse options:2];
//    gasPrice = @"0";
//    gas = @"350000";
    [dictParam setValueIfNotNil:miner forKey:@"miner"];
    [dictParam setValueIfNotNil:[BigNumber bigNumberWithHexString:gasPrice] forKey:@"gasPriceCoef"];
    [dictParam setValueIfNotNil:[NSNumber numberWithFloat:gas.floatValue] forKey:@"gas"];
    
//    cluseData = @"0xbae3e19e00000000000000000000000000000000000000000000000000000000000000680000000000000000000000000000000000000000000000000de0b6b3a76400000000000000000000000000000000000000000000000000000de0b6b3a7640000000000000000000000000000000000000000000000000000000000000003f480";
    
    BigNumber *dataH = [BigNumber bigNumberWithHexString:cluseData];
    [dictParam setValueIfNotNil:dataH.data forKey:@"clouseData"];
    
    if (to.length == 0) {
        [dictParam setValueIfNotNil:[NSData data] forKey:@"tokenAddress"];
        
    }else{
        [dictParam setValueIfNotNil:to forKey:@"tokenAddress"];
    }
    
    CGFloat amountTnteger = [BigNumber bigNumberWithHexString:[NSString stringWithFormat:@"%@",amount]].decimalString.floatValue/pow(10, 18);

    signaVC.jsUse = YES;
    signaVC.transferType = JSContranctTransferType;
    [signaVC updateView:from1
              toAddress:@""
           contractType:NoContract_transferToken
                 amount:[NSString stringWithFormat:@"%.2f",amountTnteger]
                 params:@[dictParam]];
    [[FFBMSTools getCurrentVC].navigationController.view addSubview:signaVC];
    signaVC.transferBlock = ^(NSString * _Nonnull txid) {
        NSLog(@"txid = %@",txid);
        if (txid.length == 0) {
            
            [FFBMSTools callback:requestId
                            data:@""
                      callbackID:callbackID
                         webview:webView
                            code:ERROR_CANCEL
                         message:@"User cancelled"];
        }else{
            
            [FFBMSTools callback:requestId
                            data:txid
                      callbackID:callbackID
                         webview:webView
                            code:OK
                         message:@""];
        }
    };
}

- (void)getChainTag:(NSString *)requestId
  completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    NSDictionary *dict1 = [FFBMSTools packageWithRequestId:requestId
                                                      data:[WalletUserDefaultManager getBlockUrl]
                                                      code:OK
                                                   message:@""];
    completionHandler([dict1 yy_modelToJSONString]);
}

- (BOOL)errorAddressAlert:(NSString *)toAddress
{
    // 格式校验
    bool isok = YES;
    if (!toAddress
        || ![toAddress.uppercaseString hasPrefix:@"0X"]
        || toAddress.length != 42
        || (![toAddress hasSuffix:[toAddress substringFromIndex:2]])) {
        //            0x1113A  1113A
        // 是否有 checksum 校验
        isok = NO;
        NSString *lowercaseAddress = [toAddress substringFromIndex:2].lowercaseString;
        if (toAddress
            && [toAddress hasSuffix:lowercaseAddress]
            && ![[toAddress substringFromIndex:2] hasSuffix:lowercaseAddress]) {
            //                noChecksum = YES;
            isok = NO;
        } else if ([[toAddress substringFromIndex:2] hasSuffix:lowercaseAddress]) {
            isok = YES;
        } else if (!toAddress
                   && [toAddress.uppercaseString hasPrefix:@"0X"]
                   && toAddress.length == 42) {
            isok = NO;
        }
    }
    
    NSString *regex = @"^(0x|0X){1}[0-9A-Fa-f]{40}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL allAreValidChar = [predicate evaluateWithObject:toAddress];
    isok = !allAreValidChar;
    if (!isok) {
        [FFBMSAlertShower showAlert:nil
                                msg:VCNSLocalizedBundleString(@"非法参数", nil)
                              inCtl:[UIApplication sharedApplication].keyWindow.rootViewController
                              items:@[VCNSLocalizedBundleString(@"dialog_yes", nil)]
                         clickBlock:^(NSInteger index) {
                         }];
        return NO;
    }
    return YES;
}

- (BOOL)errorAmount:(NSString *)amount coinName:(NSString *)coinName
{
    // 例外情况 - VET 转账0
    BOOL bAmount = YES;
    
    // 金额逻辑校验
    if ([amount floatValue] <= 0
        || [Payment parseEther:amount] == nil
        || amount.length == 0) {
        bAmount = NO;
    }
    
    if (amount.length == 0) {
        bAmount = NO;
    }
    
    if (amount.length > 20) {
        bAmount = NO;
    }
    
    if ([amount floatValue] == 0
        && [[Payment parseEther:amount] lessThanEqualTo:[BigNumber constantZero]]
        && [coinName isEqualToString:@"VET"]){
        bAmount = YES;
    }
    if (!bAmount) {
        [FFBMSAlertShower showAlert:nil
                                msg:VCNSLocalizedBundleString(@"非法参数", nil)
                              inCtl:[UIApplication sharedApplication].keyWindow.rootViewController
                              items:@[VCNSLocalizedBundleString(@"dialog_yes", nil)]
                         clickBlock:^(NSInteger index) {
                         }];
        return NO;
    }
    return YES;
}

- (BOOL)fromISToAddress:(NSString *)from to:(NSString *)to
{
    bool isSame = NO;
    if ([from.lowercaseString isEqualToString:to.lowercaseString]) {
        isSame = YES;
    }
    if (isSame) {
        [FFBMSAlertShower showAlert:nil
                                msg:VCNSLocalizedBundleString(@"非法参数", nil)
                              inCtl:[UIApplication sharedApplication].keyWindow.rootViewController
                              items:@[VCNSLocalizedBundleString(@"dialog_yes", nil)]
                         clickBlock:^(NSInteger index) {
                         }];
        return NO;
    }
    return YES;
}


@end
