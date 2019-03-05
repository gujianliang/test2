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

- (void)web3VETTransferWithParamModel:(WalletSignParamModel *)paramModel
                            requestId:(NSString *)requestId
                              webView:(WKWebView *)webView
                           callbackId:(NSString *)callbackId
{
    if (![WalletTools errorAddressAlert:paramModel.toAddress] ||
        ![WalletTools fromISToAddress:paramModel.fromAddress to:paramModel.toAddress] ||
        !(paramModel.gas.integerValue > 0)) {
        
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView 
                                     data:@""
                               callbackId:callbackId
                                     code:ERROR_REQUEST_PARAMS];
        
        return;
    }
    
    [self showSignView:WalletVETTransferType paramModel:paramModel requestId:requestId webView:webView callbackId:callbackId];
    
}

- (void)web3VTHOTransferWithParamModel:(WalletSignParamModel *)paramModel
                             requestId:(NSString *)requestId
                               webView:(WKWebView *)webView
                            callbackId:(NSString *)callbackId

{
    WalletGetSymbolApi *getSymbolApi = [[WalletGetSymbolApi alloc]initWithTokenAddress:paramModel.tokenAddress];
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
   
        [self getTokenSymoblWithParamModel:paramModel webView:webView callbackId:callbackId symobl:symobl requestId:requestId];
            
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView 
                                     data:@""
                               callbackId:callbackId
                                     code:ERROR_SERVER_DATA];
    }];
}

- (void)getTokenSymoblWithParamModel:(WalletSignParamModel *)paramModel
                             webView:(WKWebView *)webView
                          callbackId:(NSString *)callbackId
                              symobl:(NSString *)symobl
                           requestId:(NSString *)requestId
{
    NSString *clauseString = [paramModel.clauseData stringByReplacingOccurrencesOfString:TransferMethodId withString:@""];
    NSString *tokenAmount = @"";
    if (paramModel.clauseData.length >= 128) {
        tokenAmount = [clauseString substringWithRange:NSMakeRange(64, 64)];
    }
    
    if (![WalletTools errorAddressAlert:paramModel.toAddress]||
        ![WalletTools fromISToAddress:paramModel.fromAddress to:paramModel.toAddress]||
        paramModel.gas.integerValue == 0||
        paramModel.clauseData.length == 0) {
        
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_REQUEST_PARAMS];
        return;
    }
    
    [self showSignView:WalletTokenTransferType paramModel:paramModel requestId:requestId webView:webView callbackId:callbackId];
    
}

- (void)web3contractSignWithParamModel:(WalletSignParamModel *)paramModel
                             requestId:(NSString *)requestId
                               webView:(WKWebView *)webView
                            callbackId:(NSString *)callbackId
{
    if (paramModel.clauseData.length == 0 ||
        !(paramModel.gas.integerValue > 0)) {
        
        [WalletTools callbackWithrequestId:requestId
                                  webView:webView 
                                     data:@""
                               callbackId:callbackId
                                     code:ERROR_REQUEST_PARAMS];
        
        return;
    }

    [self showSignView:WalletContranctTransferType paramModel:paramModel requestId:requestId webView:webView callbackId:callbackId];
    
}

- (void)showSignView:(WalletTransferType)transferType paramModel:(WalletSignParamModel *)paramModel requestId:(NSString *)requestId webView:(WKWebView *)webView callbackId:(NSString *)callbackId
{
    WalletSignatureView *signatureView = [[WalletSignatureView alloc] initWithFrame:[WalletTools getCurrentVC].view.bounds];
    signatureView.tag = SignViewTag;
    signatureView.transferType = WalletTokenTransferType;
    
    [signatureView updateViewParamModel:paramModel];
    
    [[WalletTools getCurrentVC].navigationController.view addSubview:signatureView];
    
    signatureView.transferBlock = ^(NSString * _Nonnull txid) {
        NSLog(@"txid = %@",txid);
        if (txid.length != 0) {
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:txid
                                    callbackId:callbackId
                                          code:OK];
        }else{
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:@""
                                    callbackId:callbackId
                                          code:ERROR_SERVER_DATA];
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
