//
//  WalletDappCheckParamsHandle.m
//  WalletSDK
//
//  Created by 曾新 on 2019/4/2.
//  Copyright © 2019年 Ethers. All rights reserved.
//
#import "WalletDAppHead.h"
#import "WalletDappCheckParamsHandle.h"

@implementation WalletDappCheckParamsHandle

+ (void)checkParamClause:(TransactionParameter *)parameterModel
                callback:(void(^)(NSString *error,bool result))callback
{
    for (ClauseModel * clauseModel in parameterModel.clauses) {
        
        NSString *to = clauseModel.to;
        if (![self checkTo:&to]) {
            if (callback) {
                callback(@"to inValid",NO);
            }
            return ;
        }
        clauseModel.to = to;
        
        NSString *value = clauseModel.value;
        if (![self checkValue:&value]) {
            if (callback) {
                callback(@"value inValid",NO);
            }
            return ;
        }
        clauseModel.value = value;
        
        NSString *data = clauseModel.data;
        if (![self checkData:&data]) {
            if (callback) {
                callback(@"data inValid",NO);
            }
            return ;
        }
        clauseModel.data = data;
        
        if (![self isRightClause:clauseModel]) {
            if (callback) {
                callback(@"clause inValid",NO);
            }
            return ;
        }
        
        // 如果是vtho 转账，amount不能有值
        if ([clauseModel.to isEqualToString:vthoTokenAddress]) {
            
            if (![WalletTools isEmpty:clauseModel.value]) {
                if (callback) {
                    callback(@"value inValid",NO);
                }
                return ;
            }
        }
    }
    
    NSString *gas = parameterModel.gas;
    if (![self checkGas:&gas]) {
        if (callback) {
            callback(@"gas inValid",NO);
        }
        return ;
    }
    parameterModel.gas = gas;
    
    
    if (![self checkChainTag:parameterModel.chainTag]) {
        if (callback) {
            callback(@"chainTag inValid",NO);
        }
        return ;
    }
    
    if (![self checkBlockRef:parameterModel.blockRef]) {
        if (callback) {
            callback(@"blockRef inValid",NO);
        }
        return ;
    }
    
    if (![self checkNoce:parameterModel.noce]) {
        if (callback) {
            callback(@"noce inValid",NO);
        }
        return ;
    }
    
    NSString *gasPriceCoef = parameterModel.gasPriceCoef;
    if (![self checkGasPriceCoef:&(gasPriceCoef)]) {
        if (callback) {
            callback(@"gasPriceCoef inValid",NO);
        }
        return ;
    }
    
    parameterModel.gasPriceCoef = gasPriceCoef;
    
    NSString *expiration = parameterModel.expiration;

    if (![self checkExpiration:&expiration]) {
        if (callback) {
            callback(@"gasPriceCoef inValid",NO);
        }
        return ;
    }
    parameterModel.expiration = expiration;
    
    callback(@"",YES);
    
}

+ (BOOL)checkChainTag:(NSString *)chainTag
{
    if (chainTag.length != 4) {
        return NO;
    }
    if (![WalletTools checkHEXStr:chainTag] ) {
        return NO;
    }
    return YES;
}

+ (BOOL)checkBlockRef:(NSString *)blockRef
{
    if (blockRef.length != 18) {
        return NO;
    }
    if (![WalletTools checkHEXStr:blockRef] ) {
        return NO;
    }
    return YES;
}

+ (BOOL)checkNoce:(NSString *)noce
{
    if (noce.length != 18) {
        return NO;
    }
    if (![WalletTools checkHEXStr:noce] ) {
        return NO;
    }
    return YES;
}

+ (BOOL)checkGasPriceCoef:(NSString **)gasPriceCoef
{
    if ((*gasPriceCoef).length == 0) {
        *gasPriceCoef = 0;
        return YES;
    }else{
        if (![WalletTools checkDecimalStr:*gasPriceCoef]) {
            return NO;
        }
    }
    
    return YES;
}

+ (BOOL)checkExpiration:(NSString **)expiration
{
    if (![WalletTools checkDecimalStr:(*expiration)]) {
        return NO;
    }else{
        if ((*expiration).integerValue == 0) {
            *expiration = @"720";
            return YES;
        }
    }
    return YES;
}

+ (BOOL)isRightClause:(ClauseModel *)clauseModel
{
    if ([WalletTools isEmpty:clauseModel.to]) {
        
        if ([WalletTools isEmpty:clauseModel.data]) {
            return NO;
        }else{
            //全是0 不给过
            NSString *datadecimal = [BigNumber bigNumberWithHexString:clauseModel.data].decimalString;
            if (datadecimal.integerValue == 0) {
                return NO;
            }
        }
        
    }else{ // to 有值
        if (![WalletTools isEmpty:clauseModel.data]) {
            
            if ([clauseModel.data isEqualToString:@"0x"]) { //0x， 是null 的情况
                return NO;
            }
            
            // 被64 整除
            if (clauseModel.data.length >= 10) {
                NSInteger i = (clauseModel.data.length - 10) % 64;
                if (i != 0) {
                    return NO;
                }
            }else{
                return NO;
            }
            
        }else{
            //to != nil data = nil value != nil
            if ([WalletTools isEmpty:clauseModel.value]) {
                return NO;
            }
        }
    }
    

    return YES;
}

+ (BOOL)checkTo:(NSString **)to
{
    if ([WalletTools isEmpty:*to]) {
        *to = @"";
        return YES;
    }
    
    if ([*to isKindOfClass:[NSString class]]) {
        
        if (![WalletTools errorAddressAlert:*to]) { //校验地址
            return NO;
        }
    }else{
        return NO;
    }
    return YES;
}

+ (BOOL)checkValue:(NSString **)value
{
    if ([WalletTools isEmpty:*value]) {
        *value = @"0";
        return YES;
    }
    // value 可以是string 或者 number
    if ([*value isKindOfClass:[NSString class]] || [*value isKindOfClass:[NSNumber class]]) {
        
        //有可能是bool 值
        if ([self checkNumberOriginBool:*value]) {
            return NO;
        }
        
        *value = [NSString stringWithFormat:@"%@",*value];
        if ([WalletTools checkDecimalStr:*value]) {//是10进制
            return YES;
        }else if ([WalletTools checkHEXStr:*value]){// 16进制
            *value = [BigNumber bigNumberWithHexString:*value].decimalString;
            return YES;
        }else{ //既不是10进制，也不是 16进制
            return NO;
        }
        
    }else{
        return NO;
    }
    return YES;
}

+ (BOOL)checkData:(NSString **)data
{
    if ([WalletTools isEmpty:*data]) {
        *data = @"";
        return YES;
    }
    
    if ([*data isKindOfClass:[NSString class]] ) {
        if ([WalletTools checkHEXStr:*data]) {
            
            if ((*data).length == 0) {
                return YES; // 长度可以是0
            }else if ((*data).length >= 10) { //长度大于10 ok
                return YES;
            }else { //长度 1 - 9
                
                if ([*data isEqualToString:@"0x"]) { //0x, ok
                    return YES;
                }
                return NO;
            }
            
        }else{
            return NO;
        }
    }else{
        return NO;
    }
    return YES;
}

+ (BOOL)checkGas:(NSString **)gas
{
    if ([WalletTools isEmpty:*gas]) {
        return NO;
    }
    // gas 可以是string 或者 number
    if ([*gas isKindOfClass:[NSString class]]
        || [*gas isKindOfClass:[NSNumber class]]) {
        
        //有可能是bool 值
        if ([self checkNumberOriginBool:*gas]) {
            return NO;
        }
        
        *gas = [NSString stringWithFormat:@"%@",*gas];
        if ([WalletTools checkDecimalStr:*gas]) {//是10进制
            
        }else if ([WalletTools checkHEXStr:*gas]){// 16进制
            *gas = [BigNumber bigNumberWithHexString:*gas].decimalString;
        }else{ //既不是10进制，也不是 16进制
            return NO;
        }
        
        if ((*gas).integerValue == 0) { //gas 数值不能是 0
            return NO;
        }
        
    }else{
        return NO;
    }
    return YES;
}

+ (BOOL)checkGasPrice
{
    return YES;
}


+ (BOOL)checkNumberOriginBool:(id)data {
    
    if ([data isKindOfClass:[NSNumber class]]) {
        const char * pObjCType = [((NSNumber*)data) objCType];
        
        if (strcmp(pObjCType, @encode(_Bool)) == 0
            || strcmp([data objCType], @encode(char)) == 0) {
            return YES;
        }
        return NO;
    }
    return NO;
}

@end
