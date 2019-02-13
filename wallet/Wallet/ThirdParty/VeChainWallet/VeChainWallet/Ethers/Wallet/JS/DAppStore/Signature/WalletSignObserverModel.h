//
//  WalletSignObserverModel.h
//  VeWallet
//
//  Created by 曾新 on 2018/10/26.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletSignObserverModel : NSObject

@property (nonatomic, copy)NSString *amount;//币的数量
@property (nonatomic, copy)NSString *cost;
@property (nonatomic, copy)NSString *gas;
@property (nonatomic, copy)NSString *gasPriceCoef;
@property (nonatomic, copy)NSString *to; //收款地址
@property (nonatomic, copy)NSString *from; //付款地址，授权地址
@property (nonatomic, copy)NSString *nonce;
@property (nonatomic, copy)NSString *symbol; //币类型
@property (nonatomic, copy)NSString *chainTag;
@property (nonatomic, copy)NSString *blockRef;
@property (nonatomic, copy)NSString *contractAddress;
@property (nonatomic, copy)NSArray *contractParams;
@property (nonatomic, copy)NSString *methodId;


@end

NS_ASSUME_NONNULL_END
