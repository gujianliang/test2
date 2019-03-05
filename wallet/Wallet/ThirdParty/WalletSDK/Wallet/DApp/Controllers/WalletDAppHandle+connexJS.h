//
//  WalletDAppHandle+connexJS.h
//  VeWallet
//
//  Created by 曾新 on 2019/1/23.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletDAppHandle.h"
#import <WebKit/WebKit.h>
#import "WalletSignatureView.h"
#import "WalletDAppHead.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletDAppHandle (connexJS)

-(void)getGenesisBlockWithRequestId:(NSString *)requestId
                  completionHandler:(void (^)(NSString * __nullable result))completionHandler;


-(void)getStatusWithRequestId:(NSString *)requestId
            completionHandler:(void (^)(NSString * __nullable result))completionHandler;

- (void)getAccountRequestId:(NSString *)requestId
                    webView:(WKWebView *)webView
                    address:(NSString *)address
                 callbackId:(NSString *)callbackId;

- (void)getAccountCode:(NSString *)callbackId
               webView:(WKWebView *)webView
             requestId:(NSString *)requestId
               address:(NSString *)address;


- (void)getBlock:(NSString *)callbackId
         webView:(WKWebView *)webView
       requestId:(NSString *)requestId
        revision:(NSString *)revision;

- (void)getTransaction:(NSString *)callbackId
               webView:(WKWebView *)webView
             requestId:(NSString *)requestId
                  txID:(NSString *)txID;


- (void)getTransactionReceipt:(NSString *)callbackId
                      webView:(WKWebView *)webView
                    requestId:(NSString *)requestId
                         txid:(NSString *)txid;

-(void)getAccountsWithRequestId:(NSString *)requestId
                     callbackId:(NSString *)callbackId
                        webView:(WKWebView *)webView;


- (void)VETTransferDictWithParamModel:(WalletSignParamModel *)paramModel
                            requestId:(NSString *)requestId
                              webView:(WKWebView *)webView
                           callbackId:(NSString *)callbackId;

- (void)VTHOTransferWithParamModel:(WalletSignParamModel *)paramModel
                         requestId:(NSString *)requestId
                           webView:(WKWebView *)webView
                        callbackId:(NSString *)callbackId;

- (void)contractSignWithParamModel:(WalletSignParamModel *)paramModel
                         requestId:(NSString *)requestId
                           webView:(WKWebView *)webView
                        callbackId:(NSString *)callbackId;

- (void)methodAsClauseWithDictP:(NSDictionary *)dictP
                      requestId:(NSString *)requestId
              completionHandler:(void (^)(NSString * __nullable result))completionHandler;


- (void)certTransferDictParam:(NSMutableDictionary *)dictParam
                         from:(NSString *)from
                    requestId:(NSString *)requestId
                      webView:(WKWebView *)webView
                   callbackId:(NSString *)callbackId;



@end

NS_ASSUME_NONNULL_END
