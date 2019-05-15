//
//  WalletBalanceModel.h
//  VCWallet
//
//  Created by Tom on 2018/5/10.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "VCBaseModel.h"

@interface WalletBalanceModel : VCBaseModel

//Token 余额

@property (nonatomic, copy)NSString *data;
@property (nonatomic, copy)NSString *gasUsed;
@property (nonatomic, copy)NSString *reverted;
@property (nonatomic, copy)NSString *vmError;

//VET 余额
@property (nonatomic, copy)NSString *balance;
@property (nonatomic, copy)NSString *energy;
@property (nonatomic, copy)NSString *hasCode;


@end
