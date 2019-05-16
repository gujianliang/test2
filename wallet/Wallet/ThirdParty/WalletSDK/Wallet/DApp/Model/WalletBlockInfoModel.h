//
//  WalletBlockInfoModel.h
//  VCWallet
//
//  Created by Tom on 2018/5/10.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletBaseModel.h"

@interface WalletBlockInfoModel : WalletBaseModel

@property (nonatomic, copy)NSString *number;
@property (nonatomic, copy)NSString *id;
@property (nonatomic, copy)NSString *size;
@property (nonatomic, copy)NSString *parentID;
@property (nonatomic, copy)NSString *timestamp;
@property (nonatomic, copy)NSString *gasLimit;
@property (nonatomic, copy)NSString *beneficiary;
@property (nonatomic, copy)NSString *gasUsed;
@property (nonatomic, copy)NSString *totalScore;
@property (nonatomic, copy)NSString *txsRoot;
@property (nonatomic, copy)NSString *stateRoot;
@property (nonatomic, copy)NSString *receiptsRoot;
@property (nonatomic, copy)NSString *signer;
@property (nonatomic, copy)NSString *transactions;


@end
