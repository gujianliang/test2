//
//  WalletDappSimulateMultiAccountApi.h
//  VeWallet
//
//  Created by Tom on 2019/4/11.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletDappSimulateMultiAccountApi : WalletBaseApi

-(instancetype)initClause:(NSArray *)clauseList
                     opts:(NSDictionary *)opts
                 revision:(NSString *)revision;

@end

NS_ASSUME_NONNULL_END
