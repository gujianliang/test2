//
//  WalletDAppStoreVC.h
//  VeWallet
//
//  Created by 曾新 on 2019/1/11.
//  Copyright © 2019年 VeChain. All rights reserved.
//

//#import "VCBaseVC.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletDAppStoreVC : NSObject

-(instancetype)initWithWalletDict:(NSMutableArray *)walletList;

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler;


- (void)injectJS:(WKWebView *)webview;

@end

NS_ASSUME_NONNULL_END
