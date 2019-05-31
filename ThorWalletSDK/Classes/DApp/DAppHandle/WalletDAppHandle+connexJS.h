/**
    Copyright (c) 2019 vechaindev <support@vechain.com>

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

//
//  WalletDAppHandle+connexJS.h
//  VeWallet
//
//  Created by vechaindev on 2019/1/23.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletDAppHandle.h"
#import <WebKit/WebKit.h>
#import "WalletDAppHeader.h"

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
