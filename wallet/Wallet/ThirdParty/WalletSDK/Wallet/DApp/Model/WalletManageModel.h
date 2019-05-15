//
//  WalletManageModel.h
//  VCWallet
//
//  Created by Tom on 2018/4/18.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "VCBaseModel.h"

@interface WalletCoinModel : VCBaseModel

@property (nonatomic, copy)NSString *symobl;
@property (nonatomic, copy)NSString *coinCount;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *walletName;
@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *transferGas;
@property (nonatomic, assign) NSUInteger decimals;

@end

@interface WalletManageModel : VCBaseModel

@property (nonatomic, copy)NSString *name; //钱包名
@property (nonatomic, copy)NSString *address; //vet 地址
@property (nonatomic, copy)NSString *VETCount;

@property (nonatomic, strong)WalletCoinModel *vthoModel;

@property (nonatomic, copy) NSString *keyStore;

@end

