//
//  WalletBlockApi.h
//  VeWallet
//
//  Created by Tom on 2019/1/18.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "VCBaseApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletBlockApi : VCBaseApi

-(instancetype)initWithRevision:(NSString *)revision;

@end

NS_ASSUME_NONNULL_END
