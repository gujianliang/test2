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
    WKWebView *_webView;
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
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(websocket:) name:kWebSocketdidReceiveMessageNote object:nil];
}

- (void)webView:(WKWebView *)webView defaultText:(nullable NSString *)defaultText completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
#if  ReleaseVersion
    NSLog(@"defaultText == %@",defaultText);
#endif
    _webView = webView;
    
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
        
        return;
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
    if ([[WalletTools getCurrentNavVC].view viewWithTag:SelectWalletTag]) {
        return;
    }
     BOOL bCert = NO;
    
    NSString *kind = callbackParams[@"kind"];
    
    if (bConnex && ![self checkKind:kind requestId:requestId callbackId:callbackId webView:webView]) {
        return;
    }
    
    NSString *to            = @"";
    NSString *amount        = @"";
    NSString *clauseStr     = @"";
    NSString *gas           = @"";
    NSString *tokenAddress  = @"";
    NSString *gasPrice      = @"";
    
    if (bConnex) {
        
        if (![self checkCluases:callbackParams requestId:requestId callbackId:callbackId webView:webView]) {
            return;
        }
        
        NSDictionary *clausesDict = nil;
        clausesDict = callbackParams[@"clauses"][0];
        
        to         = clausesDict[@"to"];
        amount     = clausesDict[@"value"];
        clauseStr  = clausesDict[@"data"];
        gas        = callbackParams[@"options"][@"gas"];
        gasPrice   = callbackParams[@"options"][@"gasPrice"];
        
        if (![self checkParamTo:&to data:&clauseStr value:&amount gas:&gas gasPrice:&gasPrice bConnex:YES]) {
            [self paramsError:requestId webView:webView callbackId:callbackId];
            return;
        }
        
    }else{
        to         = callbackParams[@"to"];
        amount     = callbackParams[@"value"];
        clauseStr  = callbackParams[@"data"];
        gas        = callbackParams[@"gas"];
        gasPrice   = callbackParams[@"gasPrice"];
        
        if (![self checkParamTo:&to data:&clauseStr value:&amount gas:&gas gasPrice:&gasPrice bConnex:NO]) {
            [self paramsError:requestId webView:webView callbackId:callbackId];
            return;
        }
    }

    NSString *amountNoFormat = @"";
    
    WalletTransferType transferType = WalletVETTransferType;
    
    NSString *clauseDecimal = [BigNumber bigNumberWithHexString:clauseStr].decimalString;

    if (clauseStr.length == 0 || clauseDecimal.integerValue == 0 ) { // vet 转账clauseStr == nil,
        
        transferType = WalletVETTransferType;
        
        if (![self checkAmountForm:amount amountFloat:&amountNoFormat requestId:requestId webView:webView callbackId:callbackId]
            ||![WalletTools errorAddressAlert:to]
            ||![WalletTools checkDecimalStr:gas]
            ||![WalletTools checkHEXStr:gasPrice]) {
            
            [self paramsError:requestId webView:webView callbackId:callbackId];
            
            return;
        }
        
    }else if(clauseStr.length > 10){
        if ([clauseStr hasPrefix:TransferMethodId] && [to.lowercaseString isEqualToString:vthoTokenAddress]) { // 只有vtho ，其他token 走合约
            transferType = WalletTokenTransferType;
            tokenAddress = [[NSString alloc]initWithString:to];
            
            amount = [WalletTools getAmountFromClause:clauseStr to:&to];
            NSString *amountToken = @"0";
            if (![self checkAmountForm:amount amountFloat:&amountToken requestId:requestId webView:webView callbackId:callbackId]
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
            
            if (amount.length > 0 && ![self checkAmountForm:amount amountFloat:&amountNoFormat requestId:requestId webView:webView callbackId:callbackId]) {
                [self paramsError:requestId webView:webView callbackId:callbackId];
                
                return;
            }
        }
    }else{ // 小于10 非法参数
        [self paramsError:requestId webView:webView callbackId:callbackId];
        return;
    }
    
    WalletDappStoreSelectView *selectView = [[WalletDappStoreSelectView alloc]initWithFrame:[WalletTools getCurrentVC].view.frame ];
    selectView.tag = SelectWalletTag;
    selectView.toAddress = to;
    selectView.amount = amountNoFormat;
    [[WalletTools getCurrentNavVC].view addSubview:selectView];
    @weakify(self);
    selectView.block = ^(NSString *from,WalletDappStoreSelectView *viewSelf){
        @strongify(self);
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
    UIView *conventView = [[WalletTools getCurrentNavVC].view viewWithTag:SignViewTag];
    if (conventView) {
        return;
    }
    [WalletTools checkNetwork:^(BOOL t) {
        if (t) {
            
            if (bCert) {
                [self paramsError:requestId webView:webView callbackId:callbackId];
                return;
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

- (BOOL)checkNumberOriginBool:(id)data {
    
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
            amountFloat:(NSString **)amountNoFormat
              requestId:(NSString *)requestId
                webView:(WKWebView *)webView
             callbackId:(NSString *)callbackId
{
    if (![amount isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if ([amount.lowercaseString hasPrefix:@"0x"]) { // 16进制
        if ([WalletTools checkHEXStr:amount]) {
            NSString *tempAmount = [Payment formatEther:[BigNumber bigNumberWithHexString:amount]];
            *amountNoFormat = [tempAmount stringByReplacingOccurrencesOfString:@"," withString:@""];
            return YES;
        }else{
            [self paramsError:requestId webView:webView callbackId:callbackId];

            return NO;
        }
    }else { // 10进制
        if ([WalletTools checkDecimalStr:amount]) {
            NSString *tempAmount = [Payment formatEther:[BigNumber bigNumberWithDecimalString:amount]];
            *amountNoFormat = [tempAmount stringByReplacingOccurrencesOfString:@"," withString:@""];
            return YES;
        }else{
            [self paramsError:requestId webView:webView callbackId:callbackId];
            return NO;
        }
    }
}

- (BOOL)checkKind:(NSString *)kind requestId:(NSString *)requestId callbackId:(NSString *)callbackId webView:(WKWebView *)webView
{
    if (![kind isKindOfClass:[NSString class]]) {
        [WalletTools callbackWithrequestId:requestId webView:webView data:@"" callbackId:callbackId code:ERROR_REQUEST_PARAMS];
        return NO;
    }else{
        if (![kind isEqualToString:@"tx"]) {
            [WalletTools callbackWithrequestId:requestId webView:webView data:@"" callbackId:callbackId code:ERROR_REQUEST_PARAMS];
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)checkCluases:(NSDictionary *)callbackParams requestId:(NSString *)requestId callbackId:(NSString *)callbackId webView:(WKWebView *)webView
{
    NSDictionary *clausesDict = nil;
    
    NSArray *clausesList = callbackParams[@"clauses"];
    if (clausesList.count == 0) {
        [self paramsError:requestId webView:webView callbackId:callbackId];
        return NO;
    }else if(clausesList.count == 1)
    {
        clausesDict = callbackParams[@"clauses"][0];
        if (clausesDict == nil) {
            [self paramsError:requestId webView:webView callbackId:callbackId];
            return  NO;
        }
    }else{
        [WalletTools callbackWithrequestId:requestId webView:webView data:@"" callbackId:callbackId code:ERROR_REQUEST_MULTI_CLAUSE];
        return NO;
    }
    return YES;
}

- (BOOL)checkParamTo:(NSString **)to data:(NSString **)data value:(NSString **)value gas:(NSString **)gas gasPrice:(NSString **)gasPrice bConnex:(BOOL)bConnex
{
    if ([*to isKindOfClass:[NSNull class]]) {
        *to = @"";
    }
    
    if ([*data isKindOfClass:[NSNull class]]) {
        *data = @"0x";
    }
    
    if ([*value isKindOfClass:[NSNull class]]) {
        *value = @"0";
    }
    
    if ((*value) == nil) {
        *value = @"0";
    }
    
    if ([*gas isKindOfClass:[NSNull class]]) {
        *gas = @"0";
    }
    
    if ([*gasPrice isKindOfClass:[NSNull class]]) {
        *gasPrice = @"0";
    }
    
    //验证格式
    //to有可能是 空
    if (*to == nil) {
        
    }else if (![*to isKindOfClass:[NSString class]]) {
        return NO;
    }else {
        if ([*to isKindOfClass:[NSString class]]) {
            if ((*to).length > 0) {
                if (![WalletTools checkHEXStr:*to]) {
                    return NO;
                }
            }
        }
    }
    
    //data 有可能是nil
    if (*data == nil) {
        
    }else if (![*data isKindOfClass:[NSString class]] ) {
        return NO;
    }else {
        
        //data 可以没写，但是一旦写了，就必须大于10 ，并且 > 0
        if ([*data isKindOfClass:[NSString class]]) {
            if((*data).length >= 10){//length >= 10
                if (![WalletTools checkHEXStr:*data]) {
                    return NO;
                }
            }else if((*data).length != 0){ //length 1 -- 9
                if ([WalletTools checkHEXStr:*data]) {
                    
                    NSString *clauseDec = [BigNumber bigNumberWithHexString:*data].decimalString;
                    if (clauseDec.integerValue != 0) {
                        return NO;
                    }
                }else{
                    return NO;
                }
            }else{ // data.length == 0 ,data 是字符串但是一定要长度大于0
                return NO;
            }
        }
    }
    
    BOOL checkValue = YES;
    BOOL checkGas = YES;
    if (bConnex) {
        //connex value NSString | NSNumber
        checkValue = ![*value isKindOfClass:[NSString class]] && ![*value isKindOfClass:[NSNumber class]];
        
        //connex gas NSString | NSNumber
        checkGas = ![*gas isKindOfClass:[NSString class]] && ![*gas isKindOfClass:[NSNumber class]];
    }else{
        //web3 value NSString
        checkValue = ![*value isKindOfClass:[NSString class]];
        
        //web3 gas NSString
        checkGas = ![*gas isKindOfClass:[NSString class]];
    }
    
    if (checkValue) {
        return NO;
    }//转 10进制
    else{
        if ([self checkNumberOriginBool:*value]) {
            return NO;
        }else{
            
            if ([(*value) isKindOfClass:[NSString class]]) {
                if((*value).length == 0){// value 是字符串，但是是‘’；
                    
                    return NO;
                }
                
            }
            *value = [NSString stringWithFormat:@"%@",*value];
            
            if ((*value).length == 0) { //value 可能是nil
                
            }else if (![WalletTools checkDecimalStr:*value]) {//不是10进制
                
                if ([WalletTools checkHEXStr:*value]){
                    *value = [BigNumber bigNumberWithHexString:*value].decimalString;
                }else{
                    return NO;
                }
            }else{
                
            }
        }
    }
    if (checkGas) {
        return NO;
    }else {
        //转 10进制
        
        if ([self checkNumberOriginBool:*gas]) {
            return NO;
        }else{
            *gas = [NSString stringWithFormat:@"%@",*gas];
            
            if (![WalletTools checkDecimalStr:*gas]) {
                if ([WalletTools checkHEXStr:*gas]){
                    
                    *gas = [BigNumber bigNumberWithHexString:*gas].decimalString;
                }else{
                    return NO;
                }
            }else{
                if ((*gas).length == 0
                    || (*gas).integerValue == 0) {
                    return NO;
                }
            }
        }
    }
    
    //    if (!bConnex) {
    if(*gasPrice == nil)
    {
        *gasPrice = DefaultGasPriceCoef;
    }else if (![*gasPrice isKindOfClass:[NSString class]]) {
        return NO;
    }else{
        //转 16进制
        if ([*gasPrice isKindOfClass:[NSString class]]) {
            
            *gasPrice = [NSString stringWithFormat:@"%@",*gasPrice];
            if (![WalletTools checkHEXStr:*gasPrice]) {
                
                if ([WalletTools checkDecimalStr:*gasPrice]){
                    *gasPrice = [BigNumber bigNumberWithDecimalString:*gasPrice].hexString;
                    
                }else{
                    return NO;
                }
            }else if ((*gasPrice).length == 0){
                *gasPrice = DefaultGasPriceCoef;
            }
        }else if(*gasPrice == nil)
        {
            *gasPrice = DefaultGasPriceCoef;
        }
    }
    
    return YES;
}

- (void)paramsError:(NSString *)requestId webView:(WKWebView *)webView callbackId:(NSString *)callbackId
{
    [WalletTools callbackWithrequestId:requestId webView:webView data:@"" callbackId:callbackId code:ERROR_REQUEST_PARAMS];
}

- (void)websocket:(NSNotification *)sender
{
    NSDictionary *dict = sender.object;
    NSArray *requestIdList = dict[@"requestId"];
    for (NSString *requestId in requestIdList) {
        [WalletTools callbackWithrequestId:requestId webView:_webView data:nil callbackId:dict[@"callbackId"] code:OK];
    }
}

+(void)attempDealloc
{
    predicate = 0;
    singleton = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[SocketRocketUtility instance] SRWebSocketClose];
}


@end
