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

- (void)getAddress:(WKWebView *)webView callbackId:(NSString *)callbackId;


- (void)web3VETTransferFrom:(NSString *)from
                          to:(NSString *)to
                      amount:(NSString *)amount
                   requestId:(NSString *)requestId
                         gas:(NSString *)gas
                     webView:(WKWebView *)webView
                  callbackId:(NSString *)callbackId
                    gasPrice:(NSString *)gasPrice;

- (void)web3VTHOTransferFrom:(NSString *)from
                  to:(NSString *)to
              amount:(NSString *)amount
           requestId:(NSString *)requestId
                 gas:(NSString *)gas
            gasPrice:(NSString *)gasPrice
             webView:(WKWebView *)webView
          callbackId:(NSString *)callbackId
           clauseData:(NSString *)clauseData
        tokenAddress:(NSString *)tokenAddress;


- (void)web3contractSignFrom:(NSString *)from
                  to:(NSString *)to
              amount:(NSString * )amount
           requestId:(NSString *)requestId
                 gas:(NSString *)gas
                gasPrice:(NSString *)gasPrice
             webView:(WKWebView *)webView
          callbackId:(NSString *)callbackId
           clauseData:(NSString *)clauseData;


- (void)getChainTag:(NSString *)requestId
  completionHandler:(void (^)(NSString * __nullable result))completionHandler;

@end

NS_ASSUME_NONNULL_END
