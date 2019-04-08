//
//  TransactionParameter.m
//  WalletSDK
//
//  Created by 曾新 on 2019/4/7.
//  Copyright © 2019年 Ethers. All rights reserved.
//

#import "TransactionParameter.h"
#import "WalletDappCheckParamsHandle.h"
#import "YYModel.h"

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

@end

@implementation ClauseModel


@end
