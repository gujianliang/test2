//
//  WalletDAppHead.h
//  VeWallet
//
//  Created by Tom on 2019/1/23.
//  Copyright © 2019年 VeChain. All rights reserved.
//

#ifndef WalletDAppHead_h
#define WalletDAppHead_h

#import "Payment.h"
#import "SecureData.h"
#import "Account.h"
#import "Transaction.h"
#import "WalletSDKMacro.h"



static int OK = 1;
static int ERROR_NETWORK = 500;
static int ERROR_REJECTED  = 400;//User cancelled

static NSString *ERROR_NETWORK_MSG = @"NetError";
static NSString *ERROR_REJECTED_MSG  = @"Rejected";


#endif /* WalletDAppHead_h */
