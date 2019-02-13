//
//  WalletDAppHandle.m
//  VeWallet
//
//  Created by 曾新 on 2019/1/11.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletDAppHandle.h"
#import <WebKit/WebKit.h>
#import "NSJSONSerialization+NilDataParameter.h"
#import "YYModel.h"
#import "WalletBlockInfoApi.h"
#import "WalletVETBalanceApi.h"
#import "WalletSignatureView.h"
#import "WalletGetSymbolApi.h"
#import "WalletGetDecimalsApi.h"
#import "WalletGenesisBlockInfoApi.h"
#import "WalletAccountCodeApi.h"
#import "WalletBlockApi.h"
#import "WalletTransantionsReceiptApi.h"
#import "WalletDappStoreSelectView.h"
#import "WalletDAppHead.h"
#import "WalletDAppHandle+web3JS.h"
#import "WalletDAppHandle+connexJS.h"
#import "NSJSONSerialization+NilDataParameter.h"
#import "WalletDAppPeersApi.h"
#import "WalletDAppTransferDetailApi.h"
#import "WalletSingletonHandle.h"

@interface WalletDAppHandle ()<WKNavigationDelegate,WKUIDelegate>
{
    WKWebView *_webView;
    NSMutableArray *_walletList;
}
@end

@implementation WalletDAppHandle

-(instancetype)initWithWalletDict:(NSMutableArray *)walletList
{
    self = [super init];
    if (self) {
        _walletList = walletList;
        
        WalletSingletonHandle *walletSignlet = [WalletSingletonHandle shareWalletHandle];
        [walletSignlet addWallet:_walletList];
    }
    return self;
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    NSLog(@"defaultText == %@",defaultText);
    
    NSString *result = [defaultText stringByReplacingOccurrencesOfString:@"wallet://" withString:@""];
    NSDictionary *dict = [NSJSONSerialization dictionaryWithJsonString:result];
    
    NSString *callbackId = dict[@"callbackId"];
    NSString *requestId  = dict[@"requestId"];
    NSString *method     = dict[@"method"];
    NSDictionary *callbackParams  = dict[@"params"];
    
    if ([method isEqualToString:@"getStatus"]) {

        [self getStatusWithRequestId:requestId completionHandler:completionHandler];
        return;

    }else if ([method isEqualToString:@"getGenesisBlock"])
    {
        [self getGenesisBlockWithRequestId:requestId completionHandler:completionHandler];
        return;
    }else if ([method isEqualToString:@"getAccount"]){

        [self getAccountRequestId:requestId webView:webView address:callbackParams[@"address"] callbackId:callbackId];

    }else if([method isEqualToString:@"getAccountCode"])
    {
        [self getAccountCode:callbackId
                     webView:webView
                   requestId:requestId
                     address:callbackParams[@"address"]];

    }else if([method isEqualToString:@"getBlock"])
    {
        [self getBlock:callbackId
               webView:webView
             requestId:requestId
              revision:callbackParams[@"revision"]];

    }else if([method isEqualToString:@"getTransaction"])
    {
        [self getTransaction:callbackId
                     webView:webView
                   requestId:requestId
                        txID:callbackParams[@"id"]];
    }
    else if([method isEqualToString:@"getTransactionReceipt"])
    {
        [self getTransactionReceipt:callbackId
                            webView:webView
                          requestId:requestId
                               txid:callbackParams[@"id"]];
    }
    else if([method isEqualToString:@"methodAsClause"])
    {
        [self methodAsClauseWithDictP:callbackParams
                            requestId:requestId
                    completionHandler:completionHandler];
        return;
        
    }else if ([method isEqualToString:@"getAccounts"])
    {
        [self getAccountsWithRequestId:requestId callbackId:callbackId webView:webView];
        
    }
    else if([method isEqualToString:@"sign"])
    {
        [self connexCallbackParams:callbackParams
                         requestId:requestId
                        callbackId:callbackId
                 completionHandler:completionHandler];
        
    }else if ([method isEqualToString:@"getAddress"] ) {
        
        [self getAddress:webView callbackId:callbackId];
        
    }else if ([method isEqualToString:@"getBalance"]){
        
        [self getBalance:callbackId
                 webView:webView
               requestId:requestId
                 address:callbackParams[@"address"]];
        
    }else if([method isEqualToString:@"getChainTag"]){
      
        [self getChainTag:requestId completionHandler:completionHandler];
        return;
    }else if ([method isEqualToString:@"send"]){
        
        [self web3CallbackParams:callbackParams
                       requestId:requestId
                      callbackId:callbackId
               completionHandler:completionHandler];
    }
    completionHandler(@"{}");
}

- (void)web3CallbackParams:(NSDictionary *)callbackParams
                 requestId:(NSString *)requestId
                callbackId:(NSString *)callbackId
         completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    if ([[WalletTools getCurrentVC].navigationController.view viewWithTag:SelectWalletTag]) {
        completionHandler(@"{}");
        return;
    }
    __block NSString *to = callbackParams[@"to"];
    __block NSString *amount = callbackParams[@"value"];
    NSString *cluseData = callbackParams[@"data"];
    __block NSString *tokenAddress;
    NSString *gas = [BigNumber bigNumberWithHexString:callbackParams[@"gas"]].decimalString;
    
    NSString *gasPrice = callbackParams[@"gasPrice"];
    if (gasPrice.length == 0) {
        gasPrice = @"0x78";
    }
    
    CGFloat amountTnteger = [BigNumber bigNumberWithHexString:[NSString stringWithFormat:@"%@",amount]].decimalString.floatValue/pow(10, 18);
    
    WalletDappStoreSelectView *selcetView = [[WalletDappStoreSelectView alloc]initWithFrame:[WalletTools getCurrentVC].view.frame ];
    selcetView.tag = SelectWalletTag;
    selcetView.amount = [NSString stringWithFormat:@"%lf",amountTnteger];
    [[WalletTools getCurrentVC].navigationController.view addSubview:selcetView];
    selcetView.block = ^(NSString *from,WalletDappStoreSelectView *viewSelf){
        
        [viewSelf removeFromSuperview];
        
        WalletSignatureView *signatureView = [[WalletSignatureView alloc] initWithFrame:[WalletTools getCurrentVC].view.bounds];
        if (cluseData.length < 3) { // vet 转账clauseData == nil,
            signatureView.transferType = JSVETTransferType;
        }else if ([cluseData hasPrefix:transferMethodId]) {// vtho 转账
            tokenAddress = callbackParams[@"to"];
            NSString *cluseData1 = [cluseData stringByReplacingOccurrencesOfString:transferMethodId withString:@""];
            NSString *first = [cluseData1 substringToIndex:64];
            to = [@"0x" stringByAppendingString: [first substringFromIndex:24]];
            amount = [cluseData1 substringFromIndex:65];
            signatureView.transferType = JSVTHOTransferType;
        }else{
            signatureView.transferType = JSContranctTransferType;
        }
        
        BigNumber *gasBig = [BigNumber bigNumberWithDecimalString:gas];
        NSString *gasPriceDecimal = [BigNumber bigNumberWithHexString:gasPrice].decimalString;
        BigNumber *gasCanUse = [[[[BigNumber bigNumberWithDecimalString:@"1000000000000000"] mul:[BigNumber bigNumberWithInteger:(1+gasPriceDecimal.integerValue/255.0)*1000000]] mul:gasBig] div:[BigNumber bigNumberWithDecimalString:@"1000000"]];
        
        [self web3TransferWithClauseData:cluseData
                                    from:from
                                      to:to
                               requestId:requestId
                                     gas:gas
                                 webView:_webView
                              callbackId:callbackId
                                  amount:amount
                               gasCanUse:gasCanUse
                           signatureView:signatureView
                                gasPrice:gasPrice
                            tokenAddress:tokenAddress];
    };
}

- (void)connexCallbackParams:(NSDictionary *)callbackParams
                  requestId:(NSString *)requestId
                 callbackId:(NSString *)callbackId
          completionHandler:(void (^)(NSString * __nullable result))completionHandler

{
    NSArray *clausesList = callbackParams[@"clauses"][0];
    if (clausesList.count == 0) {
        completionHandler(@"{}");
        return;
    }
    
    NSString *to = callbackParams[@"clauses"][0][@"to"];
    NSString *amount = callbackParams[@"clauses"][0][@"value"];
    NSString *clauseData = callbackParams[@"clauses"][0][@"data"];
    NSNumber *gas =  callbackParams[@"options"][@"gas"];
    
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValueIfNotNil:@(0) forKey:@"isICO"];
    
    BigNumber *gasBig = [BigNumber bigNumberWithNumber:gas];
    
    BigNumber *gasCanUse = [[[[BigNumber bigNumberWithDecimalString:@"1000000000000000"] mul:[BigNumber bigNumberWithInteger:(1 + 120/255.0)*1000000]] mul:gasBig] div:[BigNumber bigNumberWithDecimalString:@"1000000"]];
    
    NSString *miner = [[Payment formatEther:gasCanUse options:2] stringByAppendingString:@" VTHO"];
    
    [dictParam setValueIfNotNil:miner forKey:@"miner"];
    [dictParam setValueIfNotNil:[BigNumber bigNumberWithInteger:120] forKey:@"gasPriceCoef"];
    [dictParam setValueIfNotNil:gas forKey:@"gas"];
    [dictParam setValueIfNotNil:to forKey:@"to"];
    [dictParam setValueIfNotNil:amount forKey:@"amount"];
    
    NSData *secureData = [SecureData hexStringToData:clauseData];
    [dictParam setValueIfNotNil:secureData forKey:@"clouseData"];
    
    CGFloat amountTnteger = [BigNumber bigNumberWithHexString:[NSString stringWithFormat:@"%@",amount]].decimalString.floatValue/pow(10, 18);
    
    WalletDappStoreSelectView *selcetView = [[WalletDappStoreSelectView alloc]initWithFrame:[WalletTools getCurrentVC].view.frame ];
    selcetView.tag = SelectWalletTag;
    selcetView.amount = [NSString stringWithFormat:@"%lf",amountTnteger];
    [[WalletTools getCurrentVC].navigationController.view addSubview:selcetView];
    selcetView.block = ^(NSString *from,WalletDappStoreSelectView *viewSelf){
        
        [viewSelf removeFromSuperview];
        
        [dictParam setValueIfNotNil:from forKey:@"from"];
        
        [self connexTransferWithClauseData:clauseData
                                 dictParam:dictParam
                                      from:from
                                        to:to
                                 requestId:requestId
                                       gas:gas
                                   webView:_webView
                                callbackId:callbackId
                                    amount:amount
                                 gasCanUse:gasCanUse];
    };
}

- (void)connexTransferWithClauseData:(NSString *)clauseData
                         dictParam:(NSMutableDictionary *)dictParam
                              from:(NSString *)from
                                to:(NSString *)to
                         requestId:(NSString *)requestId
                               gas:(NSNumber *)gas
                           webView:(WKWebView *)webView
                        callbackId:(NSString *)callbackId
                            amount:(NSString *)amount
                         gasCanUse:(BigNumber *)gasCanUse
{
    if (clauseData.length < 3) { // vet 转账clauseData == nil,
        CGFloat amountTnteger = [BigNumber bigNumberWithDecimalString:amount].decimalString.floatValue/pow(10, 18);
        [self VETTransferDictParam:dictParam
                              from:from
                                to:to
                     amountTnteger:amountTnteger
                         requestId:requestId
                               gas:gas
                           webView:webView
                        callbackId:callbackId];
        
    }else{
        if ([clauseData hasPrefix:transferMethodId]) { // token 转账
            
            [self VTHOTransferDictParam:dictParam
                                   from:from
                                     to:to
                              requestId:requestId
                                    gas:gas
                                webView:webView
                             callbackId:callbackId
                              gasCanUse:gasCanUse
                             clauseData:clauseData];
            
        }else{ // 其他合约交易
            CGFloat amountTnteger = [BigNumber bigNumberWithDecimalString:amount].decimalString.floatValue/pow(10, 18);
            [self contractSignDictParam:dictParam
                                     to:to
                                   from:from
                          amountTnteger:amountTnteger
                              requestId:requestId
                                    gas:gas
                                webView:webView
                             callbackId:callbackId
                             clauseData:clauseData];
        }
    }
}

-(void)web3TransferWithClauseData:(NSString *)cluseData
                               from:(NSString *)from
                                 to:(NSString *)to
                          requestId:(NSString *)requestId
                                gas:(NSString *)gas
                            webView:(WKWebView *)webView
                         callbackId:(NSString *)callbackId
                             amount:(NSString *)amount
                          gasCanUse:(BigNumber *)gasCanUse
                      signatureView:(WalletSignatureView *)signatureView
                           gasPrice:(NSString *)gasPrice
                       tokenAddress:(NSString *)tokenAddress
{
    UIView *conventView = [[WalletTools getCurrentVC].navigationController.view viewWithTag:SignViewTag];
    if (conventView) {
        return;
    }
    signatureView.tag = SignViewTag;
    if (cluseData.length > 3) {
        if (![cluseData hasPrefix:transferMethodId]) { // 签合约
            [self WEB3contractSign:signatureView
                                to:to
                             from:from
                            amount:amount
                         requestId:requestId
                               gas:gas
                          gasPrice:gasPrice
                         gasCanUse:(BigNumber *)gasCanUse
                           webView:webView
                        callbackId:callbackId
                         cluseData:cluseData];
        }else{
            //vtho 转账
            [self WEB3VTHOTransfer:signatureView
                              from:from
                                to:to
                            amount:amount
                         requestId:requestId
                               gas:gas
                          gasPrice:gasPrice
                           webView:webView
                        callbackId:callbackId
                         gasCanUse:gasCanUse
                         cluseData:cluseData
                      tokenAddress:tokenAddress];
        }
    }else{
        // VET 转账
        [self WEB3VETTransferFrom:from
                                to:to
                            amount:amount
                         requestId:requestId
                               gas:gas
                           webView:webView
                        callbackId:callbackId
                         gasCanUse:gasCanUse
                          gasPrice:gasPrice];
    }
}


- (void)injectJS:(WKWebView *)webview
{
    [WalletUserDefaultManager setServerType:TEST_SERVER];
    
    //connex
    NSString *js = connex_js;
    [webview evaluateJavaScript:js completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"inject error == %@",error);
    }];
    
    //web3
    NSString *web3js = web3_js;
    [webview evaluateJavaScript:web3js completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"web3js error == %@",error);
    }];
}

@end
