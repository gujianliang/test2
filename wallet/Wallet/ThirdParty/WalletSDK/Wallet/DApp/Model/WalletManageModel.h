//
//  WalletManageModel.h
//  VCWallet
//
//  Created by Tom on 2018/4/18.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletBaseModel.h"

@interface WalletCoinModel : WalletBaseModel

@property (nonatomic, copy)NSString *symobl;
@property (nonatomic, copy)NSString *coinCount;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *walletName;
@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *transferGas;
@property (nonatomic, assign) NSUInteger decimals;

@end

@interface WalletManageModel : WalletBaseModel

@property (nonatomic, copy)NSString *name; //wallet name
@property (nonatomic, copy)NSString *address; //vet address
@property (nonatomic, copy)NSString *VETCount;

@property (nonatomic, strong)WalletCoinModel *vthoModel;

@property (nonatomic, copy) NSString *keyStore;

@end

