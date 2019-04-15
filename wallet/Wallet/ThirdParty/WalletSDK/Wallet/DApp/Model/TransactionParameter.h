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
@property (nonatomic, copy)NSString *to;    //The destination address of the message, null for a contract-creation transaction
@property (nonatomic, copy)NSString *value; //The value, with a unit of wei, transferred through the transaction. Specifically, it plays the role of endowment when the transaction is contract-creation type
@property (nonatomic, copy)NSString *data;  //Either the ABI byte string containing the data of the function call on a contract or the initialization code of a contract-creation transaction
@end


NS_ASSUME_NONNULL_END
