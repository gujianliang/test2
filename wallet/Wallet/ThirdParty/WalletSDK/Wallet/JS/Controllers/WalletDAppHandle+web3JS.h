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


- (void)WEB3VETTransferFrom:(NSString *)from
                          to:(NSString *)to
                      amount:(NSString *)amount
                   requestId:(NSString *)requestId
                         gas:(NSString *)gas
                     webView:(WKWebView *)webView
                  callbackId:(NSString *)callbackId
                   gasCanUse:(BigNumber *)gasCanUse
                    gasPrice:(NSString *)gasPrice;

- (void)WEB3VTHOTransfer:(WalletSignatureView *)signaVC
                    from:(NSString *)from
                  to:(NSString *)to
              amount:(NSString *)amount
           requestId:(NSString *)requestId
                 gas:(NSString *)gas
            gasPrice:(NSString *)gasPrice
             webView:(WKWebView *)webView
          callbackId:(NSString *)callbackId
           gasCanUse:(BigNumber *)gasCanUse
           cluseData:(NSString *)cluseData
        tokenAddress:(NSString *)tokenAddress;


- (void)WEB3contractSign:(WalletSignatureView *)signaVC
                  to:(NSString *)to
               from:(NSString *)from
              amount:(NSString * )amount
           requestId:(NSString *)requestId
                 gas:(NSString *)gas
                gasPrice:(NSString *)gasPrice
               gasCanUse:(BigNumber *)gasCanUse
             webView:(WKWebView *)webView
          callbackId:(NSString *)callbackId
           cluseData:(NSString *)cluseData;


- (void)getChainTag:(NSString *)requestId
  completionHandler:(void (^)(NSString * __nullable result))completionHandler;

@end

NS_ASSUME_NONNULL_END
