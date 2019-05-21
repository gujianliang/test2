//
//  WalletVersionModel.h
//  WalletSDK
//
//  Created by 曾新 on 2019/5/20.
//  Copyright © 2019 Ethers. All rights reserved.
//

#import "WalletBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletVersionModel : WalletBaseModel

@property (nonatomic, copy)NSString *update;
@property (nonatomic, copy)NSString *latestVersion;
@property (nonatomic, copy)NSString *pdescription;

@end

NS_ASSUME_NONNULL_END
