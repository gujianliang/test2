//
//  WalletBalanceModel.h
//  VCWallet
//
//  Created by Tom on 2018/5/10.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "WalletBaseModel.h"

@interface WalletBalanceModel : WalletBaseModel

//Token balance

@property (nonatomic, copy)NSString *data;
@property (nonatomic, copy)NSString *gasUsed;
@property (nonatomic, copy)NSString *reverted;
@property (nonatomic, copy)NSString *vmError;

//VET balaance
@property (nonatomic, copy)NSString *balance;
@property (nonatomic, copy)NSString *energy;
@property (nonatomic, copy)NSString *hasCode;


@end
