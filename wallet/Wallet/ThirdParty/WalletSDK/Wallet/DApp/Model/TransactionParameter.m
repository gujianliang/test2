//
//  TransactionParameter.m
//  WalletSDK
//
//  Created by 曾新 on 2019/2/27.
//  Copyright © 2019年 VeChain. All rights reserved.
//
#import "WalletDappCheckParamsHandle.h"
#import "TransactionParameter.h"

@implementation TransactionParameter

- (void)checkParam:(void(^)(NSString *error,BOOL result))block
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

@end

@implementation ClauseModel


@end
