//
//  TransactionParameter.h
//  WalletSDK
//
//  Created by 曾新 on 2019/4/7.
//  Copyright © 2019年 Ethers. All rights reserved.
//

#import "YYModel.h"
#import <PromiseKit/PromiseKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface TransactionParameter : NSObject

@property (nonatomic, copy)NSString *gas;   //Set maximum gas allowed for call(10 hex string)

@property (nonatomic, copy)NSString *chainTag; //block chain tag

@property (nonatomic, copy)NSString *blockRef; //best block reference

@property (nonatomic, copy)NSString *noce;// 8 btye

@property (nonatomic, copy)NSString *dependsOn; // txid depends other transfer

@property (nonatomic, copy)NSString *gasPriceCoef; //

@property (nonatomic, copy)NSString *expiration; // expiration time s

@property (nonatomic, copy)NSArray *clauses; //clause list

@property (nonatomic, copy)NSArray<NSData *> *reserveds;


- (void)checkParameter:(void(^)(NSString *error,BOOL result))block; //check param invild

- (AnyPromise *)getChainTag;
- (AnyPromise *)getBlockRef;

@end


@interface ClauseModel : NSObject
@property (nonatomic, copy)NSString *to;    //The first argument of the clause，If it is VET transfer, it is the to address; otherwise it is the token address.
@property (nonatomic, copy)NSString *value; //The second argument of the clause ，Cost vet；If you don’t spend vet, value = [NSData data]
@property (nonatomic, copy)NSString *data;  //The third argument of the clause ，If it is VET transfer, data = [NSData data]；If it is a contract, data is the signature parameter.
@end


NS_ASSUME_NONNULL_END
