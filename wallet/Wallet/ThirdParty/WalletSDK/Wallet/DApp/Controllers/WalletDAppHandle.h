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

+ (instancetype)shareWalletHandle;

@property(nonatomic, weak) id<WalletUtilsDelegate> delegate;

@property (nonatomic, copy)NSString *keystore;
@property (nonatomic, assign)BOOL isSend;
@property (nonatomic, copy)NSString *txId;

- (void)webView:(WKWebView *)webView defaultText:(nullable NSString *)defaultText completionHandler:(void (^)(NSString * __nullable result))completionHandler;

- (void)injectJS:(WKWebViewConfiguration *)config;

+ (void)attempDealloc;

@end

NS_ASSUME_NONNULL_END
