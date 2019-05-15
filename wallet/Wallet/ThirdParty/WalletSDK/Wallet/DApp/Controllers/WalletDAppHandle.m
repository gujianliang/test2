//
//  WalletDAppHandle.m
//  VeWallet
//
//  Created by Tom on 2019/1/11.
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
#import "WalletDappSimulateMultiAccountApi.h"
#import "WalletCheckVersionApi.h"



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
        
        NSDictionary *noMethodDict = [WalletTools packageWithRequestId:requestId
                                                           data:@""
                                                           code:ERROR_REQUEST_METHOD
                                                        message:ERROR_REQUEST_METHOD_MSG];
        completionHandler([noMethodDict yy_modelToJSONString]);
        
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
   
    __block NSString *gas           = @"";
    __block NSString *gasPrice      = @"";
    __block NSString *from          = @"";

    NSMutableArray *clauseModelList = [[NSMutableArray alloc]init];

    if (bConnex) {
        
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
    if (gas.integerValue == 0) {
        
        gas = [NSString stringWithFormat:@"%d",[self getGas:clauseModelList]];
        
        WalletDappSimulateMultiAccountApi *simulateApi = [[WalletDappSimulateMultiAccountApi alloc]initClause:clauseModelList opts:@{} revision:@""];
        [simulateApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
            
            NSArray *list = (NSArray *)finishApi.resultDict;
            NSString *gasUsed = [list firstObject][@"gasUsed"];
            if (gasUsed.integerValue != 0) {
                gas = [NSString stringWithFormat:@"%d",gas.integerValue + gasUsed.integerValue + 15000];
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
            [dictData setValueIfNotNil:txid forKey:@"txid"];
            [dictData setValueIfNotNil:address.lowercaseString forKey:@"signer"];
            
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

- (int)getGas:(NSArray *)clauseList
{
    int gas = 0;
    for (ClauseModel *model in clauseList) {
       
        NSString *to     = model.to;
        NSString *value  = model.value;
        NSString *data   = model.data;
        
       gas = gas + [self calculateSingleGasTo:&to value:&value data:&data];
    }
    return gas;
}

- (int)calculateSingleGasTo:(NSString **)to value:(NSString **)value data:(NSString **)data
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

- (void)injectJS:(WKWebViewConfiguration *)config
{
    NSString *currentVersion = sdkVersion;
    WalletCheckVersionApi *checkApi = [[WalletCheckVersionApi alloc]initWithVersion:currentVersion language:[self getLanuage]];
    [checkApi loadDataAsyncWithSuccess:^(VCBaseApi *finishApi) {
        
        NSDictionary *dictData  = finishApi.resultDict[@"data"];
        
        NSString *update        = dictData[@"update"];
        NSString *latestVersion = dictData[@"latestVersion"];
        NSString *description   = dictData[@"description"];

        if (update.boolValue) {
           
            NSLog(@"%@",description);
        }else{
            //当前sdk 版本和服务器返回的版本不同，提示
            if (![currentVersion isEqualToString:latestVersion]) {
                NSLog(@"%@",description);
            }
            
            [self inject:config];
        }
        
    } failure:^(VCBaseApi *finishApi, NSString *errMsg) {
        
    }];
}

- (void)inject:(WKWebViewConfiguration *)config
{
    //connex
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"WalletSDKBundle" ofType:@"bundle"];
    if(!bundlePath){
        return ;
    }
    NSString *path = [bundlePath stringByAppendingString:@"/connex_js.js"];
    NSString *connex_js = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    connex_js = [connex_js stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    WKUserScript* userScriptConnex = [[WKUserScript alloc] initWithSource:connex_js
                                                            injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                         forMainFrameOnly:YES];
    [config.userContentController addUserScript:userScriptConnex];
    
    
    NSString *web3Path = [bundlePath stringByAppendingString:@"/web3.js"];
    NSString *web3js = [NSString stringWithContentsOfFile:web3Path encoding:NSUTF8StringEncoding error:nil];
    web3js = [web3js stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    WKUserScript* userScriptWeb3 = [[WKUserScript alloc] initWithSource:web3js
                                                          injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                       forMainFrameOnly:YES];
    [config.userContentController addUserScript:userScriptWeb3];
}


-(NSString *)getLanuage
{
    NSString *language = @"";
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *localeLanguageCode = [appLanguages objectAtIndex:0];
    
    if ([localeLanguageCode containsString:@"zh"]) {
        language = @"zh-Hans";
        
    }else{
        language = @"en";
    }
   
    return language;
}

+(void)attempDealloc
{
    predicate = 0;
    singleton = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[SocketRocketUtility instance] SRWebSocketClose];
}


@end
