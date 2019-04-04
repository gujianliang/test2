//
//  WalletDappCheckParamsHandle.h
//  WalletSDK
//
//  Created by 曾新 on 2019/4/2.
//  Copyright © 2019年 Ethers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionParameter.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletDappCheckParamsHandle : NSObject


+ (void)checkParamClause:(TransactionParameter *)parameterModel
                callback:(void(^)(NSString *error,bool result))callback;

@end

NS_ASSUME_NONNULL_END
