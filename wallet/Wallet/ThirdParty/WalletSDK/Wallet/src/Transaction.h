

#import <Foundation/Foundation.h>
#import "Address.h"
#import "BigNumber.h"
#import "Hash.h"
#import "Signature.h"

typedef NS_OPTIONS(unsigned char, ChainId)  {
    ChianIdAny          = 0x00,
    ChainIdHomestead    = 0x01,
    ChainIdMorden       = 0x02,
    ChainIdRopsten      = 0x03,
    ChainIdRinkeby      = 0x04,
    ChainIdKovan        = 0x2a,
};

extern NSString * _Nullable chainName(ChainId chainId);
@class Account;
//typedef unsigned long long Nonce;


@interface Transaction : NSObject

+ (nonnull instancetype)transaction;
+ (nonnull instancetype)transactionWithFromAddress: (nonnull Address*)fromAddress;

+ (nonnull instancetype)transactionWithData: (nonnull NSData*)transactionData;

@property (nonatomic, assign) NSUInteger nonce;

@property (nonatomic, strong, nonnull) BigNumber *gasPrice;
@property (nonatomic, strong, nonnull) BigNumber *gasLimit;

@property (nonatomic, strong, nullable) Address *toAddress;
@property (nonatomic, strong, nonnull) BigNumber *value;

@property (nonatomic, strong, nonnull) NSData *dependsOn;


@property (nonatomic, strong, nonnull) NSData *data;

@property (nonatomic, strong, nullable) Signature *signature;

@property (nonatomic, readonly, nullable) Address *fromAddress;

@property (nonatomic, assign) ChainId chainId;

// 新增
@property (nonatomic, assign) NSInteger Expiration;
@property (nonatomic, strong, nonnull) BigNumber *ChainTag;
@property (nonatomic, strong, nonnull) BigNumber *BlockRef;
@property (nonatomic, strong, nonnull) NSArray *Clauses;

- (NSString *_Nullable)txID:(Account *_Nonnull)account;

- (nonnull NSData*)serialize;

- (nonnull NSData*)unsignedSerialize;

- (BOOL)populateSignatureWithR: (nonnull NSData*)r s: (nonnull NSData*)s address: (nonnull Address*)address;


@property (nonatomic, readonly, nullable) Hash *transactionHash;

// 观察钱包获得 txid
- (NSString *_Nullable)obersverTxID:(NSString *_Nullable)address;

- (NSData *_Nullable)getSigntureMessage;

@end
