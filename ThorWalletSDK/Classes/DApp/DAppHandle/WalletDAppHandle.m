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
    WKWebView *_webView;
}
@property (nonatomic, strong)WalletVersionModel *versionModel;
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


- (NSDictionary *)Strategies
{
   return
  @{
    @"getStatus" :  NSStringFromSelector(@selector(getStatusWithRequestId:completionHandler:webView:)),

    @"getGenesisBlock" : NSStringFromSelector(@selector(getGenesisBlockWithRequestId:completionHandler:webView:)),
    
    @"getAccount" :  NSStringFromSelector(@selector(getAccountRequestId:completionHandler: webView:)),
    
    @"getAccountCode" :  NSStringFromSelector(@selector(getAccountCode:completionHandler: webView:)),

    @"getBlock" :  NSStringFromSelector(@selector(getBlock:completionHandler: webView:)),

    @"getTransaction" :  NSStringFromSelector(@selector(getTransaction:completionHandler: webView:)),

    @"getTransactionReceipt" :  NSStringFromSelector(@selector(getTransactionReceipt:completionHandler: webView:)),

    @"methodAsCall" :  NSStringFromSelector(@selector(methodAsCallWithDictP:completionHandler: webView:)),

    @"getAccounts" :  NSStringFromSelector(@selector(getAccountsWithRequestId:completionHandler: webView:)),

    @"getAccountStorage" :  NSStringFromSelector(@selector(getStorageApiDictParam:completionHandler: webView:)),

    @"tickerNext" :  NSStringFromSelector(@selector( tickerNextRequestId:completionHandler: webView:)),

//    @"sign" :  NSStringFromSelector(@selector(transferCallbackParams:
//                                              webView:
//                                              connex:
//                                              requestId:
//                                              callbackId:
//                                              completionHandler:)),
    @"getBalance" :  NSStringFromSelector(@selector(getBalance:completionHandler: webView:)),
    @"getNodeUrl" :  NSStringFromSelector(@selector(getNodeUrl: completionHandler:webView:)),
//    @"send" :  NSStringFromSelector(@selector(transferCallbackParams:
//                                              webView:
//                                              connex:
//                                              requestId:
//                                              callbackId:
//                                              completionHandler:)),
    @"filterApply" :  NSStringFromSelector(@selector(filterDictParam:completionHandler: webView:)),

    @"explain" :  NSStringFromSelector(@selector(explainDictParam:completionHandler: webView:)),

    @"owned" :  NSStringFromSelector(@selector(checkAddressOwn:completionHandler: webView:)),

    };
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

    NSString *strSEL = [self Strategies][method];
    if (strSEL) {
        SEL myMethod =  NSSelectorFromString(strSEL);
     
        NSMethodSignature*signature = [[self class] instanceMethodSignatureForSelector:myMethod];
        NSInvocation*invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.target = self;
        invocation.selector = myMethod;
        
        [invocation setArgument:&callbackModel atIndex:2];
        [invocation setArgument:&completionHandler atIndex:3];
        [invocation setArgument:&webView atIndex:4];

        [invocation invoke];
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

- (void)transferCallbackParams:(NSDictionary *)callbackParams
                       webView:(WKWebView *)webView
                        connex:(BOOL)bConnex
                     requestId:(NSString *)requestId
                    callbackId:(NSString *)callbackId
             completionHandler:(void (^)(NSString * __nullable result))completionHandler
{

    NSString *kind = callbackParams[@"kind"];
    
    if ([kind isEqualToString:@"cert"]) { // Cert type signature
        
        NSString *from = callbackParams[@"options"][@"signer"];
        
        [self certTransferParamModel:callbackParams from:from requestId:requestId webView:webView callbackId:callbackId];
       
        return ;
    }
   
    __block NSString *gas      = @"";
    __block NSString *signer   = @"";
    __block NSString *gasPrice = @"";

    NSMutableArray *clauseModelList = [[NSMutableArray alloc]init];

    [self testbConnex:bConnex clauseModelList:clauseModelList gas:&gas gasPrice:&gasPrice signer:&signer callbackParams:callbackParams];
    
//    if (bConnex) { // Connex
//
//        NSArray *clauseList = callbackParams[@"clauses"];
//
//        for (NSDictionary *clauseDict in clauseList) {
//
//            ClauseModel *clauseModel = [[ClauseModel alloc]init];
//            clauseModel.to    = clauseDict[@"to"];
//            clauseModel.value = clauseDict[@"value"];
//            clauseModel.data  = clauseDict[@"data"];
//
//            [clauseModelList addObject:clauseModel];
//        }
//
//        gas        = callbackParams[@"options"][@"gas"];
//        gasPrice   = callbackParams[@"options"][@"gasPrice"];
//
//        gasPrice   = @"120"; //connex js No pass gaspPrice write default
//
//        signer       = callbackParams[@"options"][@"signer"];
//
//    }else{ // Web3
//
//        ClauseModel *clauseModel = [[ClauseModel alloc]init];
//        clauseModel.to    = callbackParams[@"to"];
//        clauseModel.value = callbackParams[@"value"];
//        clauseModel.data  = callbackParams[@"data"];
//
//        gas        = callbackParams[@"gas"];
//        gasPrice   = callbackParams[@"gasPrice"];
//
//        [clauseModelList addObject:clauseModel];
//    }
    
    if (gas.integerValue == 0) {
        
        gas = [NSString stringWithFormat:@"%d",[WalletDAppGasCalculateHandle getGas:clauseModelList]];
        
        WalletDappSimulateMultiAccountApi *simulateApi = [[WalletDappSimulateMultiAccountApi alloc]initClause:clauseModelList opts:@{} revision:@""];
        [simulateApi loadDataAsyncWithSuccess:^(WalletBaseApi *finishApi) {
            
            NSArray *list = (NSArray *)finishApi.resultDict;
            NSString *gasUsed = [list firstObject][@"gasUsed"];
            if (gasUsed.integerValue != 0) {
                //Gasused If it is not 0,  need to add 15000
                gas = [NSString stringWithFormat:@"%ld",gas.integerValue + gasUsed.integerValue + 15000];
            }
            
            [self callbackClauseList:clauseModelList gas:gas signer:signer bConnex:bConnex webView:webView callbackId:callbackId requestId:requestId];

        }failure:^(WalletBaseApi *finishApi, NSString *errMsg) {
            
            [self paramsError:requestId webView:webView callbackId:callbackId];

        }];
    }else{
        [self callbackClauseList:clauseModelList gas:gas signer:signer bConnex:bConnex webView:webView callbackId:callbackId requestId:requestId];
    }
}

- (void)testbConnex:(BOOL)bConnex clauseModelList:(NSMutableArray *)clauseModelList gas:(NSString **)gas gasPrice:(NSString **)gasPrice signer:(NSString **)signer callbackParams:(NSDictionary *)callbackParams
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

- (void)callbackClauseList:(NSArray *)clauseModelList gas:(NSString *)gas signer:(NSString *)signer bConnex:(BOOL)bConnex  webView:(WKWebView *)webView callbackId:(NSString *)callbackId requestId:(NSString *)requestId
{
    id delegate = [WalletDAppHandle shareWalletHandle].delegate;
    if (delegate) {
        if ([delegate respondsToSelector:@selector(onWillTransfer: signer: gas: completionHandler:)]) {
            
            [delegate onWillTransfer:clauseModelList signer:signer gas:gas completionHandler:^(NSString * txId,NSString *signer)
             {
                 [self callbackToWebView:txId
                                 signer:signer
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
                                          code:ERROR_REJECTED];
        }
    }
}

//Call back to dapp webview
- (void)callbackToWebView:(NSString *)txid signer:(NSString *)signer bConnex:(BOOL)bConnex  webView:(WKWebView *)webView callbackId:(NSString *)callbackId requestId:(NSString *)requestId
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
                                      code:ERROR_NETWORK];
    }
}

- (void)paramsError:(NSString *)requestId webView:(WKWebView *)webView callbackId:(NSString *)callbackId
{
    [WalletTools callbackWithrequestId:requestId webView:webView data:@"" callbackId:callbackId code:ERROR_NETWORK];
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
