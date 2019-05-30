//
//  TransactionParameter.h
//  WalletSDK
//
//  Created by vechaindev on 2019/4/7.
//  Copyright © 2019年 VeChain. All rights reserved.
//

//#import <PromiseKit/PromiseKit.h>
NS_ASSUME_NONNULL_BEGIN

@class TransactionParameterBuiler;

@interface TransactionParameter : NSObject


@property (nonatomic, readonly)NSString *gas;   //Set maximum gas allowed for call(deciaml string)

@property (nonatomic, readonly)NSString *chainTag;  //Get the chain tag of the block chain

@property (nonatomic, readonly)NSString *blockReference;  //Get the reference of the block chain

@property (nonatomic, readonly)NSString *nonce;// 8 bytes of random number,hex string

@property (nonatomic, readonly)NSString *dependsOn; // txid depends other transfer

@property (nonatomic, readonly)NSString *gasPriceCoef; //Coefficient used to calculate the final gas price

@property (nonatomic, readonly)NSString *expiration; //  Expiration relative to blockRef
@property (nonatomic, readonly)NSArray *clauses; //clause list

@property (nonatomic, readonly)NSArray<NSData *> *reserveds;

+ (TransactionParameter *)creatTransactionParameter:(void(^)(TransactionParameterBuiler *builder))callback checkParams:(void(^)(NSString *errorMsg))checkParamsCallback;

@end


@interface TransactionParameterBuiler : NSObject

@property (nonatomic, copy)NSString *gas;   //Set maximum gas allowed for call(deciaml string)

@property (nonatomic, copy)NSString *chainTag;  //Get the chain tag of the block chain

@property (nonatomic, copy)NSString *blockReference;  //Get the reference of the block chain

@property (nonatomic, copy)NSString *nonce;// 8 bytes of random number,hex string

@property (nonatomic, copy)NSString *dependsOn; // txid depends other transfer

@property (nonatomic, copy)NSString *gasPriceCoef; //Coefficient used to calculate the final gas price

@property (nonatomic, copy)NSString *expiration; //  Expiration relative to blockRef
@property (nonatomic, copy)NSArray *clauses; //clause list

@property (nonatomic, copy)NSArray<NSData *> *reserveds;


- (TransactionParameter *)build;

@end

@interface ClauseModel : NSObject

@property (nonatomic, copy)NSString *to;    //The destination address of the message, null for a contract-creation transaction
@property (nonatomic, copy)NSString *value; //The value, with a unit of wei, transferred through the transaction. Specifically, it plays the role of endowment when the transaction is contract-creation type
@property (nonatomic, copy)NSString *data;  //Either the ABI byte string containing the data of the function call on a contract or the initialization code of a contract-creation transaction
@end


NS_ASSUME_NONNULL_END
