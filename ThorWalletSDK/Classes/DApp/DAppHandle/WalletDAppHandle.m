//
//  WalletDAppHandle.m
//  Wallet
//
//  Created by VeChain on 2019/1/11.
//  Copyright © 2019年 VeChain. All rights reserved.
//

// This code is distributed under the terms and conditions of the MIT license. 

/**
    Copyright (c) 2019 VeChain <support@vechain.com>

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.

**/


#import "WalletDAppHandle.h"
#import <WebKit/WebKit.h>
#import "WalletDAppHeader.h"
#import "WalletDAppHandle+web3JS.h"
#import "WalletDAppHandle+connexJS.h"
#import "WalletJSCallbackModel.h"
#import "SocketRocketUtility.h"
#import "WalletCheckVersionApi.h"
#import "WalletVersionModel.h"
#import "WalletDappSimulateMultiAccountApi.h"
#import "WalletDAppGasCalculateHandle.h"
#import "WalletGenesisBlockInfoApi.h"
#import "WalletDAppInjectJSHandle.h"

@interface WalletDAppHandle ()<WKNavigationDelegate,WKUIDelegate>
{

}
@property (nonatomic, strong)WalletVersionModel *versionModel;
@property (nonatomic, strong)WKWebView *webView;

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
        
        //Add web socket NSNotification
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(websocket:) name:kWebSocketdidReceiveMessageNote object:nil];
    }
    return self;
}

//Analyze data from Dapp
- (void)webView:(WKWebView *)webView defaultText:(nullable NSString *)defaultText completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    //Check if the version is forced to upgrade
    if ([WalletDAppInjectJSHandle analyzeVersion:_versionModel]) {
        
        completionHandler(@"{}");
        return;
    }
    
    NSLog(@"defaultText == %@",defaultText);
    _webView = webView;
    
    //Whether the scheme conforms to the dapp response
    NSString *result = [defaultText stringByReplacingOccurrencesOfString:@"wallet://" withString:@""];
    NSDictionary *dict = [NSJSONSerialization dictionaryWithJsonString:result];
    
    WalletJSCallbackModel *callbackModel = [WalletJSCallbackModel yy_modelWithDictionary:dict];
    NSString *requestId  = callbackModel.requestId;
    NSString *method     = callbackModel.method;

    NSString *strSEL = [self methodNameWithSEL][method];
    if (strSEL) {
     
        [self invocationMethod:strSEL callbackModel:callbackModel completionHandler:completionHandler];
    }else{
        //No matching methodId found
        NSDictionary *noMethodDict = [WalletTools packageWithRequestId:requestId
                                                                  data:@""
                                                                  code:ERROR_REJECTED
                                                               message:ERROR_REJECTED_MSG];
        completionHandler([noMethodDict yy_modelToJSONString]);
        
        return ;
    }
}

- (NSDictionary *)methodNameWithSEL
{
    NSArray *methodList = @[@"getStatus",
                            @"getGenesisBlock",
                            @"getAccount",
                            @"getAccountCode",
                            @"getBlock",
                            @"getTransaction",
                            @"getTransactionReceipt",
                            @"methodAsCall",
                            @"getAccounts",
                            @"getAccountStorage",
                            @"tickerNext",
                            @"sign",
                            @"getBalance",
                            @"getNodeUrl",
                            @"send",
                            @"filterApply",
                            @"explain",
                            @"owned"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    for (NSString *methodName in methodList) {
        NSString *strSEL = [NSString stringWithFormat:@"%@:completionHandler:webView:",methodName];
        [dict setValueIfNotNil:strSEL forKey:methodName];
    }
    return dict;
}

- (void)invocationMethod:(NSString *)strSEL callbackModel:(WalletJSCallbackModel *)callbackModel completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    SEL myMethod =  NSSelectorFromString(strSEL);
    
    NSMethodSignature*signature = [[self class] instanceMethodSignatureForSelector:myMethod];
    NSInvocation*invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = myMethod;
    
    [invocation setArgument:&callbackModel atIndex:2];
    [invocation setArgument:&completionHandler atIndex:3];
    [invocation setArgument:&_webView atIndex:4];
    
    [invocation invoke];
}

- (void)sign:(WalletJSCallbackModel *)callbackModel completionHandler:(void (^)(NSString * __nullable result))completionHandler webView:(WKWebView *)webView
{
    [self transferCallback:callbackModel connex:YES completionHandler:completionHandler];
}

- (void)send:(WalletJSCallbackModel *)callbackModel completionHandler:(void (^)(NSString * __nullable result))completionHandler webView:(WKWebView *)webView
{
    [self transferCallback:callbackModel connex:NO completionHandler:completionHandler];
}

- (void)transferCallback:(WalletJSCallbackModel *)callbackModel
                  connex:(BOOL)bConnex
       completionHandler:(void (^)(NSString * __nullable result))completionHandler
{

    NSString *kind = callbackModel.params[@"kind"];
    
    if ([kind isEqualToString:@"cert"]) { // Cert type signature
        
        NSString *from = callbackModel.params[@"options"][@"signer"];
        [self certTransfer:callbackModel from:from webView:_webView];
        return ;
    }
   
    __block NSString *gas      = @"";
    __block NSString *signer   = @"";
    __block NSString *gasPrice = @"";

    NSMutableArray *clauseModelList = [[NSMutableArray alloc]init];

    [self packgetDatabConnex:bConnex
             clauseModelList:clauseModelList
                         gas:&gas
                    gasPrice:&gasPrice
                      signer:&signer
              callbackParams:callbackModel.params];
    
    if (gas.integerValue == 0) {
        
        gas = [NSString stringWithFormat:@"%d",[WalletDAppGasCalculateHandle getGas:clauseModelList]];
        
        [self simulateMultiAccount:clauseModelList gas:&gas signer:signer callbackModel:callbackModel bConnex:bConnex];
    }else{
        [self callbackClauseList:clauseModelList gas:gas signer:signer bConnex:bConnex callbackModel:callbackModel];
    }
}

- (void)simulateMultiAccount:(NSArray *)clauseModelList gas:(NSString * __autoreleasing *)gas signer:(NSString *)signer callbackModel:(WalletJSCallbackModel *)callbackModel bConnex:(BOOL)bConnex
{
    @weakify(self);
    WalletDappSimulateMultiAccountApi *simulateApi = [[WalletDappSimulateMultiAccountApi alloc]initClause:clauseModelList opts:@{} revision:@""];
    [simulateApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
        @strongify(self);
        NSArray *list = (NSArray *)finishApi.resultDict;
        NSString *gasUsed = [list firstObject][@"gasUsed"];
        if (gasUsed.integerValue != 0) {
            //Gasused If it is not 0,  need to add 15000
            NSString *originGas = *gas;
            *gas = [NSString stringWithFormat:@"%ld",originGas.integerValue + gasUsed.integerValue + 15000];
        }
        
        [self callbackClauseList:clauseModelList gas:*gas signer:signer bConnex:bConnex  callbackModel:callbackModel];
        
    }failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
        @strongify(self);
        [self paramsErrorCallbackModel:callbackModel webView:self.webView ];
    }];
}

- (void)packgetDatabConnex:(BOOL)bConnex clauseModelList:(NSMutableArray *)clauseModelList gas:(NSString **)gas gasPrice:(NSString **)gasPrice signer:(NSString **)signer callbackParams:(NSDictionary *)callbackParams
{
    if (bConnex) { // Connex
        
        NSArray *clauseList = callbackParams[@"clauses"];
        
        for (NSDictionary *clauseDict in clauseList) {
            
            ClauseModel *clauseModel = [[ClauseModel alloc]init];
            clauseModel.to    = clauseDict[@"to"];
            clauseModel.value = clauseDict[@"value"];
            clauseModel.data  = clauseDict[@"data"];
            
            [clauseModelList addObject:clauseModel];
        }
        
        *gas        = callbackParams[@"options"][@"gas"];
        *gasPrice   = @"120"; //connex js No pass gaspPrice write default
        
        *signer       = callbackParams[@"options"][@"signer"];
        
    }else{ // Web3
        
        ClauseModel *clauseModel = [[ClauseModel alloc]init];
        clauseModel.to    = callbackParams[@"to"];
        clauseModel.value = callbackParams[@"value"];
        clauseModel.data  = callbackParams[@"data"];
        
        *gas        = callbackParams[@"gas"];
        *gasPrice   = callbackParams[@"gasPrice"];
        
        [clauseModelList addObject:clauseModel];
    }
}

- (void)callbackClauseList:(NSArray *)clauseModelList gas:(NSString *)gas signer:(NSString *)signer bConnex:(BOOL)bConnex callbackModel:(WalletJSCallbackModel *)callbackModel
{
    id delegate = [WalletDAppHandle shareWalletHandle].delegate;
    if (delegate) {
        if ([delegate respondsToSelector:@selector(onWillTransfer: signer: gas: completionHandler:)]) {
             @weakify(self)
            [delegate onWillTransfer:clauseModelList signer:signer gas:gas completionHandler:^(NSString * txId,NSString *signer)
             {
                 @strongify(self);
                 [self callbackToWebView:txId
                                  signer:signer
                                 bConnex:bConnex
                                 webView:self.webView
                           callbackModel:callbackModel];
                 
             }];
        }else{
            [WalletTools callbackWithrequestId:callbackModel.requestId
                                       webView:_webView
                                          data:@""
                                    callbackId:callbackModel.callbackId
                                          code:ERROR_REJECTED];
        }
    }
}

//Call back to dapp webview
- (void)callbackToWebView:(NSString *)txid signer:(NSString *)signer bConnex:(BOOL)bConnex  webView:(WKWebView *)webView callbackModel:(WalletJSCallbackModel *)callbackModel
{
    if (txid.length != 0) {
        id data = nil;
        if (bConnex) {
            
            NSMutableDictionary *dictData = [NSMutableDictionary dictionary];
            [dictData setValueIfNotNil:txid forKey:@"txid"];
            [dictData setValueIfNotNil:signer.lowercaseString forKey:@"signer"];
            
            data = dictData;
        }else{
            data = txid;
        }
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:data
                                callbackId:callbackModel.callbackId
                                      code:OK];
    }else{
        [WalletTools callbackWithrequestId:callbackModel.requestId
                                   webView:webView
                                      data:@""
                                callbackId:callbackModel.callbackId
                                      code:ERROR_NETWORK];
    }
}

- (void)paramsErrorCallbackModel:(WalletJSCallbackModel *)callbackModel webView:(WKWebView *)webView
{
    [WalletTools callbackWithrequestId:callbackModel.requestId webView:webView data:@"" callbackId:callbackModel.callbackId code:ERROR_NETWORK];
}

//Websocket notification
- (void)websocket:(NSNotification *)sender
{
    NSDictionary *dict = sender.object;
    NSArray *requestIdList = dict[@"requestId"];
    for (NSString *requestId in requestIdList) {
        [WalletTools callbackWithrequestId:requestId webView:_webView data:nil callbackId:dict[@"callbackId"] code:OK];
    }
}

- (void)injectJS:(WKWebViewConfiguration *)config
{
    @weakify(self);
    [WalletDAppInjectJSHandle injectJS:config callback:^(WalletVersionModel * _Nonnull versionModel) {
        @strongify(self);
        self.versionModel = versionModel;
    }];
}

+ (void)deallocDApp
{
    predicate = 0;
    singleton = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    // Close websocket
    [[SocketRocketUtility instance] SRWebSocketClose];
}


@end
