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
static int ERROR_REQUEST_PARAMS = 200;
static int ERROR_REQUEST_METHOD = 201;
static int ERROR_REQUEST_MULTI_CLAUSE = 400;
static int ERROR_REQUEST_QR_TOO_LONG = 400;//QR data is too long
static int ERROR_NETWORK = 500;
static int ERROR_SERVER_DATA = 500;
static int ERROR_CANCEL = 400 ;//User cancelled

static int ERROR_INITDAPP_ERROR = 500;

static NSString *ERROR_REQUEST_PARAMS_MSG = @"request params error";
static NSString *ERROR_REQUEST_METHOD_MSG = @"method not exist error";
static NSString *ERROR_REQUEST_MULTI_CLAUSE_MSG = @"Multiple clause is not supported";
static NSString *ERROR_REQUEST_QR_TOO_LONG_MSG = @"QR data is too long";
static NSString *ERROR_NETWORK_MSG = @"network error";
static NSString *ERROR_SERVER_DATA_MSG = @"data error";
static NSString *ERROR_CANCEL_MSG = @"User cancelled";
static NSString *ERROR_INITDAPP_ERROR_MSG = @"dApp init error";



#endif /* WalletDAppHead_h */
