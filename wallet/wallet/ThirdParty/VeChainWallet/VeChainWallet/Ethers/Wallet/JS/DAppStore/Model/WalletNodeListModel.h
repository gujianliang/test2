//
//  WalletNodeListModel.h
//  VCWallet
//
//  Created by 曾新 on 2018/5/9.
//  Copyright © 2018年 VeChain. All rights reserved.
//

#import "VCBaseModel.h"
@class  WalletNodeModel;

@interface WalletNodeListModel : VCBaseModel
@property (nonatomic, copy)NSArray<WalletNodeModel *> *addressInfos;
@end

@interface WalletNodeModel :VCBaseModel

@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *nodeType;
@property (nonatomic, copy)NSString *name;

@end
