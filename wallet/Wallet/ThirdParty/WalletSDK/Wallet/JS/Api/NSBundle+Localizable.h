//
//  NSBundle+Localizable.h
//  walletSDK
//
//  Created by 曾新 on 2019/1/30.
//  Copyright © 2019年 VeChain. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (Localizable)

+ (instancetype)NSLocalizedString:(NSString *)bundleName;
+ (instancetype)XDX_localizableBundleWithBundleName:(NSString *)bundleName;
+ (NSString *)XDX_localizedStringForKey:(NSString *)key value:(NSString *)value;

+ (NSString *)XDX_localizedStringForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
