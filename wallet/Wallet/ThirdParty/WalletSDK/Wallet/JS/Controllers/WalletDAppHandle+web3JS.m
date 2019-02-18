//
//  WalletDAppHandle+web3JSHardle.m
//  VeWallet
//
//  Created by 曾新 on 2019/1/23.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletDAppHandle+web3JS.h"
#import "WalletVETBalanceApi.h"
#import "WalletGenesisBlockInfoApi.h"
#import "WalletVETBalanceApi.h"
#import <WebKit/WebKit.h>
#import "WalletAccountCodeApi.h"
#import "WalletBlockApi.h"
#import "WalletTransantionsReceiptApi.h"
#import "WalletManageModel.h"
#import "WalletSignatureView.h"
#import "WalletGetSymbolApi.h"
#import "WalletGetDecimalsApi.h"
#import "WalletSingletonHandle.h"
#import "WalletDAppHandle+connexJS.h"

@implementation WalletDAppHandle (web3JS)

- (void)getBalance:(NSString *)callbackId
                 webView:(WKWebView *)webView
               requestId:(NSString *)requestId
                 address:(NSString *)address
{
    WalletVETBalanceApi *vetBalanceApi = [[WalletVETBalanceApi alloc]initWith:address];
    [vetBalanceApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        WalletBalanceModel *balanceModel = finishApi.resultModel;
        
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView 
                                     data:balanceModel.balance
                               callbackId:callbackId
                                     code:OK];
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView 
                                     data:@""
                               callbackId:callbackId
                                     code:ERROR_SERVER_DATA];
    }];
}

- (NSString *)getAddress
{
    return [[WalletSingletonHandle shareWalletHandle] currentWalletModel].address;
}

- (void)getAddress:(WKWebView *)webView callbackId:(NSString *)callbackId
{
    NSString *injectJS = [NSString stringWithFormat:@"%@('%@')",callbackId,[self getAddress]];
    NSLog(@"inject func %@",injectJS);
    [webView evaluateJavaScript:injectJS completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"error == %@",error);
    }];
}

- (void)web3VETTransferFrom:(NSString *)from
                          to:(NSString *)to
                      amount:(NSString *)amount
                   requestId:(NSString *)requestId
                        gas:(NSString *)gas
                     webView:(WKWebView *)webView
                  callbackId:(NSString *)callbackId
                    gasPrice:(NSString *)gasPrice
{
    NSString *amountStr = [BigNumber bigNumberWithHexString:amount].decimalString;
    CGFloat amountTnteger = amountStr.floatValue/pow(10,18);
    if (![self errorAddressAlert:to] ||
        ![self errorAmount:amountStr coinName:@"VET"] ||
        ![WalletTools fromISToAddress:from to:to] ||
        !(gas.integerValue > 0)) {
        
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView 
                                     data:@""
                               callbackId:callbackId
                                     code:ERROR_REQUEST_PARAMS];
        
        return;
    }
    
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    
    WalletCoinModel *coinModel = [[WalletCoinModel alloc]init];
    coinModel.coinName         = @"VET";
    coinModel.transferGas      = gas;
    coinModel.decimals         = 18;
    
    [dictParam setValueIfNotNil:coinModel forKey:@"coinModel"];
    
    BigNumber *gasCanUse = [WalletTools calcThorNeeded:gasPrice.floatValue gas:[NSNumber numberWithInteger:gas.integerValue]];
    NSString *miner = [Payment formatEther:gasCanUse options:2];
    
    [dictParam setValueIfNotNil:miner forKey:@"miner"];
    [dictParam setValueIfNotNil:[BigNumber bigNumberWithHexString:gasPrice] forKey:@"gasPriceCoef"];
    [dictParam setValueIfNotNil:[NSNumber numberWithLong:gas.integerValue] forKey:@"gas"];
    
    WalletSignatureView *signatureView = [[WalletSignatureView alloc] initWithFrame:[WalletTools getCurrentVC].view.bounds];
    signatureView.tag = SignViewTag;
    signatureView.transferType = JSVETTransferType;
    [signatureView updateView:from
              toAddress:to
           contractType:NoContract_transferToken
                 amount:[NSString stringWithFormat:@"%lf",amountTnteger]
                 params:@[dictParam]];
    [[WalletTools getCurrentVC].navigationController.view addSubview:signatureView];
    
    signatureView.transferBlock = ^(NSString * _Nonnull txid) {
        NSLog(@"txid = %@",txid);
        
        if (txid.length == 0) {
            
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                         data:@""
                                   callbackId:callbackId
                                         code:ERROR_CANCEL];
        }else{
            
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                         data:txid
                                   callbackId:callbackId
                                         code:OK];
        }
    };
}

- (void)web3VTHOTransferFrom:(NSString *)from
                  to:(NSString *)to
              amount:(NSString *)amount
           requestId:(NSString *)requestId
                 gas:(NSString *)gas
            gasPrice:(NSString *)gasPrice
             webView:(WKWebView *)webView
          callbackId:(NSString *)callbackId
          clauseData:(NSString *)clauseData
        tokenAddress:(NSString *)tokenAddress
{
    __block NSString *coinName = @"";
    
    WalletGetSymbolApi *getSymbolApi = [[WalletGetSymbolApi alloc]initWithTokenAddress:tokenAddress];
    [getSymbolApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        
        NSLog(@"ddd");
        NSDictionary *dictResult = finishApi.resultDict;
        NSString *symobl = dictResult[@"data"];
        if (symobl.length < 3) {
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                         data:@""
                                   callbackId:callbackId
                                         code:ERROR_REQUEST_PARAMS];
            return ;
        }
   
        [self getTokenSymobl:tokenAddress requestId:requestId webView:webView callbackId:callbackId clauseData:clauseData symobl:symobl to:to from:from gas:gas coinName:coinName gasPrice:gasPrice];
            
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView 
                                     data:@""
                               callbackId:callbackId
                                     code:ERROR_SERVER_DATA];
    }];
}

- (void)getTokenSymobl:(NSString *)tokenAddress
             requestId:(NSString *)requestId
               webView:(WKWebView *)webView
            callbackId:(NSString *)callbackId
             clauseData:(NSString *)clauseData
                symobl:(NSString *)symobl
                    to:(NSString *)to
                  from:(NSString *)from
                   gas:(NSString *)gas
              coinName:(NSString *)coinName
              gasPrice:(NSString *)gasPrice
{
    WalletGetDecimalsApi *getDecimalsApi = [[WalletGetDecimalsApi alloc]initWithTokenAddress:tokenAddress];
    [getDecimalsApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        
        NSDictionary *dictResult = finishApi.resultDict;
        NSString *decimalsHex = dictResult[@"data"];
        
        if (decimalsHex.length < 3) {
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:@""
                                    callbackId:callbackId
                                          code:ERROR_REQUEST_PARAMS];
            return ;
        }
        
        NSString *decimals = [BigNumber bigNumberWithHexString:decimalsHex].decimalString;
        
        [self enterVTHOTransferViewCluseData:clauseData
                                      decimals:decimals
                                          to:to
                                        from:from
                                         gas:gas
                                   requestId:requestId
                                     webView:webView
                                  callbackId:callbackId
                                    coinName:coinName
                                tokenAddress:tokenAddress
                                    gasPrice:gasPrice];
        
    }failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_SERVER_DATA];
    }];
}

- (void)enterVTHOTransferViewCluseData:(NSString *)clauseData decimals:(NSString *)decimals to:(NSString *)to from:(NSString *)from gas:(NSString *)gas requestId:(NSString *)requestId webView:(WKWebView *)webView callbackId:(NSString *)callbackId coinName:(NSString *)coinName tokenAddress:(NSString *)tokenAddress gasPrice:(NSString *)gasPrice
{
    NSString *cluseStr = [clauseData stringByReplacingOccurrencesOfString:TransferMethodId withString:@""];
    NSString *tokenAmount = @"";
    if (cluseStr.length >= 128) {
        tokenAmount = [cluseStr substringWithRange:NSMakeRange(64, 64)];
    }
    CGFloat amountTnteger = [BigNumber bigNumberWithHexString:[NSString stringWithFormat:@"0x%@",tokenAmount]].decimalString.floatValue/pow(10, decimals.integerValue);
    
    if (![self errorAddressAlert:to] ||
        ![self errorAmount:[NSString stringWithFormat:@"%lf",amountTnteger] coinName:@"!VET"] || //不是vet
        ![WalletTools fromISToAddress:from to:to]||
        !(gas.integerValue > 0)||
        clauseData.length == 0) {
        
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_REQUEST_PARAMS];
        return;
    }
    
    BigNumber *gasCanUse = [WalletTools calcThorNeeded:gasPrice.floatValue gas:[NSNumber numberWithInteger:gas.integerValue]];
    NSString *miner = [Payment formatEther:gasCanUse options:2];
    
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    
    WalletCoinModel *coinModel = [[WalletCoinModel alloc]init];
    coinModel.coinName         = coinName;
    coinModel.transferGas      = gas;
    coinModel.decimals         = decimals.integerValue;
    coinModel.address          = tokenAddress;
    
    [dictParam setValueIfNotNil:coinModel forKey:@"coinModel"];
    [dictParam setValueIfNotNil:miner forKey:@"miner"];
    [dictParam setValueIfNotNil:[BigNumber bigNumberWithInteger:gasPrice.integerValue] forKey:@"gasPriceCoef"];
    [dictParam setValueIfNotNil:[NSNumber numberWithFloat:gas.floatValue] forKey:@"gas"];
    
    WalletSignatureView *signatureView = [[WalletSignatureView alloc] initWithFrame:[WalletTools getCurrentVC].view.bounds];
    signatureView.tag = SignViewTag;
    signatureView.transferType = JSVTHOTransferType;
    [signatureView updateView:from
                    toAddress:to
                 contractType:NoContract_transferToken
                       amount:[NSString stringWithFormat:@"%.0f",amountTnteger]
                       params:@[dictParam]];
    [[WalletTools getCurrentVC].navigationController.view addSubview:signatureView];
    
    signatureView.transferBlock = ^(NSString * _Nonnull txid) {
        NSLog(@"txid = %@",txid);
        if (txid.length == 0) {
            
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:@""
                                    callbackId:callbackId
                                          code:ERROR_CANCEL];
        }else{
            
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:txid
                                    callbackId:callbackId
                                          code:OK];
        }
    };
}

- (void)web3contractSignFrom:(NSString *)from
                      to:(NSString *)to
                  amount:(NSString *)amount
               requestId:(NSString *)requestId
                     gas:(NSString *)gas
                gasPrice:(NSString *)gasPrice
                 webView:(WKWebView *)webView
              callbackId:(NSString *)callbackId
               clauseData:(NSString *)clauseData
{
    if (clauseData.length == 0 ||
        !(gas.integerValue > 0)) {
        
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView 
                                     data:@""
                               callbackId:callbackId
                                     code:ERROR_REQUEST_PARAMS];
        
        return;
    }
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    
    BigNumber *gasCanUse = [WalletTools calcThorNeeded:gasPrice.floatValue gas:[NSNumber numberWithInteger:gas.integerValue]];
    NSString *miner = [Payment formatEther:gasCanUse options:2];
    
    [dictParam setValueIfNotNil:miner forKey:@"miner"];
    [dictParam setValueIfNotNil:[BigNumber bigNumberWithHexString:gasPrice] forKey:@"gasPriceCoef"];
    [dictParam setValueIfNotNil:[NSNumber numberWithFloat:gas.floatValue] forKey:@"gas"];
    
    if (to.length == 0) {
        [dictParam setValueIfNotNil:[NSData data] forKey:@"tokenAddress"];
        
    }else{
        [dictParam setValueIfNotNil:to forKey:@"tokenAddress"];
    }
    
    CGFloat amountTnteger = [BigNumber bigNumberWithHexString:[NSString stringWithFormat:@"%@",amount]].decimalString.floatValue/pow(10, 18);

    WalletSignatureView *signatureView = [[WalletSignatureView alloc] initWithFrame:[WalletTools getCurrentVC].view.bounds];
    signatureView.tag = SignViewTag;
    signatureView.transferType = JSContranctTransferType;
    [signatureView updateView:from
              toAddress:@""
           contractType:NoContract_transferToken
                 amount:[NSString stringWithFormat:@"%.2f",amountTnteger]
                 params:@[dictParam]];
    [[WalletTools getCurrentVC].navigationController.view addSubview:signatureView];
    signatureView.transferBlock = ^(NSString * _Nonnull txid) {
        NSLog(@"txid = %@",txid);
        if (txid.length == 0) {
            
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                         data:@""
                                   callbackId:callbackId
                                         code:ERROR_CANCEL];
        }else{
            
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                         data:txid
                                   callbackId:callbackId
                                         code:OK];
        }
    };
}

- (void)getChainTag:(NSString *)requestId
  completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    NSDictionary *dict1 = [WalletTools packageWithRequestId:requestId
                                                      data:[WalletUserDefaultManager getBlockUrl]
                                                      code:OK
                                                   message:@""];
    completionHandler([dict1 yy_modelToJSONString]);
}


@end
