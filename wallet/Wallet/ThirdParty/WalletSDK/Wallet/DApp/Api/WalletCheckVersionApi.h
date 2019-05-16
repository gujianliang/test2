//
//  WalletCheckVersionApi.h
//  WalletSDK
//
//  Created by Tom on 2019/5/9.
//  Copyright © 2019年 Ethers. All rights reserved.
//

#import "WalletBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletCheckVersionApi : WalletBaseApi

-(instancetype)initWithVersion:(NSString *)version language:(NSString *)language;

@end

NS_ASSUME_NONNULL_END
