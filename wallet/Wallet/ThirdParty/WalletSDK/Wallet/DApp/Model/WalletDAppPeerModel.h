//
//  WalletDAppPeerModel.h
//  VeWallet
//
//  Created by Tom on 2019/1/23.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#import "WalletBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletDAppPeerModel : WalletBaseModel

@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *bestBlockID;
@property (nonatomic, copy)NSString *totalScore;
@property (nonatomic, copy)NSString *peerID;
@property (nonatomic, copy)NSString *netAddr;
@property (nonatomic, copy)NSString *inbound;
@property (nonatomic, copy)NSString *duration;

@end

NS_ASSUME_NONNULL_END
