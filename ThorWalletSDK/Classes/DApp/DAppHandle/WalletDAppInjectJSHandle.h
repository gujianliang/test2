//
//  WalletDAppInjectJSHandle.h
//  AFNetworking
//
//  Created by 曾新 on 2019/6/6.
//

#import <WebKit/WebKit.h>
#import <Foundation/Foundation.h>
#import "WalletVersionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletDAppInjectJSHandle : NSObject

+ (void)checkVersion:(WKWebViewConfiguration *)config
            callback:(void (^)(WalletVersionModel *versionModel))callback;

+ (BOOL)analyzeVersion:(WalletVersionModel *)versionModel;
@end

NS_ASSUME_NONNULL_END
