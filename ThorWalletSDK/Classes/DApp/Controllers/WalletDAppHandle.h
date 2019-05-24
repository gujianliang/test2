/**
    Copyright (c) 2019 Tom <tom.zeng@vechain.com>

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
//  WalletDAppHandle.h
//  VeWallet
//
//  Created by Tom on 2019/1/11.
//  Copyright © 2019年 VeChain. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "WalletUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletDAppHandle : NSObject


@property (nonatomic, assign) BOOL isSend;
@property (nonatomic, copy) NSString *txId;
@property (nonatomic, copy) NSString *keystore;
@property (nonatomic, weak) id<WalletUtilsDelegate> delegate;

+ (instancetype)shareWalletHandle;

- (void)webView:(WKWebView *)webView
    defaultText:(nullable NSString *)defaultText
completionHandler:(void (^)(NSString * __nullable result))completionHandler;

- (void)injectJS:(WKWebViewConfiguration *)config;

//Release object
+ (void)deallocDApp;

@end

NS_ASSUME_NONNULL_END
