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


#define sdkVersion  @"1.0.0"

static int OK = 1;
static int ERROR_NETWORK = 500;
static int ERROR_CANCEL = 400 ;//User cancelled

static NSString *ERROR_NETWORK_MSG = @"network error";
static NSString *ERROR_CANCEL_MSG = @"User cancelled";



#endif /* WalletDAppHead_h */
