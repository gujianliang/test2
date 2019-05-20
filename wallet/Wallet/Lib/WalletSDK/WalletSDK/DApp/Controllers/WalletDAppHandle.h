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
