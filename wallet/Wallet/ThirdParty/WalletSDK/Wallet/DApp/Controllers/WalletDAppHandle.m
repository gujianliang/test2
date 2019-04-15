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
#import "WalletGetSymbolApi.h"
#import "WalletGetDecimalsApi.h"
#import "WalletGenesisBlockInfoApi.h"
#import "WalletAccountCodeApi.h"
#import "WalletBlockApi.h"
#import "WalletTransantionsReceiptApi.h"
#import "WalletDAppHead.h"
#import "WalletDAppHandle+web3JS.h"
#import "WalletDAppHandle+connexJS.h"
#import "NSJSONSerialization+NilDataParameter.h"
#import "WalletDAppPeersApi.h"
#import "WalletDAppTransferDetailApi.h"
#import "WalletJSCallbackModel.h"
#import "WalletGetBaseGasPriceApi.h"
#import "SocketRocketUtility.h"
#import "WalletTransactionApi.h"
#import "WalletDappCheckParamsHandle.H"
#import "WalletDappSimulateMultiAccountApi.h"

@interface WalletDAppHandle ()<WKNavigationDelegate,WKUIDelegate>
{
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

-(instancetype)init
{
    self = [super init];
    if (self ) {
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(websocket:) name:kWebSocketdidReceiveMessageNote object:nil];
    }
    return self;
    
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
        
        //打开ticker
        [self tickerNextRequestId:requestId callbackId:callbackId];
        
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
    else if([method isEqualToString:@"methodAsCall"])
    {
        [self methodAsClauseWithDictP:callbackParams requestId:requestId webView:webView callbackId:callbackId];
        
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
    }else if ([method isEqualToString:@"filterApply"])
    {
        [self filterDictParam:callbackParams requestId:requestId webView:webView callbackId:callbackId];
    }else if ([method isEqualToString:@"explain"])
    {
        [self explainDictParam:callbackParams requestId:requestId webView:webView callbackId:callbackId];
    }else if ([method isEqualToString:@"owned"])
    {
        NSString *address = callbackParams[@"address"];
        
        [self checkAddressOwn:address requestId:requestId callbackId:callbackId completionHandler:completionHandler];
        return;
    }
    else{
        
        NSDictionary *dict1 = [WalletTools packageWithRequestId:requestId
                                                           data:@""
                                                           code:ERROR_REQUEST_METHOD
                                                        message:ERROR_REQUEST_METHOD_MSG];
        completionHandler([dict1 yy_modelToJSONString]);
        
        return ;
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

    NSString *kind = callbackParams[@"kind"];
    
    if ([kind isEqualToString:@"cert"]) { // cert 类型签名
        
        NSString *from = callbackParams[@"options"][@"signer"];
        
        [self certTransferParamModel:callbackParams from:from requestId:requestId webView:webView callbackId:callbackId];
       
        return ;
    }
    
    if (bConnex && ![self checkKind:kind requestId:requestId callbackId:callbackId webView:webView]) {
        return;
    }
   
    __block NSString *gas           = @"";
    __block NSString *gasPrice      = @"";
    __block NSString *from          = @"";

    NSMutableArray *clauseModelList = [[NSMutableArray alloc]init];

    if (bConnex) {
        
        if (![self checkCluases:callbackParams requestId:requestId callbackId:callbackId webView:webView]) {
            return;
        }
        
        NSArray *clauseList = callbackParams[@"clauses"];
        for (NSDictionary *clauseDict in clauseList) {
            
            ClauseModel *clauseModel = [[ClauseModel alloc]init];
            clauseModel.to    = clauseDict[@"to"];
            clauseModel.value = clauseDict[@"value"];
            clauseModel.data  = clauseDict[@"data"];
            
            gas        = callbackParams[@"options"][@"gas"];
            gasPrice   = callbackParams[@"options"][@"gasPrice"];
            
            [clauseModelList addObject:clauseModel];
        }
        
        gasPrice   = @"120"; //connex js 没有传 gaspPrice 写默认值
        
        from       = callbackParams[@"options"][@"signer"];
        
    }else{
        
        ClauseModel *clauseModel = [[ClauseModel alloc]init];
        clauseModel.to    = callbackParams[@"to"];
        clauseModel.value = callbackParams[@"value"];
        clauseModel.data  = callbackParams[@"data"];
        
        gas        = callbackParams[@"gas"];
        gasPrice   = callbackParams[@"gasPrice"];
        
        [clauseModelList addObject:clauseModel];
    }
    ClauseModel *clauseModel = [clauseModelList firstObject];
    if (gas.integerValue == 0) {
        
        NSMutableDictionary *dictClause = [NSMutableDictionary dictionary];
        [dictClause setValueIfNotNil:clauseModel.to forKey:@"to"];
        [dictClause setValueIfNotNil:clauseModel.value forKey:@"value"];
        [dictClause setValueIfNotNil:clauseModel.data forKey:@"data"];
        
        NSLog(@"dictClause == %@",dictClause);
        
        NSString *to = clauseModel.to;
        NSString *amount = clauseModel.value;
        NSString *clauseStr = clauseModel.data;
        
        gas = [NSString stringWithFormat:@"%d",[self getGasTo:&to value:&amount data:&clauseStr]];
        
        WalletDappSimulateMultiAccountApi *simulateApi = [[WalletDappSimulateMultiAccountApi alloc]initClause:@[dictClause] opts:@{} revision:@""];
        [simulateApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
            
            NSArray *list = (NSArray *)finishApi.resultDict;
            NSString *gasUsed = [list firstObject][@"gasUsed"];
            if (gasUsed.integerValue != 0) {
                gas = [NSString stringWithFormat:@"%ld",gas.integerValue + gasUsed.integerValue + 15000];
            }
            
            [self callbackClauseList:clauseModelList gas:gas from:from bConnex:bConnex webView:webView callbackId:callbackId requestId:requestId];

            
            
        }failure:^(VCBaseApi *finishApi, NSString *errMsg) {
            
            [self paramsError:requestId webView:webView callbackId:callbackId];

        }];
    }else{
        [self callbackClauseList:clauseModelList gas:gas from:from bConnex:bConnex webView:webView callbackId:callbackId requestId:requestId];
    }
    
    
}

- (void)callbackClauseList:(NSArray *)clauseModelList gas:(NSString *)gas from:(NSString *)from bConnex:(BOOL)bConnex  webView:(WKWebView *)webView callbackId:(NSString *)callbackId requestId:(NSString *)requestId
{
    id delegate = [WalletDAppHandle shareWalletHandle].delegate;
    if (delegate) {
        if ([delegate respondsToSelector:@selector(onTransfer: gas: callback:)]) {
            
            [delegate onTransfer:clauseModelList gas:gas callback:^(NSString * _Nonnull txid,NSString *address)
             {
                 [self callbackToWebView:txid
                                 address:address
                                 bConnex:bConnex
                                 webView:webView
                              callbackId:callbackId
                               requestId:requestId];
                 
             }];
        }else{
            [WalletTools callbackWithrequestId:requestId
                                       webView:webView
                                          data:@""
                                    callbackId:callbackId
                                          code:ERROR_INITDAPP_ERROR];
        }
    }
}

- (void)callbackToWebView:(NSString *)txid address:(NSString *)address bConnex:(BOOL)bConnex  webView:(WKWebView *)webView callbackId:(NSString *)callbackId requestId:(NSString *)requestId
{
    if (txid.length != 0) {
        id data = nil;
        if (bConnex) {
            
            NSMutableDictionary *dictData = [NSMutableDictionary dictionary];
            [dictData setValueIfNotNil:txid forKey:@"txId"];
            [dictData setValueIfNotNil:address forKey:@"signer"];
            
            data = dictData;
        }else{
            data = txid;
        }
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:data
                                callbackId:callbackId
                                      code:OK];
    }else{
        [WalletTools callbackWithrequestId:requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackId
                                      code:ERROR_REQUEST_PARAMS];
    }
}

- (void)injectJS:(WKWebView *)webview 
{
    //connex
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"WalletSDKBundle" ofType:@"bundle"];
    if(!bundlePath){
        return ;
    }
    NSString *path = [bundlePath stringByAppendingString:@"/connex_js.js"];
    NSString *connex_js = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    connex_js = [connex_js stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSLog(@"dd");
    [webview evaluateJavaScript:connex_js completionHandler:^(id _Nullable item, NSError * _Nullable error) {
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

- (BOOL)checkKind:(NSString *)kind requestId:(NSString *)requestId callbackId:(NSString *)callbackId webView:(WKWebView *)webView
{
    if (![kind isKindOfClass:[NSString class]]) {
        [WalletTools callbackWithrequestId:requestId webView:webView data:@"" callbackId:callbackId code:ERROR_REQUEST_PARAMS];
        return NO;
    }else{
        //既不登tx ，也不是 cert
        if (![kind isEqualToString:@"tx"] && ![kind isEqualToString:@"cert"]) {
            [WalletTools callbackWithrequestId:requestId webView:_webView data:@"" callbackId:callbackId code:ERROR_NETWORK];
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
        clausesDict = clausesList[0];
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

- (int)getGasTo:(NSString **)to value:(NSString **)value data:(NSString **)data
{
    
    if ([WalletTools isEmpty:*to]) {
        *to = @"";
    }
    
    if ([WalletTools isEmpty:*value]) {
        *value = @"";
    }
    
    if ([WalletTools isEmpty:*data]) {
        *data = @"";
    }
    
    int txGas = 5000;
    int clauseGas = 16000;
    int clauseGasContractCreation = 48000;
    
    if ((*data).length == 0 ) {
        return txGas + clauseGas;
    }
    int sum = txGas;
    
    if ((*to).length > 0) {
        sum += clauseGas;
    } else {
        sum += clauseGasContractCreation;
    }
    
    sum += [self dataGas:(*data)];
    return sum ;
}

- (int)dataGas:(NSString *)data {
    int zgas = 4;
    int nzgas = 68;
    
    int sum = 0;
    for (int i = 2; i < data.length; i += 2) {
        NSString *subStr = [data substringWithRange:NSMakeRange(i, 2)];
        if ([subStr isEqualToString: @"00"]) {
            sum += zgas;
        } else {
            sum += nzgas;
        }
    }
    return sum;
}


+(void)attempDealloc
{
    predicate = 0;
    singleton = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[SocketRocketUtility instance] SRWebSocketClose];
}


@end
