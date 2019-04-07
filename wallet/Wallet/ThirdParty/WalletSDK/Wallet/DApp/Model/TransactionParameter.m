//
//  TransactionParameter.m
//  WalletSDK
//
//  Created by 曾新 on 2019/4/7.
//  Copyright © 2019年 Ethers. All rights reserved.
//

#import "TransactionParameter.h"
#import "WalletDappCheckParamsHandle.h"

@implementation TransactionParameter

- (void)checkParameter:(void(^)(NSString *error,BOOL result))block
{
    [WalletDappCheckParamsHandle checkParamClause:self callback:^(NSString * _Nonnull error, bool result)
     {
         if (!result) {
             block(error,result);
         }else{
             block(nil,YES);
         }
     }];
}

- (AnyPromise *)getChainTag
{
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        [WalletUtils getChainTag:^(NSString * _Nonnull chainTag) {
            if (chainTag.length != 0) {
                resolve(chainTag);
            }else{
                resolve(@"error");
            }
        }];
    }];
}

- (AnyPromise *)getBlockRef
{
    
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolve) {
        
        [WalletUtils getBlockReference:^(NSString * _Nonnull blockReference) {
            
            if (blockReference.length != 0) {
                resolve(blockReference);
            }else{
                resolve(@"error");
            }
        }];
    }];
}

@end

@implementation ClauseModel


@end
