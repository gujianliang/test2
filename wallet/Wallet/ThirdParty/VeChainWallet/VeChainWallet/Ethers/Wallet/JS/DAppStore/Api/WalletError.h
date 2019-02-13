//
//  WalletError.h
//  Wallet
//
//  Created by 曾新 on 16/4/7.
//  Copyright © 2016年 Eagle. All rights reserved.
//

#ifndef WalletError_h
#define WalletError_h

#define kWalletErrorDomain                     @"Wallet"

#define Wallet_ERROR_INVALID_DATA_FORMAT       40001


#define Wallet_ERROR_ASIHTTP                   999

#define Wallet_ERROR_OK                        1

#define Wallet_TOKEN_OUT                       400001

#define Wallet_APP_UPDATE                      42600
//#define Wallet_APP_UPDATE                      42601

#define Wallet_MSG_DEFAULT                     VCNSLocalizedBundleString(@"Unknown error", nil)
#define Wallet_MSG_INVALID_DATA_FORMAT         VCNSLocalizedBundleString(@"数据格式错误", nil)
#define Wallet_MSG_ASIHTTP                     VCNSLocalizedBundleString(@"no_network_hint", nil)

#endif /* WalletError_h */
