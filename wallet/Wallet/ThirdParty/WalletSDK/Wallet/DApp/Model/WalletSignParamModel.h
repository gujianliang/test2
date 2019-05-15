//
//  WalletSignParamModel.h
//  WalletSDK
//
//  Created by Tom on 2019/2/27.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BigNumber.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletSignParamModel : NSObject

@property (nonatomic, strong)BigNumber *gasPriceCoef;
@property (nonatomic, copy)NSString *gas;
@property (nonatomic, copy)NSString *amount;
@property (nonatomic, copy)NSString *clauseData;
@property (nonatomic, copy)NSString *fromAddress;
@property (nonatomic, copy)NSString *toAddress;

@property (nonatomic, copy)NSString *tokenAddress;
@property (nonatomic, copy)NSString *keystore;
@property (nonatomic, copy)NSArray  *clauseList; // to ,value,data 添加顺序

@end

NS_ASSUME_NONNULL_END
