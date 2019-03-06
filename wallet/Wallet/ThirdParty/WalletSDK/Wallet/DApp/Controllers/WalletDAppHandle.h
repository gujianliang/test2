//
//  WalletDAppHandle.h
//  VeWallet
//
//  Created by 曾新 on 2019/1/11.
//  Copyright © 2019年 VeChain. All rights reserved.
//

//#import "VCBaseVC.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletDAppHandle : NSObject

+ (instancetype)shareWalletHandle;

-(void)initWithWalletDict:(NSMutableArray *)walletList;

- (void)webView:(WKWebView *)webView defaultText:(nullable NSString *)defaultText completionHandler:(void (^)(NSString * __nullable result))completionHandler;

- (void)injectJS:(WKWebView *)webview;

+ (void)attempDealloc;

@end

NS_ASSUME_NONNULL_END
