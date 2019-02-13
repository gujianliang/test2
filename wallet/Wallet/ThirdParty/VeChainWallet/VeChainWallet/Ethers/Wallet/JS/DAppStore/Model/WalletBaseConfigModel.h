//
//  WalletBaseConfigModel.h
//  VeWallet
//
//  Created by 曾新 on 2018/5/29.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "VCBaseModel.h"
@class walletInfoModel;

@interface WalletBaseConfigModel : VCBaseModel

@property (nonatomic, copy)NSArray<walletInfoModel *> *walletInfo;
@property (nonatomic, copy)NSString *gasPrice;
@property (nonatomic, copy)NSString *confirm_block;
@property (nonatomic, copy)NSString *chain_tag;

@end

@interface walletInfoModel : VCBaseModel
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSArray *addresses;
@property (nonatomic, copy)NSString *description_cn;
@property (nonatomic, copy)NSString *description_en;
@end
