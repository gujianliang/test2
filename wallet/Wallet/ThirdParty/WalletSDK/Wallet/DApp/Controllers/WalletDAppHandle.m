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
}

- (void)webView:(WKWebView *)webView defaultText:(nullable NSString *)defaultText completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
#if  ReleaseVersion
    NSLog(@"defaultText == %@",defaultText);
#endif
    
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
        
    }else if ([method isEqualToString:@"getAccountStorage"])
    {
        [self getStorageApiDictParam:callbackParams requestId:requestId webView:webView callbackId:callbackId];
        
        
    }else if ([method isEqualToString:@"tickerNext"])
    {
        [self tickerNextRequestId:requestId callbackId:callbackId];

    }
    else if([method isEqualToString:@"sign"])
    {
        [self transferCallbackParams:callbackParams
                             webView:webView
                              connex:YES
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
        
    }else if([method isEqualToString:@"getNodeUrl"]){
      
        [self getNodeUrl:requestId completionHandler:completionHandler];
        return;
    }else if ([method isEqualToString:@"send"]){
        
        [self transferCallbackParams:callbackParams
                             webView:webView
                          connex:NO
                       requestId:requestId
                      callbackId:callbackId
               completionHandler:completionHandler];
    }else{
        NSDictionary *dict1 = [WalletTools packageWithRequestId:requestId
                                                           data:@""
                                                           code:ERROR_REQUEST_METHOD
                                                        message:ERROR_REQUEST_METHOD_MSG];
        completionHandler([dict1 yy_modelToJSONString]);
    }
    completionHandler(@"{}");
}

- (void)transferCallbackParams:(NSDictionary *)callbackParams
                       webView:(WKWebView *)webView
                    connex:(BOOL)bConnex
                 requestId:(NSString *)requestId
                callbackId:(NSString *)callbackId
         completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    if ([[WalletTools getCurrentVC].navigationController.view viewWithTag:SelectWalletTag]) {
        return;
    }
     BOOL bCert = NO;
    
    NSString *kind = callbackParams[@"kind"];
    if (![kind isEqualToString:@"tx"] && bConnex) {
        [WalletTools callbackWithrequestId:requestId webView:webView data:@"" callbackId:callbackId code:ERROR_REQUEST_PARAMS];
        return;
    }
    
    //    if ([kind isEqualToString:@"cert"]) {
    //        callbackParams = [NSMutableDictionary dictionaryWithDictionary:callbackParams[@"clauses"]];
    //        bCert = YES;
    //
    //    }else
    
    if (bConnex) {
        if (![kind isKindOfClass:[NSString class]]) {
            [WalletTools callbackWithrequestId:requestId webView:webView data:@"" callbackId:callbackId code:ERROR_REQUEST_PARAMS];
            return;
        }
        
        if ([kind isKindOfClass:[NSNull class]]) {
            [WalletTools callbackWithrequestId:requestId webView:webView data:@"" callbackId:callbackId code:ERROR_REQUEST_PARAMS];
            return;
        }
        if (![kind isEqualToString:@"tx"]) {
            [WalletTools callbackWithrequestId:requestId webView:webView data:@"" callbackId:callbackId code:ERROR_REQUEST_PARAMS];
            return;
        }
    }
    
    NSString *to            = @"";
    NSString *amount        = @"";
    NSString *clauseStr     = @"";
    NSString *gas           = @"";
    NSString *tokenAddress  = @"";
    NSString *gasPrice      = @"";
    
    if (bConnex) {
        
        NSDictionary *clausesDict = nil;
        
        NSArray *clausesList = callbackParams[@"clauses"];
        if (clausesList.count == 0) {
            [self paramsError:requestId webView:webView callbackId:callbackId];
            return;
        }else if(clausesList.count == 1)
        {
            clausesDict = callbackParams[@"clauses"][0];
            if (clausesDict == nil) {
                [self paramsError:requestId webView:webView callbackId:callbackId];
                return;
            }
        }else{
            [WalletTools callbackWithrequestId:requestId webView:webView data:@"" callbackId:callbackId code:ERROR_REQUEST_MULTI_CLAUSE];
        }
        
        to         = clausesDict[@"to"];
        amount     = clausesDict[@"value"];
        clauseStr  = clausesDict[@"data"];
        gas        = callbackParams[@"options"][@"gas"];
        gasPrice   = callbackParams[@"options"][@"gasPrice"];
    }else{
        to         = callbackParams[@"to"];
        amount     = callbackParams[@"value"];
        clauseStr  = callbackParams[@"data"];
        gas        = callbackParams[@"gas"];
        gasPrice   = callbackParams[@"gasPrice"];
    }
    
    if (![clauseStr isKindOfClass:[NSString class]]) {
        
        [self paramsError:requestId webView:webView callbackId:callbackId];
        
        return;
    }else{
        if (clauseStr.length > 0) {
            if (![WalletTools checkHEXStr:clauseStr]) {
                [self paramsError:requestId webView:webView callbackId:callbackId];
                return;
            }
        }
    }
    
    [self initParamGasPrice:&gasPrice gas:&gas amount:&amount to:&to clauseStr:&clauseStr];
    
    CGFloat amountFloat = 0;
    
    WalletTransferType transferType = WalletVETTransferType;
    
    NSString *clauseDecimal = [BigNumber bigNumberWithHexString:clauseStr].decimalString;

    if (clauseStr.length < 10 || clauseDecimal.integerValue == 0 ) { // vet 转账clauseStr == nil,
        
        transferType = WalletVETTransferType;
        
        if (![self checkAmountForm:amount amountFloat:&amountFloat requestId:requestId webView:webView callbackId:callbackId]
            ||![WalletTools errorAddressAlert:to]
            ||![WalletTools checkDecimalStr:gas]
            ||![WalletTools checkHEXStr:gasPrice]) {
            
            [self paramsError:requestId webView:webView callbackId:callbackId];
            
            return;
        }
        
        if (![clauseStr isKindOfClass:[NSString class]]) {
            [self paramsError:requestId webView:webView callbackId:callbackId];
            
            return;
        }else if(clauseStr.length >= 10){
            if (![WalletTools checkHEXStr:clauseStr]) {
                [self paramsError:requestId webView:webView callbackId:callbackId];
                return;
            }
        }else if(clauseStr.length != 0){
            if ([WalletTools checkHEXStr:clauseStr]) {
                
                NSString *clauseDec = [BigNumber bigNumberWithHexString:clauseStr].decimalString;
                if (clauseDec.integerValue != 0) {
                    [self paramsError:requestId webView:webView callbackId:callbackId];
                    return;
                }
            }else{
                [self paramsError:requestId webView:webView callbackId:callbackId];
                return;
            }
        }
        
    }else if(clauseStr.length > 10){
        if ([clauseStr hasPrefix:TransferMethodId] && [to.lowercaseString isEqualToString:vthoTokenAddress]) { // 只有vtho ，其他token 走合约
            transferType = WalletTokenTransferType;
            tokenAddress = to;
            
            amount = [WalletTools getAmountFromClause:clauseStr to:&to];
            
            if (![self checkAmountForm:amount amountFloat:&amountFloat requestId:requestId webView:webView callbackId:callbackId]
                ||![WalletTools errorAddressAlert:to]
                || ![WalletTools errorAddressAlert:tokenAddress]
                || [tokenAddress isKindOfClass:[NSNull class]]
                || ![WalletTools checkClauseDataFormat:clauseStr toAddress:to bToken:YES]
                || ![WalletTools checkDecimalStr:gas]
                || ![WalletTools checkHEXStr:gasPrice]
                ) {
                
                [self paramsError:requestId webView:webView callbackId:callbackId];
                
                return;
            }
            if (![WalletTools checkHEXStr:clauseStr]) {
                [self paramsError:requestId webView:webView callbackId:callbackId];
                return;
            }
            
        }else{ // 其他合约交易
            
            transferType = WalletContranctTransferType;
            tokenAddress = to;
            NSData *newclouseData = [SecureData hexStringToData:clauseStr];

            if (newclouseData == nil
                ||![WalletTools checkClauseDataFormat:clauseStr toAddress:to bToken:NO]
                ||![WalletTools checkDecimalStr:gas]
                ||![WalletTools checkHEXStr:gasPrice]) {
                
                [self paramsError:requestId webView:webView callbackId:callbackId];
                
                return;
            }
            
            if (amount.length > 0 && ![self checkAmountForm:amount amountFloat:&amountFloat requestId:requestId webView:webView callbackId:callbackId]) {
                [self paramsError:requestId webView:webView callbackId:callbackId];
                
                return;
            }
            
            if (![clauseStr isKindOfClass:[NSString class]]) {
                [self paramsError:requestId webView:webView callbackId:callbackId];
                
                return;
            }else if(clauseStr.length >= 10){
                if (![WalletTools checkHEXStr:clauseStr]) {
                    [self paramsError:requestId webView:webView callbackId:callbackId];
                    return;
                }
            }else if(clauseStr.length != 0){
                [self paramsError:requestId webView:webView callbackId:callbackId];
                return;
            }
            
            if (to.length > 0) {
                if(![WalletTools errorAddressAlert:to]){
                    [self paramsError:requestId webView:webView callbackId:callbackId];
                    return;
                }
            }
        }
    }else{ // 小于10 非法参数
        [self paramsError:requestId webView:webView callbackId:callbackId];
        return;
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
                             webView:webView
                          callbackId:callbackId
                               bCert:bCert
                        transferType:transferType
                              connex:bConnex];
    };
    selectView.cancelBlock = ^{
        [WalletTools callbackWithrequestId:requestId webView:webView data:nil callbackId:callbackId code:ERROR_CANCEL];
    };
}


-(void)transferWithParamModel:(WalletSignParamModel *)paramModel
                    requestId:(NSString *)requestId
                      webView:(WKWebView *)webView
                   callbackId:(NSString *)callbackId
                        bCert:(BOOL)bCert
                 transferType:(WalletTransferType)transferType
                       connex:(BOOL)bConnex
{
    UIView *conventView = [[WalletTools getCurrentVC].navigationController.view viewWithTag:SignViewTag];
    if (conventView) {
        return;
    }
    [WalletTools checkNetwork:^(BOOL t) {
        if (t) {
            
            if (bCert) {
                
            }else if (transferType == WalletVETTransferType) {
                
                // VET 转账
                [self VETTransferDictWithParamModel:paramModel requestId:requestId webView:webView callbackId:callbackId connex:bConnex];
            }else if (transferType == WalletTokenTransferType)
            {
                //vtho 转账
                
                [self VTHOTransferWithParamModel:paramModel requestId:requestId webView:webView callbackId:callbackId connex:bConnex];
            }else{
                [self contractSignWithParamModel:paramModel requestId:requestId webView:webView callbackId:callbackId connex:bConnex];
            }
        }
    }];
}


- (void)injectJS:(WKWebView *)webview 
{
    //connex
    NSString *js = connex_js;
    [webview evaluateJavaScript:js completionHandler:^(id _Nullable item, NSError * _Nullable error) {
#if ReleaseVersion
        NSLog(@"inject error == %@",error);
#endif
    }];
    
    //web3
    NSString *web3js = web3_js;
    [webview evaluateJavaScript:web3js completionHandler:^(id _Nullable item, NSError * _Nullable error) {
#if ReleaseVersion
        NSLog(@"web3js error == %@",error);
#endif
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
        if ([self originTypeFromNumber:*gas]) {
            *gas = [NSString stringWithFormat:@"-1"];
        }else{
            *gas = [NSString stringWithFormat:@"%@",*gas];
            
            if (![WalletTools checkDecimalStr:*gas]) {
                
                if ([WalletTools checkHEXStr:*gas]){
                    
                    *gas = [BigNumber bigNumberWithHexString:*gas].decimalString;
                }
            }
            if ((*gas).integerValue == 0) {
                *gas = [NSString stringWithFormat:@"-1"];
            }
        }
    }
    
    if ([*amount isKindOfClass:[NSNull class]]) {
        *amount = @"0";
    }
    
    if ([*clauseStr isKindOfClass:[NSNull class]]) {
        *clauseStr = nil;
    }
    
    if ([*to isKindOfClass:[NSNull class]]) {
        *to = nil;
    }
}

- (BOOL ) originTypeFromNumber: (id) data {
    
    if ([data isKindOfClass:[NSNumber class]]) {
        const char * pObjCType = [((NSNumber*)data) objCType];
        
        if (strcmp(pObjCType, @encode(_Bool)) == 0
            || strcmp([data objCType], @encode(char)) == 0) {
            return YES;
        }
        return NO;
    }
    return NO;
}

- (BOOL)checkAmountForm:(NSString *)amount
            amountFloat:(CGFloat *)amountFloat
              requestId:(NSString *)requestId
                webView:(WKWebView *)webView
             callbackId:(NSString *)callbackId
{
    if (![amount isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if ([amount.lowercaseString hasPrefix:@"0x"]) { // 16进制
        if ([WalletTools checkHEXStr:amount]) {
            *amountFloat = [BigNumber bigNumberWithHexString:[NSString stringWithFormat:@"%@",amount]].decimalString.doubleValue/pow(10, 18);
            return YES;
        }else{
            [self paramsError:requestId webView:webView callbackId:callbackId];

            return NO;
        }
    }else { // 10进制
        if ([WalletTools checkDecimalStr:amount]) {
            *amountFloat = [BigNumber bigNumberWithDecimalString:[NSString stringWithFormat:@"%@",amount]].decimalString.doubleValue/pow(10, 18);
            return YES;
        }else{
            [self paramsError:requestId webView:webView callbackId:callbackId];
            return NO;
        }
    }
}


- (void)paramsError:(NSString *)requestId webView:(WKWebView *)webView callbackId:(NSString *)callbackId
{
    [WalletTools callbackWithrequestId:requestId webView:webView data:@"" callbackId:callbackId code:ERROR_REQUEST_PARAMS];
}

+(void)attempDealloc
{
    predicate = 0;
    singleton = nil;
}


@end
