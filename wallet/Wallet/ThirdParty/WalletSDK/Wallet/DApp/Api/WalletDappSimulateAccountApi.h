//
//  WalletDappSimulateAccountApi.h
//  VeWallet
//
//  Created by 曾新 on 2019/4/11.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "VCBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletDappSimulateAccountApi : VCBaseApi

-(instancetype)initClause:(NSDictionary *)clause opts:(NSDictionary *)opts  revision:(NSString *)revision;

@end

NS_ASSUME_NONNULL_END
