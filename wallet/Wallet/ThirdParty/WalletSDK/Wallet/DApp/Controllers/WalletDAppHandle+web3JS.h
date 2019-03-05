//
//  WalletDAppHandle+web3JSHardle.h
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

@interface WalletDAppHandle (web3JS)

- (void)getBalance:(NSString *)callbackId
           webView:(WKWebView *)webView
         requestId:(NSString *)requestId
           address:(NSString *)address;

- (void)getAddress:(WKWebView *)webView requestId:(NSString *)requestId callbackId:(NSString *)callbackId;

- (void)web3VETTransferWithParamModel:(WalletSignParamModel *)paramModel
                            requestId:(NSString *)requestId
                              webView:(WKWebView *)webView
                           callbackId:(NSString *)callbackId;

- (void)web3VTHOTransferWithParamModel:(WalletSignParamModel *)paramModel
                             requestId:(NSString *)requestId
                               webView:(WKWebView *)webView
                            callbackId:(NSString *)callbackId;


- (void)web3contractSignWithParamModel:(WalletSignParamModel *)paramModel
                             requestId:(NSString *)requestId
                               webView:(WKWebView *)webView
                            callbackId:(NSString *)callbackId;


- (void)getChainTag:(NSString *)requestId
  completionHandler:(void (^)(NSString * __nullable result))completionHandler;

@end

NS_ASSUME_NONNULL_END
