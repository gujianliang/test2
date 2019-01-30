//
//  WalletDAppStoreVC+ConnexJSHandle.h
//  VeWallet
//
//  Created by 曾新 on 2019/1/23.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletDAppStoreVC.h"
#import <WebKit/WebKit.h>
#import "WalletSignatureView.h"
#import "WalletDAppHead.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletDAppStoreVC (ConnexJSHandle)

-(void)getGenesisBlockWithRequestId:(NSString *)requestId
                  completionHandler:(void (^)(NSString * __nullable result))completionHandler;


-(void)getStatusWithRequestId:(NSString *)requestId
            completionHandler:(void (^)(NSString * __nullable result))completionHandler;

- (void)getAccountRequestId:(NSString *)requestId
                    webView:(WKWebView *)webView
                    address:(NSString *)address
                 callbackID:(NSString *)callbackID;

- (void)getAccountCode:(NSString *)callbackID
               webView:(WKWebView *)webView
             requestId:(NSString *)requestId
               address:(NSString *)address;


- (void)getBlock:(NSString *)callbackID
         webView:(WKWebView *)webView
       requestId:(NSString *)requestId
        revision:(NSString *)revision;

- (void)getTransaction:(NSString *)callbackID
               webView:(WKWebView *)webView
             requestId:(NSString *)requestId
                  txID:(NSString *)txID;


- (void)getTransactionReceipt:(NSString *)callbackID
                      webView:(WKWebView *)webView
                    requestId:(NSString *)requestId
                         txid:(NSString *)txid;

-(void)getAccountsWithRequestId:(NSString *)requestId
                     callbackID:(NSString *)callbackID
                        webView:(WKWebView *)webView;


- (void)VETTransferDictParam:(NSMutableDictionary *)dictParam
               from:(NSString *)from
                 to:(NSString *)to
      amountTnteger:(CGFloat)amountTnteger
          requestId:(NSString *)requestId
                gas:(NSNumber *)gas
            webView:(WKWebView *)webView
         callbackID:(NSString *)callbackID;


- (void)VTHOTransferDictParam:(NSMutableDictionary *)dictParam
                from:(NSString *)from
                  to:(NSString *)to
           requestId:(NSString *)requestId
                 gas:(NSNumber *)gas
             webView:(WKWebView *)webView
          callbackID:(NSString *)callbackID
           gasCanUse:(BigNumber *)gasCanUse
          clauseData:(NSString *)clauseData;

- (void)contractSignDictParam:(NSMutableDictionary *)dictParam
                  to:(NSString *)to
                         from:(NSString *)from
       amountTnteger:(CGFloat )amountTnteger
           requestId:(NSString *)requestId
                 gas:(NSNumber *)gas
             webView:(WKWebView *)webView
          callbackID:(NSString *)callbackID
          clauseData:(NSString *)clauseData;

- (void)methodAsClauseWithDictP:(NSDictionary *)dictP
                      requestId:(NSString *)requestId
              completionHandler:(void (^)(NSString * __nullable result))completionHandler;



@end

NS_ASSUME_NONNULL_END
