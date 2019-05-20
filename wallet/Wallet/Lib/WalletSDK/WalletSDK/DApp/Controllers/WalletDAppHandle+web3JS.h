//
//  WalletDAppHandle+web3JSHardle.h
//  VeWallet
//
//  Created by Tom on 2019/1/23.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletDAppHandle.h"
#import <WebKit/WebKit.h>
#import "WalletDAppHead.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletDAppHandle (web3JS)

- (void)getBalance:(NSString *)callbackId
           webView:(WKWebView *)webView
         requestId:(NSString *)requestId
           address:(NSString *)address;


- (void)getNodeUrl:(NSString *)requestId
  completionHandler:(void (^)(NSString * __nullable result))completionHandler;

//Get chaintag
- (void)getChainTag:(NSString *)requestId
  completionHandler:(void (^)(NSString * __nullable result))completionHandler;

//Get the local wallet address
-(void)getAccountsWithRequestId:(NSString *)requestId
                     callbackId:(NSString *)callbackId
                        webView:(WKWebView *)webView;
@end

NS_ASSUME_NONNULL_END
