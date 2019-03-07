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
#import "WalletJSCallbackModel.h"
#import "WalletGetBaseGasPriceApi.h"
#import "WalletSignatureView.h"
#import "SocketRocketUtility.h"


@interface WalletDAppHandle ()<WKNavigationDelegate,WKUIDelegate>
{
    WKWebView *_webView;
    NSMutableArray *_walletList;
}
@end

@implementation WalletDAppHandle

static WalletDAppHandle *singleton = nil;
static dispatch_once_t predicate;

+ (instancetype)shareWalletHandle
{
    dispatch_once(&predicate, ^{
        singleton = [[self alloc] init];
        
    });
    return singleton;
}

-(void)initWithWalletDict:(NSMutableArray *)walletList
{
    _walletList = walletList;
    
    WalletSingletonHandle *walletSignlet = [WalletSingletonHandle shareWalletHandle];
    [walletSignlet addWallet:_walletList];
    
    [WalletTools checkNetwork:^(BOOL t) {
        NSLog(@"dd");
    }];
}

- (void)webView:(WKWebView *)webView defaultText:(nullable NSString *)defaultText completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    NSLog(@"defaultText == %@",defaultText);
    
    NSString *result = [defaultText stringByReplacingOccurrencesOfString:@"wallet://" withString:@""];
    NSDictionary *dict = [NSJSONSerialization dictionaryWithJsonString:result];
    
    WalletJSCallbackModel *callbackModel = [WalletJSCallbackModel yy_modelWithDictionary:dict];
    
    NSString *callbackId = callbackModel.callbackId;
    NSString *requestId  = callbackModel.requestId;
    NSString *method     = callbackModel.method;
    NSDictionary *callbackParams  = callbackModel.params;
    
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
        
    }else if ([method isEqualToString:@"tickerNext"])
    {
        NSString *url = [[WalletUserDefaultManager getBlockUrl] stringByAppendingString:@"/subscriptions/block"];
        [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:url];
    }
    else if([method isEqualToString:@"sign"])
    {
        [self connexCallbackParams:callbackParams
                         requestId:requestId
                        callbackId:callbackId
                 completionHandler:completionHandler];
        
    }else if ([method isEqualToString:@"getAddress"] ) {
        
        [self getAddress:webView requestId:requestId callbackId:callbackId];
        
    }else if ([method isEqualToString:@"getBalance"]){
        
        [self getBalance:callbackId
                 webView:webView
               requestId:requestId
                 address:callbackParams[@"address"]];
        
    }else if ([method isEqualToString:@"getChainTag"]){
        [self getChainTag:requestId completionHandler:completionHandler];
        return;
    }else if([method isEqualToString:@"getNodeUrl"]){
      
        [self getNodeUrl:requestId completionHandler:completionHandler];
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
        return;
    }
     BOOL bCert = NO;
//    NSString *kind = callbackParams[@"kind"];
    
    //    if ([kind isEqualToString:@"cert"]) {
    //        callbackParams = [NSMutableDictionary dictionaryWithDictionary:callbackParams[@"clauses"]];
    //        bCert = YES;
    //
    //    }else
    
    __block NSString *to     = callbackParams[@"to"];
    __block NSString *amount = callbackParams[@"value"];
    NSString *clauseStr      = callbackParams[@"data"];
    NSString *gas      = callbackParams[@"gas"];
    __block NSString *tokenAddress;
    
    NSString *gasPrice = callbackParams[@"gasPrice"];
  
    [self initParamGasPrice:&gasPrice gas:&gas amount:&amount to:&to clauseStr:&clauseStr];
    
    CGFloat amountFloat = 0;
    
    WalletTransferType transferType = WalletVETTransferType;
    
    if (clauseStr.length < 10) { // vet 转账clauseStr == nil,
        
        transferType = WalletVETTransferType;
        if (![self checkAmountForm:amount amountFloat:&amountFloat requestId:requestId webView:_webView callbackId:callbackId]) {
            
            [self paramsError:requestId callbackId:callbackId];

            return;
        }
        
        if (![WalletTools errorAddressAlert:to]
            ||![WalletTools checkDecimalStr:gas]
            ||![WalletTools checkHEXStr:gasPrice]) {
            
            [self paramsError:requestId callbackId:callbackId];
            
            return;
        }
        
    }else{
        if ([clauseStr hasPrefix:TransferMethodId]) { // token 转账
            transferType = WalletTokenTransferType;
            tokenAddress = to;
            amount = [WalletTools getAmountFromClause:clauseStr to:&to];
            
            if (![WalletTools errorAddressAlert:to]
                || ![WalletTools errorAddressAlert:tokenAddress]
                || [tokenAddress isKindOfClass:[NSNull class]]
                || ![self checkClauseDataFormat:clauseStr toAddress:to]
                || ![WalletTools checkDecimalStr:gas]
                || ![WalletTools checkHEXStr:gasPrice]
                ) {
                
                [self paramsError:requestId callbackId:callbackId];
                
                return;
            }
            
        }else{ // 其他合约交易
            transferType = WalletContranctTransferType;
            if (![self checkAmountForm:amount amountFloat:&amountFloat requestId:requestId webView:_webView callbackId:callbackId]) {
                
                [self paramsError:requestId callbackId:callbackId];

                return;
            }
            tokenAddress = to;
            NSData *newclouseData = [SecureData hexStringToData:clauseStr];
            if (clauseStr.length == 0 ||
                !(gas.integerValue > 0) ||
                newclouseData == nil ||
                ![WalletTools errorAddressAlert:to] ||
                ![self checkClauseDataFormat:clauseStr toAddress:to]
                ||![WalletTools checkDecimalStr:gas]
                ||![WalletTools checkHEXStr:gasPrice]) {
                
                [self paramsError:requestId callbackId:callbackId];
                
                return;
            }
        }
    }
    
    WalletDappStoreSelectView *selectView = [[WalletDappStoreSelectView alloc]initWithFrame:[WalletTools getCurrentVC].view.frame ];
    selectView.tag = SelectWalletTag;
    selectView.toAddress = to;
    selectView.amount = [NSString stringWithFormat:@"%lf",amountFloat];
    [[WalletTools getCurrentVC].navigationController.view addSubview:selectView];
    selectView.block = ^(NSString *from,WalletDappStoreSelectView *viewSelf){
        
        [viewSelf removeFromSuperview];
        
        WalletSignParamModel *signParamModel = [[WalletSignParamModel alloc]init];
        
        signParamModel.toAddress    = to;
        signParamModel.fromAddress  = from;
        signParamModel.gasPriceCoef = [BigNumber bigNumberWithHexString:gasPrice];;
        signParamModel.gas          = [NSString stringWithFormat:@"%@",gas];
        signParamModel.amount       = amount;
        signParamModel.clauseData   = clauseStr ;
        signParamModel.tokenAddress = tokenAddress ;
        
        [self transferWithParamModel:signParamModel
                           requestId:requestId
                             webView:_webView
                          callbackId:callbackId
                               bCert:bCert
                        transferType:transferType];
    };
}

- (void)connexCallbackParams:(NSDictionary *)callbackParams
                  requestId:(NSString *)requestId
                 callbackId:(NSString *)callbackId
          completionHandler:(void (^)(NSString * __nullable result))completionHandler

{
    if ([[WalletTools getCurrentVC].navigationController.view viewWithTag:SelectWalletTag]) {

        return;
    }
    
    NSString *kind = callbackParams[@"kind"];
    BOOL bCert = NO;
    
//    if ([kind isEqualToString:@"cert"]) {
//        callbackParams = [NSMutableDictionary dictionaryWithDictionary:callbackParams[@"clauses"]];
//        bCert = YES;
//
//    }else
    
    if(![kind isEqualToString:@"tx"]){
        
        [self paramsError:requestId callbackId:callbackId];
        return;
    }
    
    NSDictionary *clausesDict = callbackParams[@"clauses"][0];
    if (clausesDict == nil) {
        completionHandler(@"{}");
        return;
    }
    
    NSString *to         = clausesDict[@"to"];
    NSString *amount     = clausesDict[@"value"];
    NSString *clauseStr  = clausesDict[@"data"];
    NSString *gas        = callbackParams[@"options"][@"gas"];
    NSString *gasPrice   = callbackParams[@"options"][@"gasPrice"];
    NSString *tokenAddress = @"";
    
    [self initParamGasPrice:&gasPrice gas:&gas amount:&amount to:&to clauseStr:&clauseStr];
    
    CGFloat amountFloat = 0;
    WalletTransferType transferType = WalletVETTransferType;
    if (clauseStr.length < 10) { // vet 转账clauseStr == nil,
        
        transferType = WalletVETTransferType;
        if (![self checkAmountForm:amount amountFloat:&amountFloat requestId:requestId webView:_webView callbackId:callbackId]
            ||![WalletTools checkDecimalStr:gas]
            ||![WalletTools checkHEXStr:gasPrice]
            ||![WalletTools errorAddressAlert:to]) {
            
            [self paramsError:requestId callbackId:callbackId];
            
            return;
        }
        
        
    }else{
        if ([clauseStr hasPrefix:TransferMethodId]) { // token 转账
            tokenAddress = to;
            transferType = WalletTokenTransferType;
            amount = [WalletTools getAmountFromClause:clauseStr to:&to];
            
            if (![WalletTools errorAddressAlert:to]
                || ![WalletTools errorAddressAlert:tokenAddress]
                || [tokenAddress isKindOfClass:[NSNull class]]
                || ![self checkClauseDataFormat:clauseStr toAddress:to]
                ||![WalletTools checkDecimalStr:gas]
                ||![WalletTools checkHEXStr:gasPrice]) {
                
                [self paramsError:requestId callbackId:callbackId];
                
                return;
            }
            
        }else{ // 其他合约交易

            if (![self checkAmountForm:amount amountFloat:&amountFloat requestId:requestId webView:_webView callbackId:callbackId]
                ||![WalletTools checkDecimalStr:gas]
                ||![WalletTools checkHEXStr:gasPrice]) {
                
                [self paramsError:requestId callbackId:callbackId];

                return;
            }
            transferType = WalletContranctTransferType;

            tokenAddress = to;
            NSData *newclouseData = [SecureData hexStringToData:clauseStr];
            if (clauseStr.length == 0 ||
                !(gas.integerValue > 0) ||
                newclouseData == nil ||
                ![WalletTools errorAddressAlert:to] ||
                ![self checkClauseDataFormat:clauseStr toAddress:to]) {
                
                [self paramsError:requestId callbackId:callbackId];

                return;
            }
        }
    }
    
    WalletDappStoreSelectView *selectView = [[WalletDappStoreSelectView alloc]initWithFrame:[WalletTools getCurrentVC].view.frame ];
    selectView.tag = SelectWalletTag;
    selectView.toAddress = to;
    selectView.amount = [NSString stringWithFormat:@"%lf",amountFloat];
    [[WalletTools getCurrentVC].navigationController.view addSubview:selectView];
    selectView.block = ^(NSString *from,WalletDappStoreSelectView *viewSelf){
        
        [viewSelf removeFromSuperview];
        
        WalletSignParamModel *signParamModel = [[WalletSignParamModel alloc]init];
        
        signParamModel.toAddress    = to;
        signParamModel.fromAddress  = from;
        signParamModel.gasPriceCoef = [BigNumber bigNumberWithHexString:gasPrice];;
        signParamModel.gas          = [NSString stringWithFormat:@"%@",gas];
        signParamModel.amount       = amount;
        signParamModel.clauseData   = clauseStr ;
        signParamModel.tokenAddress = tokenAddress ;
        
        [self transferWithParamModel:signParamModel
                           requestId:requestId
                             webView:_webView
                          callbackId:callbackId
                               bCert:bCert
                        transferType:transferType];
    };
}


-(void)transferWithParamModel:(WalletSignParamModel *)paramModel
                    requestId:(NSString *)requestId
                      webView:(WKWebView *)webView
                   callbackId:(NSString *)callbackId
                        bCert:(BOOL)bCert
                 transferType:(WalletTransferType)transferType

{
    UIView *conventView = [[WalletTools getCurrentVC].navigationController.view viewWithTag:SignViewTag];
    if (conventView) {
        return;
    }
    if (bCert) {
        
        //        [self certTransferDictParam:dictParam
        //                               from:from
        //                          requestId:requestId
        //                            webView:webView
        //                         callbackId:callbackId];
        
    }else if (paramModel.clauseData.length > 10) {
        if (![paramModel.clauseData hasPrefix:TransferMethodId]) { // 合约
            
           [self contractSignWithParamModel:paramModel requestId:requestId webView:_webView callbackId:callbackId];
           
        }else{
            //vtho 转账
            [self VTHOTransferWithParamModel:paramModel requestId:requestId webView:webView callbackId:callbackId];
        }
    }else{
        // VET 转账
        [self VETTransferDictWithParamModel:paramModel requestId:requestId webView:webView callbackId:callbackId];
    }
}


- (void)injectJS:(WKWebView *)webview 
{
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

- (void)initParamGasPrice:(NSString **)gasPrice gas:(NSString **)gas amount:(NSString **)amount to:(NSString **)to clauseStr:(NSString **)clauseStr
{
    if ([*gasPrice isKindOfClass:[NSNull class]]) {
        *gasPrice = DefaultGasPriceCoef;
    }else if ((*gasPrice).integerValue == 0) {
        //默认120，如果js没有返回，就给默认的
        *gasPrice = DefaultGasPriceCoef;
    }else{
        //转 16进制
        *gasPrice = [NSString stringWithFormat:@"%@",*gasPrice];
        if (![WalletTools checkHEXStr:*gasPrice]) {
           
            if ([WalletTools checkDecimalStr:*gasPrice]){
                *gasPrice = [BigNumber bigNumberWithDecimalString:*gasPrice].hexString;
                
            }else{
                *gasPrice = DefaultGasPriceCoef; //如果不符合规则，就给默认的
            }
        }
    }
    
    if ([*gas isKindOfClass:[NSNull class]]) {
        *gas = nil;
    }else {
        //转 10进制
        *gas = [NSString stringWithFormat:@"%@",*gas];
       
        if (![WalletTools checkDecimalStr:*gas]) {
            
            if ([WalletTools checkHEXStr:*gas]){
                
                *gas = [BigNumber bigNumberWithHexString:*gas].decimalString;
            }
        }
    }
    
    if ([*amount isKindOfClass:[NSNull class]]) {
        *amount = @"0";
    }else if((*amount).length == 0){
        *amount = @"0";
    }
    
    if ([*clauseStr isKindOfClass:[NSNull class]]) {
        *clauseStr = nil;
    }
    
    if ([*to isKindOfClass:[NSNull class]]) {
        *to = nil;
    }
}

- (BOOL)checkAmountForm:(NSString *)amount
            amountFloat:(CGFloat *)amountFloat
              requestId:(NSString *)requestId
                webView:(WKWebView *)webView
             callbackId:(NSString *)callbackId
{
    if ([amount.lowercaseString hasPrefix:@"0x"]) { // 16进制
        if ([WalletTools checkHEXStr:amount]) {
            *amountFloat = [BigNumber bigNumberWithHexString:[NSString stringWithFormat:@"%@",amount]].decimalString.doubleValue/pow(10, 18);
            return YES;
        }else{
            [self paramsError:requestId callbackId:callbackId];

            return NO;
        }
    }else { // 10进制
        if ([WalletTools checkDecimalStr:amount]) {
            *amountFloat = [BigNumber bigNumberWithDecimalString:[NSString stringWithFormat:@"%@",amount]].decimalString.doubleValue/pow(10, 18);
            return YES;
        }else{
            [self paramsError:requestId callbackId:callbackId];
            return NO;
        }
    }
}

- (BOOL)checkClauseDataFormat:(NSString *)clauseStr toAddress:(NSString *)toAddress
{
    if (toAddress.length == 0) {
        return YES;
    }
    if (clauseStr.length > 10) {
        NSString *temp1 = [clauseStr substringFromIndex:10];
        NSInteger i = temp1.length % 64;
        if (i == 0) {
            return YES;
        }
        return NO;
        
    }else{
        return NO;
    }
}

- (void)paramsError:(NSString *)requestId callbackId:(NSString *)callbackId
{
    [WalletTools callbackWithrequestId:requestId webView:_webView data:@"" callbackId:callbackId code:ERROR_REQUEST_PARAMS];
}

+(void)attempDealloc
{
    predicate = 0;
    singleton = nil;
}


@end
