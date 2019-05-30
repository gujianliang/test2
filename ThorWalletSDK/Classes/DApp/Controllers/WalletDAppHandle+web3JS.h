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
