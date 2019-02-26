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

@interface WalletDAppHandle ()<WKNavigationDelegate,WKUIDelegate>
{
    WKWebView *_webView;
    NSMutableArray *_walletList;
}
@end

@implementation WalletDAppHandle


+ (instancetype)shareWalletHandle
{
    static WalletDAppHandle *singleton = nil;
    static dispatch_once_t predicate;
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
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler
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
    NSString *clauseData = callbackParams[@"data"];
    __block NSString *tokenAddress;
    NSString *gas = [BigNumber bigNumberWithHexString:callbackParams[@"gas"]].decimalString;
    
    NSString *gasPrice = callbackParams[@"gasPrice"];
    if (gasPrice.length == 0) {
        //默认120，如果js没有返回，就给默认的
        gasPrice = [BigNumber bigNumberWithHexString:DefaultGasPriceCoef].hexString;
    }
    
    CGFloat amountTnteger = [BigNumber bigNumberWithHexString:[NSString stringWithFormat:@"%@",amount]].decimalString.floatValue/pow(10, 18);
    
    WalletDappStoreSelectView *selectView = [[WalletDappStoreSelectView alloc]initWithFrame:[WalletTools getCurrentVC].view.frame ];
    selectView.tag = SelectWalletTag;
    selectView.toAddress = to;
    selectView.amount = [NSString stringWithFormat:@"%lf",amountTnteger];
    [[WalletTools getCurrentVC].navigationController.view addSubview:selectView];
    selectView.block = ^(NSString *from,WalletDappStoreSelectView *viewSelf){
        
        [viewSelf removeFromSuperview];
        
        [self web3TransferWithClauseData:clauseData
                                    from:from
                                      to:to
                               requestId:requestId
                                     gas:gas
                                 webView:_webView
                              callbackId:callbackId
                                  amount:amount
                                gasPrice:gasPrice
                            tokenAddress:tokenAddress];
    };
}

- (void)connexCallbackParams:(NSDictionary *)callbackParams
                  requestId:(NSString *)requestId
                 callbackId:(NSString *)callbackId
          completionHandler:(void (^)(NSString * __nullable result))completionHandler

{
    if ([[WalletTools getCurrentVC].navigationController.view viewWithTag:SelectWalletTag]) {
        completionHandler(@"{}");
        return;
    }
    
    NSString *kind = callbackParams[@"kind"];
    BOOL bCert = NO;
    if ([kind isEqualToString:@"cert"]) {
        callbackParams = [NSMutableDictionary dictionaryWithDictionary:callbackParams[@"clauses"]];
        bCert = YES;
        
    }else if([kind isEqualToString:@"tx"]){
        
    }else{
        [WalletTools callbackWithrequestId:requestId
                                   webView:_webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_REQUEST_PARAMS];
        return;
    }
    
    NSDictionary *clausesDict = callbackParams[@"clauses"][0];
    if (clausesDict == nil) {
        completionHandler(@"{}");
        return;
    }
    
    NSString *to         = clausesDict[@"to"];
    NSString *amount     = clausesDict[@"value"];
    NSString *clauseStr = clausesDict[@"data"];
    NSNumber *gas        = callbackParams[@"options"][@"gas"];
    NSString *gasPrice   = callbackParams[@"options"][@"gasPrice"];

    
    [self checkParamGasPrice:gasPrice gas:(NSString *)gas amount:amount to:to clauseStr:clauseStr];
    
    
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    
    [dictParam setValueIfNotNil:[BigNumber bigNumberWithHexString:gasPrice] forKey:@"gasPriceCoef"];
    [dictParam setValueIfNotNil:gas forKey:@"gas"];
    [dictParam setValueIfNotNil:to forKey:@"to"];
    [dictParam setValueIfNotNil:amount forKey:@"amount"];
    
    NSData *secureData = [SecureData hexStringToData:clauseStr];
    [dictParam setValueIfNotNil:secureData forKey:@"clauseData"];
    
    
    CGFloat amountFloat = 0;
    if (clauseStr.length < 10) { // vet 转账clauseData == nil,
        
        
        if (![self checkAmountForm:amount amountFloat:amountFloat requestId:requestId webView:_webView callbackId:callbackId]) {
            return;
        }
        
        if (![self errorAddressAlert:to] ||
            ![self errorAmount:[NSString stringWithFormat:@"%lf",amountFloat] coinName:@"VET"]
            ||!(gas.integerValue > 0)) {
            
            [WalletTools callbackWithrequestId:requestId
                                       webView:_webView
                                          data:@""
                                    callbackId:callbackId
                                          code:ERROR_REQUEST_PARAMS];
            
            return;
        }
        
    }else{
        if ([clauseStr hasPrefix:TransferMethodId]) { // token 转账
            NSString *tokenAddress = to;
            NSString *clauseTemp =  [clauseStr stringByReplacingOccurrencesOfString:@"0xa9059cbb000000000000000000000000" withString:@""];
            to = [@"0x" stringByAppendingString:[clauseTemp substringToIndex:40]];
            
            [dictParam setValue:to forKey:@"to"];
            [dictParam setValue:tokenAddress forKey:@"tokenAddress"];
            
            if (![WalletTools errorAddressAlert:to]
                || ![WalletTools errorAddressAlert:tokenAddress]
                || [tokenAddress isKindOfClass:[NSNull class]]
                || ![self checkClauseForm:clauseStr]
                ) {
                
                [WalletTools callbackWithrequestId:requestId
                                           webView:_webView
                                              data:@""
                                        callbackId:callbackId
                                              code:ERROR_REQUEST_PARAMS];
                
                return;
            }
            
        }else{ // 其他合约交易
            
            if (![self checkAmountForm:amount amountFloat:amountFloat requestId:requestId webView:_webView callbackId:callbackId]) {
                return;
            }
            
            NSData *newclouseData = [SecureData hexStringToData:clauseStr];
            if (clauseStr.length == 0 ||
                !(gas.integerValue > 0) ||
                newclouseData == nil ||
                ![WalletTools errorAddressAlert:to] ||
                ![self checkClauseForm:clauseStr]) {
                
                [WalletTools callbackWithrequestId:requestId webView:_webView data:@"" callbackId:callbackId code:ERROR_REQUEST_PARAMS];
                
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
        [dictParam setValueIfNotNil:from forKey:@"from"];
        
        [self connexTransferWithClauseData:clauseStr
                                 dictParam:dictParam
                                      from:from
                                        to:to
                                 requestId:requestId
                                       gas:gas
                                   webView:_webView
                                callbackId:callbackId
                                    amount:amount
                              gasPriceCoef:gasPrice];
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
                         gasPriceCoef:(NSString *)gasPriceCoef
{
    if (clauseData.length < 10) { // vet 转账clauseData == nil,
        CGFloat amountFloat = 0;
        
        if (![self checkAmountForm:amount amountFloat:amountFloat requestId:requestId webView:_webView callbackId:callbackId]) {
            return;
        }
        
        [self VETTransferDictParam:dictParam
                              from:from
                                to:to
                     amountTnteger:amountFloat
                         requestId:requestId
                               gas:gas
                           webView:webView
                        callbackId:callbackId];
        
    }else{
        if ([clauseData hasPrefix:TransferMethodId]) { // token 转账
            NSString *tokenAddress = to;
            NSString *clauseTemp =  [clauseData stringByReplacingOccurrencesOfString:@"0xa9059cbb000000000000000000000000" withString:@""];
            NSString *toAddress = [@"0x" stringByAppendingString:[clauseTemp substringToIndex:40]];
            
            [dictParam setValue:toAddress forKey:@"to"];
            [dictParam setValue:tokenAddress forKey:@"tokenAddress"];

            [self VTHOTransferDictParam:dictParam
                                   from:from
                           tokenAddress:tokenAddress
                              toAddress:toAddress
                              requestId:requestId
                                    gas:gas
                                webView:webView
                             callbackId:callbackId
                              gasPriceCoef:gasPriceCoef
                             clauseData:clauseData];
            
        }else{ // 其他合约交易
            CGFloat amountFloat = 0;
            
            if (![self checkAmountForm:amount amountFloat:amountFloat requestId:requestId webView:_webView callbackId:callbackId]) {
                return;
            }
            [self contractSignDictParam:dictParam
                                     to:to
                                   from:from
                          amountTnteger:amountFloat
                              requestId:requestId
                                    gas:gas
                                webView:webView
                             callbackId:callbackId
                             clauseData:clauseData];
        }
    }
}

-(void)web3TransferWithClauseData:(NSString *)clauseData
                               from:(NSString *)from
                                 to:(NSString *)to
                          requestId:(NSString *)requestId
                                gas:(NSString *)gas
                            webView:(WKWebView *)webView
                         callbackId:(NSString *)callbackId
                             amount:(NSString *)amount
                           gasPrice:(NSString *)gasPrice
                       tokenAddress:(NSString *)tokenAddress
{
    UIView *conventView = [[WalletTools getCurrentVC].navigationController.view viewWithTag:SignViewTag];
    if (conventView) {
        return;
    }
    if (clauseData.length > 3) {
        if (![clauseData hasPrefix:TransferMethodId]) { // 签合约
            [self web3contractSignFrom:from
                                to:to
                            amount:amount
                         requestId:requestId
                               gas:gas
                          gasPrice:gasPrice
                           webView:webView
                        callbackId:callbackId
                         clauseData:clauseData];
        }else{
            //vtho 转账
            [self web3VTHOTransferFrom:from
                                to:to
                            amount:amount
                         requestId:requestId
                               gas:gas
                          gasPrice:gasPrice
                           webView:webView
                        callbackId:callbackId
                         clauseData:clauseData
                      tokenAddress:tokenAddress];
        }
    }else{
        // VET 转账
        [self web3VETTransferFrom:from
                                to:to
                            amount:amount
                         requestId:requestId
                               gas:gas
                           webView:webView
                        callbackId:callbackId
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

- (void)checkParamGasPrice:(NSString *)gasPrice gas:(NSString *)gas amount:(NSString *)amount to:(NSString *)to clauseStr:(NSString *)clauseStr
{
    if ([gasPrice isKindOfClass:[NSNull class]]) {
        gasPrice = DefaultGasPriceCoef;
    }else if (gasPrice.length == 0) {
        //默认120，如果js没有返回，就给默认的
        gasPrice = DefaultGasPriceCoef;
    }
    
    if ([gas isKindOfClass:[NSNull class]]) {
        gas = nil;
    }
    
    if ([amount isKindOfClass:[NSNull class]]) {
        amount = @"0";
    }else if(amount.length == 0){
        amount = @"0";
    }
    
    if ([clauseStr isKindOfClass:[NSNull class]]) {
        clauseStr = nil;
    }
    
    if ([to isKindOfClass:[NSNull class]]) {
        to = nil;
    }
}

- (BOOL)checkAmountForm:(NSString *)amount
            amountFloat:(CGFloat)amountFloat
              requestId:(NSString *)requestId
                webView:(WKWebView *)webView
             callbackId:(NSString *)callbackId
{
    if ([amount hasPrefix:@"0x"] || [amount hasPrefix:@"0X"]) { // 16进制
        
        NSString *regex =@"[0-9a-fA-F]*";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        if ([predicate evaluateWithObject:[amount substringFromIndex:2]]) {
            amountFloat = [BigNumber bigNumberWithHexString:[NSString stringWithFormat:@"%@",amount]].decimalString.doubleValue/pow(10, 18);
            return YES;
        }else{
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:@""
                                    callbackId:callbackId
                                          code:ERROR_REQUEST_PARAMS];
            return NO;
        }
    }else { // 10进制
        NSString *regex =@"[0-9]*";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        if ([predicate evaluateWithObject:amount]) {
            amountFloat = [BigNumber bigNumberWithDecimalString:[NSString stringWithFormat:@"%@",amount]].decimalString.doubleValue/pow(10, 18);
            return YES;
        }else{
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:@""
                                    callbackId:callbackId
                                          code:ERROR_REQUEST_PARAMS];
            return NO;
        }
    }
}

- (BOOL)checkClauseForm:(NSString *)clauseStr
{
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

@end
