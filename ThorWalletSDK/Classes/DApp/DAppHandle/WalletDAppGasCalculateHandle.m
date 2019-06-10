//
//  WalletDAppGasCalculateHandle.m
//  AFNetworking
//
//  Created by 曾新 on 2019/6/6.
//

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
