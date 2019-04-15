//
//  WalletDappLogEventApi.h
//  VeWallet
//
//  Created by 曾新 on 2019/4/11.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "VCBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletDappLogEventApi : VCBaseApi

-(instancetype)initWithKind:(NSString *)kind;

@property (nonatomic , strong)NSDictionary *dictRange;
@property (nonatomic , strong)NSDictionary *dictOptions;
@property (nonatomic , strong)NSDictionary *dictCriteriaSet;
@property (nonatomic , copy)NSString *order;

@end

NS_ASSUME_NONNULL_END
