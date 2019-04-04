//
//  WalletDAppHandle.h
//  VeWallet
//
//  Created by 曾新 on 2019/1/11.
//  Copyright © 2019年 VeChain. All rights reserved.
//

//#import "VCBaseVC.h"

#import <UIKit/UIKit.h>

//#import "WalletDAppHandle+transfer.h"
NS_ASSUME_NONNULL_BEGIN

@interface WalletDAppHandle : NSObject

+ (instancetype)shareWalletHandle;

@property (nonatomic, strong)id delegate;
@property (nonatomic, copy)NSString *keystore;
@property (nonatomic, assign)BOOL isSend;
@property (nonatomic, copy)NSString *txId;

-(void)initWithWalletDict:(NSMutableArray *)walletList;

- (void)webView:(WKWebView *)webView defaultText:(nullable NSString *)defaultText completionHandler:(void (^)(NSString * __nullable result))completionHandler;

- (void)injectJS:(WKWebView *)webview;

+ (void)attempDealloc;

@end

NS_ASSUME_NONNULL_END
