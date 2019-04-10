//
//  TransactionParameter.h
//  WalletSDK
//
//  Created by 曾新 on 2019/4/7.
//  Copyright © 2019年 Ethers. All rights reserved.
//

//#import <PromiseKit/PromiseKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface TransactionParameter : NSObject


@property (nonatomic, copy)NSString *gas;   //Set maximum gas allowed for call(deciaml string)

@property (nonatomic, copy)NSString *chainTag;  //Get the chain tag of the block chain

@property (nonatomic, copy)NSString *blockReference;  //Get the reference of the block chain

@property (nonatomic, copy)NSString *nonce;// 8 bytes of random number,hex string

@property (nonatomic, copy)NSString *dependsOn; // txid depends other transfer

@property (nonatomic, copy)NSString *gasPriceCoef; //Coefficient used to calculate the final gas price

@property (nonatomic, copy)NSString *expiration; //  Expiration relative to blockRef
@property (nonatomic, copy)NSArray *clauses; //clause list

@property (nonatomic, copy)NSArray<NSData *> *reserveds;


- (void)checkParameter:(void(^)(NSString *error,BOOL result))block; //check param


@end


@interface ClauseModel : NSObject
@property (nonatomic, copy)NSString *to;    //The first argument of the clause，If it is VET transfer, it is the to address; otherwise it is the contract address.
@property (nonatomic, copy)NSString *value; //The second argument of the clause ，Cost vet；If you don’t spend vet, value = [NSData data]
@property (nonatomic, copy)NSString *data;  //The third argument of the clause ，If it is VET transfer, data = [NSData data]；If it is a contract, data is the signature parameter.
#warning 方法参数
@end


NS_ASSUME_NONNULL_END
