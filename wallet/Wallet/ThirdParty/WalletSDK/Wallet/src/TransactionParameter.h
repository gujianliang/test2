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

@property (nonatomic, copy)NSString *from;  //发送钱包地址（16进制String）
@property (nonatomic, copy)NSString *to;    //clause 第一个参数，如果是vet 转账，目标地址；如果是合约签名，是token地址
@property (nonatomic, copy)NSString *value; //clause 第二个参数 ，如果是vet 转账，就是转账的金额；如果是合约签名，是[NSData data]
@property (nonatomic, copy)NSString *data;  //clause 第三个参数，如果是vet 转账，[NSData data]；如果是合约签名，签名参数
@property (nonatomic, copy)NSString *gas;   //允许消耗的gas总量(10进制String)

@end

NS_ASSUME_NONNULL_END
