//
//  TransactionParameter.m
//  WalletSDK
//
//  Created by Tom on 2019/4/7.
//  Copyright © 2019年 Ethers. All rights reserved.
//

#import "TransactionParameter.h"
#import "YYModel.h"

@implementation TransactionParameter

- (void)checkParameter:(void(^)(NSString *error,bool result))callback
{
    NSString *errorMsg = @"";
    for (ClauseModel * clauseModel in self.clauses) {
        
        NSString *to = clauseModel.to;
        if (![self checkTo:&to errorMsg:&errorMsg]) {
            if (callback) {
                callback(errorMsg,NO);
            }
            return ;
        }
        clauseModel.to = to;
        
        NSString *value = clauseModel.value;
        if (![self checkValue:&value errorMsg:&errorMsg]) {
            if (callback) {
                callback(errorMsg,NO);
            }
            return ;
        }
        clauseModel.value = value;
        
        NSString *data = clauseModel.data;
        if (![self checkData:&data errorMsg:&errorMsg]) {
            if (callback) {
                callback(errorMsg,NO);
            }
            return ;
        }
        clauseModel.data = data;
        
        if (![self isRightClause:clauseModel errorMsg:&errorMsg]) {
            if (callback) {
                callback(errorMsg,NO);
            }
            return ;
        }
    }
    
    NSString *gas = self.gas;
    if (![self checkGas:&gas errorMsg:&errorMsg]) {
        if (callback) {
            callback(errorMsg,NO);
        }
        return ;
    }
    self.gas = gas;
    
    
    if (![self checkChainTag:self.chainTag errorMsg:&errorMsg]) {
        if (callback) {
            callback(errorMsg,NO);
        }
        return ;
    }
    
    if (![self checkBlockRef:self.blockReference errorMsg:&errorMsg]) {
        if (callback) {
            callback(errorMsg,NO);
        }
        return ;
    }
    
    if (![self checkNoce:self.nonce errorMsg:&errorMsg]) {
        if (callback) {
            callback(errorMsg,NO);
        }
        return ;
    }
    
    NSString *gasPriceCoef = self.gasPriceCoef;
    if (![self checkGasPriceCoef:&(gasPriceCoef) errorMsg:&errorMsg]) {
        if (callback) {
            callback(errorMsg,NO);
        }
        return ;
    }
    
    self.gasPriceCoef = gasPriceCoef;
    
    NSString *expiration = self.expiration;
    
    if (![self checkExpiration:&expiration errorMsg:&errorMsg]) {
        if (callback) {
            callback(errorMsg,NO);
        }
        return ;
    }
    self.expiration = expiration;
    
    
    if (![self checkDependsOn:self.dependsOn errorMsg:&errorMsg]) {
        if (callback) {
            callback(errorMsg,NO);
        }
        return ;
    }
    
    callback(@"",YES);
    
}

- (BOOL)checkDependsOn:(NSString *)dependsOn errorMsg:(NSString **)errorMsg
{
    if ([WalletTools isEmpty:dependsOn]) {
        
        return YES;
    }else{
        if ([WalletTools checkHEXStr:dependsOn]) {
            return YES;
        }else
        {
            *errorMsg = @"dependsOn should be hex string";
            return NO;
        }
    }
}

- (BOOL)checkChainTag:(NSString *)chainTag errorMsg:(NSString **)errorMsg
{
    if (chainTag.length != 4) {
        *errorMsg = @"chainTag is not the right length";
        
        return NO;
    }
    if (![WalletTools checkHEXStr:chainTag] ) {
        *errorMsg = @"chainTag should be hex string";
        
        return NO;
    }
    return YES;
}

- (BOOL)checkBlockRef:(NSString *)blockRef errorMsg:(NSString **)errorMsg
{
    if (blockRef.length != 18) {
        *errorMsg = @"blockRef is not the right length";
        
        return NO;
    }
    if (![WalletTools checkHEXStr:blockRef] ) {
        *errorMsg = @"blockRef should be hex string";
        
        return NO;
    }
    return YES;
}

- (BOOL)checkNoce:(NSString *)nonce errorMsg:(NSString **)errorMsg
{
    if (nonce.length != 18) {
        *errorMsg = @"nonce is not the right length";
        
        return NO;
    }
    if (![WalletTools checkHEXStr:nonce] ) {
        *errorMsg = @"nonce should be hex string";
        
        return NO;
    }
    return YES;
}

- (BOOL)checkGasPriceCoef:(NSString **)gasPriceCoef errorMsg:(NSString **)errorMsg
{
    if ([WalletTools isEmpty:*gasPriceCoef]) {
        *gasPriceCoef = @"0";
        return YES;
    }else{
        *gasPriceCoef = [NSString stringWithFormat:@"%@",*gasPriceCoef];
        
        if (![WalletTools checkDecimalStr:*gasPriceCoef]) {
            *errorMsg = @"gasPriceCoef should be decimal string";
            return NO;
        }else{
            NSInteger intGasPriceCoef = (*gasPriceCoef).integerValue;
            if (intGasPriceCoef >= 0 && intGasPriceCoef <= 255) {
                return YES;
            }else{
                *errorMsg = @"gasPriceCoef is an integer type from 0 to 255";
                
                return NO;
            }
        }
    }
    
    return YES;
}

- (BOOL)checkExpiration:(NSString **)expiration errorMsg:(NSString **)errorMsg
{
    
    //强转 string
    *expiration = [NSString stringWithFormat:@"%@",*expiration];
    
    if ([WalletTools isEmpty:*expiration]) {
        *expiration = @"720";
        return YES;
    }
    
    if (![WalletTools checkDecimalStr:(*expiration)]) {
        *errorMsg = @"expiration should be decimal string";
        
        return NO;
    }
    return YES;
}

- (BOOL)isRightClause:(ClauseModel *)clauseModel errorMsg:(NSString **)errorMsg
{
    if ([WalletTools isEmpty:clauseModel.to]) {
        
        if ([WalletTools isEmpty:clauseModel.data]) {
            *errorMsg = @"clause is invalid";
            return NO;
        }
        
    }else{ // to 有值，需要判断 data 的被64 整除
        if (![WalletTools isEmpty:clauseModel.data]) {
            
            // 被64 整除
            if (clauseModel.data.length >= 10) {
                NSInteger i = (clauseModel.data.length - 10) % 64;
                if (i != 0) {
                    *errorMsg = @"clause is invalid";
                    return NO;
                }
            }
            else{
                if ([clauseModel.data isEqualToString:@"0x"]) { //0x， 是null 的情况
                    return YES;
                }else{
                    *errorMsg = @"clause is invalid";
                    return NO;
                }
            }
            
        }else{
            //to != nil data = nil value == nil
            if ([WalletTools isEmpty:clauseModel.value]) {
                *errorMsg = @"clause is invalid";
                return NO;
            }
        }
    }
    
    return YES;
}

- (BOOL)checkTo:(NSString **)to errorMsg:(NSString **)errorMsg
{
    if ([WalletTools isEmpty:*to]) {
        *to = @"";
        return YES;
    }
    
    if ([*to isKindOfClass:[NSString class]]) {
        
        if (![WalletTools errorAddressAlert:*to]) { //校验地址
            *errorMsg = @"to is invild";
            return NO;
        }
    }else{
        *errorMsg = @"to should be NSString";
        return NO;
    }
    return YES;
}

- (BOOL)checkValue:(NSString **)value errorMsg:(NSString **)errorMsg
{
    if ([WalletTools isEmpty:*value]) {
        *value = @"0";
        return YES;
    }
    // value 可以是string 或者 number
    if ([*value isKindOfClass:[NSString class]] || [*value isKindOfClass:[NSNumber class]]) {
        
        //有可能是bool 值
        if ([self checkNumberOriginBool:*value]) {
            *errorMsg = @"value should be NSString or NSNumber";
            return NO;
        }
        
        *value = [NSString stringWithFormat:@"%@",*value];
        
        if ([(*value) isEqualToString:@"0x"]) { // 0x 设置为空
            *value = @"";
            return YES;
        }
        
        if ([WalletTools checkDecimalStr:*value]) {//是10进制
            return YES;
        }else if ([WalletTools checkHEXStr:*value]){// 16进制
            *value = [BigNumber bigNumberWithHexString:*value].decimalString;
            return YES;
        }else{ //既不是10进制，也不是 16进制
            *errorMsg = @"value should be NSString or NSNumber";
            return NO;
        }
        
    }else{
        *errorMsg = @"value should be NSString or NSNumber";
        return NO;
    }
    return YES;
}

- (BOOL)checkData:(NSString **)data errorMsg:(NSString **)errorMsg
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
                    *data = @"";
                    
                    return YES;
                }else{
                    *errorMsg = @"data is inValid";
                    return NO;
                }
            }
        }else{
            *errorMsg = @"data should be hex string";
            return NO;
        }
    }else{
        *errorMsg = @"data should be hex string";
        return NO;
    }
    return YES;
}

- (BOOL)checkGas:(NSString **)gas errorMsg:(NSString **)errorMsg
{
    if ([WalletTools isEmpty:*gas]) {
        *errorMsg = @"gas can't be empty";
        
        return NO;
    }
    // gas 可以是string 或者 number
    if ([*gas isKindOfClass:[NSString class]]
        || [*gas isKindOfClass:[NSNumber class]]) {
        
        //有可能是bool 值
        if ([self checkNumberOriginBool:*gas]) {
            *errorMsg = @"gas should be NSString or NSNumber";
            return NO;
        }
        
        // gas 不能为0 ，打于0
        *gas = [NSString stringWithFormat:@"%@",*gas];
        
        if ([WalletTools checkDecimalStr:*gas]) {//是10进制
            if((*gas).integerValue == 0)
            {
                *errorMsg = @"gas can't be 0";
                return NO;
            }
            return YES;
        }else{ //不是10进制
            *errorMsg = @"gas should be decimal string";
            return NO;
        }
        
    }else{
        *errorMsg = @"gas should be NSString or NSNumber";
        return NO;
    }
    return YES;
}


- (BOOL)checkNumberOriginBool:(id)data {
    
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

- (void)setGas:(NSString *)gas
{
    _gas = gas;
}

- (void)setGasPriceCoef:(NSString * _Nonnull)gasPriceCoef
{
    _gasPriceCoef = gasPriceCoef;
}

- (void)setExpiration:(NSString * _Nonnull)expiration
{
    _expiration = expiration;
}

- (void)setChainTag:(NSString * _Nonnull)chainTag
{
    _chainTag = chainTag;
}

- (void)setBlockReference:(NSString * _Nonnull)blockReference
{
    _blockReference = blockReference;
}

- (void)setNonce:(NSString * _Nonnull)nonce
{
    _nonce = nonce;
}

- (void)setClauses:(NSArray * _Nonnull)clauses
{
    _clauses = clauses;
}

- (void)setDependsOn:(NSString * _Nonnull)dependsOn
{
    _dependsOn = dependsOn;
}

- (void)setReserveds:(NSArray<NSData *> * _Nonnull)reserveds
{
    _reserveds = reserveds;
}

+ (TransactionParameter *)creatTransactionParameter:(void(^)(TransactionParameterBuiler *builder))callback checkParams:(void(^)(NSString *errorMsg))checkParamsCallback
{
    TransactionParameterBuiler *builder = [[TransactionParameterBuiler alloc]init];

    callback(builder);
    
    TransactionParameter *transactionModel = [builder build];
    __block BOOL hasError = NO;
    [transactionModel checkParameter:^(NSString *error, bool result) {
        
        checkParamsCallback(error);
        if (!result) {
            hasError = YES;
        }
    }];
    
    return hasError ? nil : transactionModel;
}

@end

@implementation ClauseModel

@end


@implementation TransactionParameterBuiler

- (TransactionParameter *)build
 {
     TransactionParameter *transactionModel = [[TransactionParameter alloc] init];
     
     transactionModel.chainTag          = self.chainTag;
     transactionModel.blockReference    = self.blockReference;
     transactionModel.nonce             = self.nonce;
     transactionModel.clauses           = self.clauses;
     transactionModel.gas               = self.gas;
     transactionModel.expiration        = self.expiration;
     transactionModel.gasPriceCoef      = self.gasPriceCoef;
     
     //不强制
     transactionModel.dependsOn = self.dependsOn;
     transactionModel.reserveds = self.reserveds;
     
     return transactionModel;
 }

@end
