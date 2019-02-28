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
                 clauseData:(NSString *)clauseData
{
    NSString *amountStr = [BigNumber bigNumberWithHexString:amount].decimalString;
    CGFloat amountTnteger = amountStr.floatValue/pow(10,18);
    if (![WalletTools errorAddressAlert:to] ||
        ![WalletTools fromISToAddress:from to:to] ||
        !(gas.integerValue > 0)) {
        
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView 
                                     data:@""
                               callbackId:callbackId
                                     code:ERROR_REQUEST_PARAMS];
        
        return;
    }
    
    WalletSignatureView *signatureView = [[WalletSignatureView alloc] initWithFrame:[WalletTools getCurrentVC].view.bounds];
    signatureView.tag = SignViewTag;
    signatureView.transferType = JSVETTransferType;
    
    WalletSignParamModel *signParamModel = [[WalletSignParamModel alloc]init];
    
    signParamModel.toAddress    = to;
    signParamModel.fromAddress  = from;
    signParamModel.gasPriceCoef = [BigNumber bigNumberWithHexString:gasPrice];;
    signParamModel.gas          = gas;
    signParamModel.amount       = amount;
    signParamModel.clauseData   = clauseData ;
    
    [signatureView updateViewParamModel:signParamModel];
    [[WalletTools getCurrentVC].navigationController.view addSubview:signatureView];
    
    signatureView.transferBlock = ^(NSString * _Nonnull txid) {
        NSLog(@"txid = %@",txid);
        
        if (txid.length == 0) {
            
            
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
          clauseStr:(NSString *)clauseStr
        tokenAddress:(NSString *)tokenAddress
{
    __block NSString *symobl = @"";
    
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
   
        [self getTokenSymobl:tokenAddress requestId:requestId webView:webView callbackId:callbackId clauseStr:clauseStr symobl:symobl to:to from:from gas:gas symobl:symobl gasPrice:gasPrice];
            
        
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
             clauseStr:(NSString *)clauseStr
                symobl:(NSString *)symobl
                    to:(NSString *)to
                  from:(NSString *)from
                   gas:(NSString *)gas
              symobl:(NSString *)symobl
              gasPrice:(NSString *)gasPrice
{
    
    [self enterVTHOTransferViewCluseData:clauseStr
                                      to:to
                                    from:from
                                     gas:gas
                               requestId:requestId
                                 webView:webView
                              callbackId:callbackId
                            tokenAddress:tokenAddress
                                gasPrice:gasPrice
     ];
    return;
    
   
}

- (void)enterVTHOTransferViewCluseData:(NSString *)clauseStr  to:(NSString *)to from:(NSString *)from gas:(NSString *)gas requestId:(NSString *)requestId webView:(WKWebView *)webView callbackId:(NSString *)callbackId  tokenAddress:(NSString *)tokenAddress gasPrice:(NSString *)gasPrice
{
    NSString *cluseStr = [clauseStr stringByReplacingOccurrencesOfString:TransferMethodId withString:@""];
    NSString *tokenAmount = @"";
    if (cluseStr.length >= 128) {
        tokenAmount = [cluseStr substringWithRange:NSMakeRange(64, 64)];
    }
    
#warning 非vet 不能转0
    if (![WalletTools errorAddressAlert:to]||
        ![WalletTools fromISToAddress:from to:to]||
        !(gas.integerValue > 0)||
        clauseStr.length == 0) {
        
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_REQUEST_PARAMS];
        return;
    }
    
    WalletSignatureView *signatureView = [[WalletSignatureView alloc] initWithFrame:[WalletTools getCurrentVC].view.bounds];
    signatureView.tag = SignViewTag;
    signatureView.transferType = JSTokenTransferType;
    
    WalletSignParamModel *signParamModel = [[WalletSignParamModel alloc]init];
    
    signParamModel.toAddress    = to;
    signParamModel.fromAddress  = from;
    signParamModel.gasPriceCoef = [BigNumber bigNumberWithHexString:gasPrice];;
    signParamModel.gas          = gas;
    signParamModel.amount       = tokenAmount;
    signParamModel.clauseData   = clauseStr ;
    signParamModel.tokenAddress = tokenAddress ;
    
    [[WalletTools getCurrentVC].navigationController.view addSubview:signatureView];
    
    signatureView.transferBlock = ^(NSString * _Nonnull txid) {
        NSLog(@"txid = %@",txid);
        if (txid.length == 0) {
           
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
               clauseStr:(NSString *)clauseStr
{
    if (clauseStr.length == 0 ||
        !(gas.integerValue > 0)) {
        
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView 
                                     data:@""
                               callbackId:callbackId
                                     code:ERROR_REQUEST_PARAMS];
        
        return;
    }
   

    WalletSignatureView *signatureView = [[WalletSignatureView alloc] initWithFrame:[WalletTools getCurrentVC].view.bounds];
    signatureView.tag = SignViewTag;
    signatureView.transferType = JSContranctTransferType;
    
    WalletSignParamModel *signParamModel = [[WalletSignParamModel alloc]init];
   
#warning to
    signParamModel.toAddress    = to;
    signParamModel.fromAddress  = from;
    signParamModel.gasPriceCoef = [BigNumber bigNumberWithHexString:gasPrice];;
    signParamModel.gas          = gas;
    signParamModel.amount       = amount;
    signParamModel.clauseData   = clauseStr ;
#warning 地址是不是空的
//    signParamModel.tokenAddress = tokenAddress ;
    [signatureView updateViewParamModel:signParamModel];
    
    [[WalletTools getCurrentVC].navigationController.view addSubview:signatureView];
    signatureView.transferBlock = ^(NSString * _Nonnull txid) {
        NSLog(@"txid = %@",txid);
        if (txid.length == 0) {
            
            
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
