//
//  WalletDAppHandle+connexJS.h
//  VeWallet
//
//  Created by Tom on 2019/1/23.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletDAppHandle.h"
#import <WebKit/WebKit.h>
#import "WalletDAppHead.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletDAppHandle (connexJS)

//Get the genesis block information
-(void)getGenesisBlockWithRequestId:(NSString *)requestId
                  completionHandler:(void (^)(NSString * __nullable result))completionHandler;

//Get block status
-(void)getStatusWithRequestId:(NSString *)requestId
            completionHandler:(void (^)(NSString * __nullable result))completionHandler;

//Get VET balance
- (void)getAccountRequestId:(NSString *)requestId
                    webView:(WKWebView *)webView
                    address:(NSString *)address
                 callbackId:(NSString *)callbackId;

//Get account code
- (void)getAccountCode:(NSString *)callbackId
               webView:(WKWebView *)webView
             requestId:(NSString *)requestId
               address:(NSString *)address;

//Get account storge
- (void)getStorageApiDictParam:(NSDictionary *)dictParam
                     requestId:(NSString *)requestId
                       webView:(WKWebView *)webView
                    callbackId:(NSString *)callbackId;


//Get information about a block
- (void)getBlock:(NSString *)callbackId
         webView:(WKWebView *)webView
       requestId:(NSString *)requestId
        revision:(NSString *)revision;

//Get transaction details
- (void)getTransaction:(NSString *)callbackId
               webView:(WKWebView *)webView
             requestId:(NSString *)requestId
                  txID:(NSString *)txID;

//Get transaction receipt
- (void)getTransactionReceipt:(NSString *)callbackId
                      webView:(WKWebView *)webView
                    requestId:(NSString *)requestId
                         txid:(NSString *)txid;

//Open ticker next
- (void)tickerNextRequestId:(NSString *)requestId
                 callbackId:(NSString *)callbackId;

//Simulate a single transaction
- (void)methodAsCallWithDictP:(NSDictionary *)dictP
                      requestId:(NSString *)requestId
                        webView:(WKWebView *)webView
                     callbackId:(NSString *)callbackId;

//Filter by condition
- (void)filterDictParam:(NSDictionary *)dictParam
              requestId:(NSString *)requestId
                webView:(WKWebView *)webView
             callbackId:(NSString *)callbackId;

//Simulate multiple transactions
- (void)explainDictParam:(NSDictionary *)dictParam
               requestId:(NSString *)requestId
                 webView:(WKWebView *)webView
              callbackId:(NSString *)callbackId;

//Determine if the local wallet has this address
- (void)checkAddressOwn:(NSString *)address
              requestId:(NSString *)requestId
             callbackId:(NSString *)callbackId
      completionHandler:(void (^)(NSString * __nullable result))completionHandler;

//Certification signature
- (void)certTransferParamModel:(NSDictionary *)callbackParams
                          from:(NSString *)from
                     requestId:(NSString *)requestId
                       webView:(WKWebView *)webView
                    callbackId:(NSString *)callbackId;

@end

NS_ASSUME_NONNULL_END
