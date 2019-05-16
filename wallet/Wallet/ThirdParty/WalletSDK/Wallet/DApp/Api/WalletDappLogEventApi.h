//
//  WalletDappLogEventApi.h
//  VeWallet
//
//  Created by Tom on 2019/4/11.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletDappLogEventApi : WalletBaseApi

-(instancetype)initWithKind:(NSString *)kind;

@property (nonatomic , strong)NSDictionary *dictRange;
@property (nonatomic , strong)NSDictionary *dictOptions;
@property (nonatomic , strong)NSDictionary *dictCriteriaSet;
@property (nonatomic , copy)NSString *order;

@end

NS_ASSUME_NONNULL_END
