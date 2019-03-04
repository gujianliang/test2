//
//  WalletSignatureViewHandle.h
//  WalletSDK
//
//  Created by 曾新 on 2019/2/14.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WalletManageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletSignatureViewHandle : NSObject

- (void)checkBalcanceFromAddress:(NSString *)fromAddress amount:(NSString *)amount gasLimit:(NSString *)gasLimit block:(void(^)())blcok;

- (void)tokenAddressConvetCoinInfo:(NSString *)tokenAddress coinModel:(WalletCoinModel *)coinModel block:(void(^)(void))block;
@end

NS_ASSUME_NONNULL_END
