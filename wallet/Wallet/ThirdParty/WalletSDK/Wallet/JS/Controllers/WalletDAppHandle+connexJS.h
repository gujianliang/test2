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


- (void)VETTransferDictParam:(NSMutableDictionary *)dictParam
               from:(NSString *)from
                 to:(NSString *)to
      amountTnteger:(CGFloat)amountTnteger
          requestId:(NSString *)requestId
                gas:(NSNumber *)gas
            webView:(WKWebView *)webView
         callbackId:(NSString *)callbackId;


- (void)VTHOTransferDictParam:(NSMutableDictionary *)dictParam
                         from:(NSString *)from
                  tokenAddress:(NSString *)tokenAddress
                    toAddress:(NSString *)toAddress
           requestId:(NSString *)requestId
                 gas:(NSNumber *)gas
             webView:(WKWebView *)webView
          callbackId:(NSString *)callbackId
        gasPriceCoef:(NSString *)gasPriceCoef
          clauseData:(NSString *)clauseData;

- (void)contractSignDictParam:(NSMutableDictionary *)dictParam
                  to:(NSString *)to
                from:(NSString *)from
       amountTnteger:(CGFloat )amountTnteger
           requestId:(NSString *)requestId
                 gas:(NSNumber *)gas
             webView:(WKWebView *)webView
          callbackId:(NSString *)callbackId
          clauseData:(NSString *)clauseData;

- (void)methodAsClauseWithDictP:(NSDictionary *)dictP
                      requestId:(NSString *)requestId
              completionHandler:(void (^)(NSString * __nullable result))completionHandler;



- (BOOL)errorAmount:(NSString *)amount coinName:(NSString *)coinName;

- (BOOL)errorAddressAlert:(NSString *)toAddress;


@end

NS_ASSUME_NONNULL_END
