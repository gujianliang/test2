//
//  WalletTransantionsReceiptModel.h
//  VeWallet
//
//  Created by Tom on 2018/6/1.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "VCBaseModel.h"
@class blockModel;
@class outputsModel;
@class eventsModel;


@interface WalletTransantionsReceiptModel : VCBaseModel

@property (nonatomic, copy)NSString *paid;
@property (nonatomic, assign)BOOL reverted;
@property (nonatomic, strong)blockModel *meta;
@property (nonatomic, copy)NSString *gasPayer;
@property (nonatomic, copy)NSArray<outputsModel *> *outputs;


@end

@interface blockModel : VCBaseModel

@property (nonatomic, copy)NSString *blockID;
@property (nonatomic, copy)NSString *blockNumber;
@property (nonatomic, copy)NSString *blockTimestamp;
@property (nonatomic, copy)NSString *txOrigin;

@end

@interface outputsModel : VCBaseModel

@property (nonatomic, copy)NSArray<eventsModel *> *events;


@end

@interface eventsModel : VCBaseModel

@property (nonatomic, copy)NSString *address;


@end
