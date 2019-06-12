//
//  WalletDAppGasCalculateHandle.m
//  Wallet
//
//  Created by VeChain on 2019/1/11.
//  Copyright © 2019 VeChain. All rights reserved.
//

// This code is distributed under the terms and conditions of the MIT license.

/**
 Copyright (c) 2019 VeChain <support@vechain.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 **/

//#import "WalletTools.h"
#import "WalletTools.h"
#import "WalletTransactionParameter.h"
#import "WalletDAppGasCalculateHandle.h"

@implementation WalletDAppGasCalculateHandle

+ (int)getGas:(NSArray *)clauseList
{
    int gas = 0;
    for (ClauseModel *model in clauseList) {
        
        NSString *to     = model.to;
        NSString *value  = model.value;
        NSString *data   = model.data;
        
        gas = gas + [self calculateSingleGasTo:&to value:&value data:&data];
    }
    return gas;
}

+ (int)calculateSingleGasTo:(NSString **)to value:(NSString **)value data:(NSString **)data
{
    if ([WalletTools isEmpty:*to]) {
        *to = @"";
    }
    
    if ([WalletTools isEmpty:*value]) {
        *value = @"";
    }
    
    if ([WalletTools isEmpty:*data]) {
        *data = @"";
    }
    
    int txGas = 5000;
    int clauseGas = 16000;
    int clauseGasContractCreation = 48000;
    
    if ((*data).length == 0 ) {
        return txGas + clauseGas;
    }
    int sum = txGas;
    
    if ((*to).length > 0) {
        sum += clauseGas;
    } else {
        sum += clauseGasContractCreation;
    }
    
    sum += [self dataGas:(*data)];
    return sum ;
}

+ (int)dataGas:(NSString *)data {
    int zgas = 4;
    int nzgas = 68;
    
    int sum = 0;
    for (int i = 2; i < data.length; i += 2) {
        NSString *subStr = [data substringWithRange:NSMakeRange(i, 2)];
        if ([subStr isEqualToString: @"00"]) {
            sum += zgas;
        } else {
            sum += nzgas;
        }
    }
    return sum;
}

@end
