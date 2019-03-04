//
//  TransactionParameter.h
//  WalletSDK
//
//  Created by 曾新 on 2019/2/27.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransactionParameter : NSObject

@property (nonatomic, copy)NSString *from;  //payer address（Hex string）
@property (nonatomic, copy)NSString *to;    //The first argument of the clause，If it is VET transfer, it is the to address; otherwise it is the token address.
@property (nonatomic, copy)NSString *value; //The second argument of the clause ，Cost vet；If you don’t spend vet, value = [NSData data]
@property (nonatomic, copy)NSString *data;  //The third argument of the clause ，If it is VET transfer, data = [NSData data]；If it is a contract, data is the signature parameter.
@property (nonatomic, copy)NSString *gas;   //Set maximum gas allowed for call(10 hex string)

@end

NS_ASSUME_NONNULL_END
